"""
Scan API routes for Deepfake Authentication Gateway.
Provides the main POST /scan endpoint for media analysis.
"""

import asyncio
import logging
from decimal import Decimal
from typing import Annotated, Any

from fastapi import (
    APIRouter,
    Depends,
    File,
    HTTPException,
    Request,
    UploadFile,
    status,
)
from fastapi.responses import JSONResponse

from app.api.dependencies import (
    CurrentUserId,
    ValidatedUser,
    rate_limiter,
    verify_firebase_token,
)
from app.core.config import settings
from app.core.security import (
    FileInfo,
    FileTooSmallError,
    InvalidFileSignatureError,
    generate_file_hash,
    verify_file_signature,
)
from app.models.schemas import (
    ErrorResponse,
    ScanResponse,
    ScanStatus,
)
from app.services.hf_client import (
    HFAPIConnectionError,
    HFAPIResponseError,
    HFTimeoutError,
    analyze_deepfake,
)
from app.services.firestore_db import (
    DatabaseError,
    check_hash_exists,
    get_scan_by_id,
    get_user_scans,
    get_user_stats,
    log_scan,
    update_scan_status,
)

from app.services.gemini_client import run_gemini_analysis
from app.services.real_gemini_client import analyze_with_gemini

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/scan", tags=["scans"])

MAX_UPLOAD_SIZE = settings.MAX_FILE_SIZE
CHUNK_SIZE = 1024 * 1024


def sanitize_filename(filename: str) -> str:
    """Sanitize filename to prevent path traversal attacks."""
    forbidden = ["../", "..\\", "\x00", "<", ">", ":", '"', "|", "?", "*"]
    for char in forbidden:
        if char in filename:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Filename contains forbidden character sequence"
            )
    return filename.strip().split("/")[-1].split("\\")[-1]


@router.post(
    "",
    response_model=ScanResponse,
    responses={
        400: {"model": ErrorResponse, "description": "Invalid file or request"},
        401: {"model": ErrorResponse, "description": "Unauthorized"},
        413: {"model": ErrorResponse, "description": "File too large"},
        429: {"model": ErrorResponse, "description": "Rate limit exceeded"},
        500: {"model": ErrorResponse, "description": "Internal server error"},
        503: {"model": ErrorResponse, "description": "AI service unavailable"},
    },
    summary="Analyze media file for deepfakes",
    description="Upload a media file for deepfake detection analysis. "
                "Supports images, videos, and audio files.",
)
async def create_scan(
    request: Request,
    user_id: CurrentUserId,
    file: Annotated[UploadFile, File(..., description="Media file to analyze")],
    _: ValidatedUser,
    __: None = Depends(rate_limiter)
) -> ScanResponse:
    """
    Analyze uploaded media file for deepfake content.
    
    Flow:
    1. Authenticate user via JWT
    2. Validate file signature (magic bytes)
    3. Generate SHA-256 hash
    4. Check for existing scan (deduplication)
    5. If new, send to Hugging Face API
    6. Log result to database
    7. Return analysis results
    
    Security measures:
    - File signature validation (ignores extension)
    - Memory-efficient streaming for large files
    - Rate limiting
    - Cryptographic deduplication
    """
    filename = sanitize_filename(file.filename or "unknown")
    
    logger.info(f"User {user_id} starting scan for file: {filename}")
    
    content_length = request.headers.get("content-length")
    if content_length and int(content_length) > MAX_UPLOAD_SIZE:
        raise HTTPException(
            status_code=status.HTTP_413_REQUEST_ENTITY_TOO_LARGE,
            detail=f"File exceeds maximum size of {MAX_UPLOAD_SIZE / (1024**2):.1f}MB"
        )
    
    try:
        file_chunks = []
        total_size = 0
        
        while True:
            chunk = await file.read(1024 * 1024)  # 1MB chunks
            if not chunk:
                break
                
            total_size += len(chunk)
            
            if total_size > MAX_UPLOAD_SIZE:
                logger.warning(
                    f"File too large: {filename} ({total_size} bytes > {MAX_UPLOAD_SIZE})"
                )
                raise HTTPException(
                    status_code=status.HTTP_413_REQUEST_ENTITY_TOO_LARGE,
                    detail=f"File exceeds maximum size of {MAX_UPLOAD_SIZE / (1024**3):.1f}GB"
                )
            
            file_chunks.append(chunk)
        
        if not file_chunks:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Empty file received"
            )
        
        file_bytes = b"".join(file_chunks)
        logger.debug(f"File loaded: {filename}, size={total_size} bytes")
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error reading file: {e}")
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Failed to read file: {str(e)}"
        )
    finally:
        await file.close()
    
    try:
        file_info = verify_file_signature(file_bytes)
        logger.info(
            f"File signature verified: {filename} -> {file_info.signature.value} "
            f"({file_info.mime_type})"
        )
    except FileTooSmallError as e:
        logger.warning(f"File too small: {filename} - {e.message}")
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
    except InvalidFileSignatureError as e:
        logger.warning(f"Invalid file signature: {filename} - {e.message}")
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid or unsupported file format. File signature verification failed."
        )

    # --- VIDEO INTERCEPTOR BLOCK ---
    if "video" in str(file.content_type).lower() or file.filename.lower().endswith((".mp4", ".avi", ".mov")):
        import tempfile
        import cv2
        import os
        import logging
        
        logging.info(f"[VIDEO FLOW] Video payload detected: {file.filename}. Starting frame extraction...")
        
        temp_vid = tempfile.NamedTemporaryFile(delete=False, suffix=".mp4")
        temp_path = temp_vid.name
        temp_vid.write(file_bytes)
        temp_vid.close() # Critical for Windows
            
        try:
            cap = cv2.VideoCapture(temp_path)
            total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
            
            if total_frames > 0:
                # Calculate frame positions at 10%, 40%, 70%, and 90% of the video
                timestamps = [int(total_frames * 0.1), int(total_frames * 0.4), int(total_frames * 0.7), int(total_frames * 0.9)]
                frames = []
                
                for ts in timestamps:
                    cap.set(cv2.CAP_PROP_POS_FRAMES, ts)
                    success, frame = cap.read()
                    if success:
                        # Resize to keep the final grid manageable but high quality (1024x1024 per frame)
                        frame = cv2.resize(frame, (1024, 1024))
                        frames.append(frame)
                
                # If we successfully grabbed 4 frames, stitch them into a 2x2 grid
                if len(frames) == 4:
                    import numpy as np
                    top_row = np.hstack((frames[0], frames[1]))
                    bottom_row = np.hstack((frames[2], frames[3]))
                    sprite_sheet = np.vstack((top_row, bottom_row))
                    
                    # Encode the 2x2 grid to JPEG with high quality
                    is_success, buffer = cv2.imencode(".jpg", sprite_sheet, [int(cv2.IMWRITE_JPEG_QUALITY), 90])
                    if is_success:
                        file_bytes = buffer.tobytes()
                        
                        # OVERRIDE LOCAL VARIABLE ONLY. Do NOT touch file.content_type!
                        content_type = "image/jpeg"
                        file_info.media_type = "image"
                        file_info.mime_type = "image/jpeg"
                        
                        logging.info(f"[VIDEO EXTRACT] Created 2x2 Temporal Sprite Sheet. Size: {len(file_bytes)} bytes.")
                    else:
                        logging.error("[VIDEO EXTRACT] cv2.imencode failed to convert sprite sheet.")
                else:
                    logging.error(f"[VIDEO EXTRACT] Failed to extract 4 frames. Grabbed {len(frames)}.")
            else:
                logging.error("[VIDEO EXTRACT] cv2.VideoCapture returned 0 frames.")
                
            # CRITICAL: Release the lock immediately before doing anything else
            cap.release()
        except Exception as e:
            logging.error(f"[VIDEO EXTRACT] CRITICAL EXCEPTION: {str(e)}")
            if 'cap' in locals():
                cap.release() # Fallback release
        finally:
            # Safely attempt to remove the file
            if os.path.exists(temp_path):
                try:
                    os.remove(temp_path)
                except Exception as cleanup_error:
                    logging.warning(f"[VIDEO EXTRACT] Could not remove temp file: {cleanup_error}")
    # --- END VIDEO INTERCEPTOR ---
    
    file_hash = generate_file_hash(file_bytes)
    logger.debug(f"Generated hash for {filename}: {file_hash[:16]}...")
    
    # Bypass deduplication cache – always perform fresh analysis
    # The following block is intentionally disabled to force full AI pipeline on every upload.
    # try:
    #     existing_scan = await check_hash_exists(file_hash, user_id)
    #
    #     if existing_scan and existing_scan.get("threat_score") is not None:
    #         logger.info(
    #             f"Returning cached result for {filename} "
    #             f"(hash={file_hash[:16]}..., score={existing_scan.get('threat_score')})"
    #         )
    #
    #         return ScanResponse(
    #             id=existing_scan.get("id"),
    #             user_id=user_id,
    #             file_name=filename,
    #             file_hash=file_hash,
    #             threat_score=Decimal(str(existing_scan.get("threat_score", 0))),
    #             status=ScanStatus.COMPLETED,
    #             media_type=file_info.media_type,
    #             file_size=total_size,
    #             result_details=existing_scan.get("result_details"),
    #             created_at=existing_scan.get("created_at"),
    #             completed_at=existing_scan.get("created_at"),
    #         )
    #
    # except DatabaseError as e:
    #     logger.error(f"Database error during deduplication check: {e}")
    
    pending_scan = None
    try:
        pending_scan = await log_scan(
            user_id=user_id,
            file_name=filename,
            file_hash=file_hash,
            threat_score=Decimal("0"),
            status=ScanStatus.PROCESSING,
            media_type=file_info.media_type,
            file_size=total_size,
            result_details={"stage": "processing"}
        )
        logger.info(f"Created pending scan record: {pending_scan.get('id')}")
    except DatabaseError as e:
        logger.error(f"Failed to create pending scan: {e}")
    
    # ─────────────────────────────────────────────────────────────────────
    # TIER-1 ── HuggingFace Mathematical Pre-Screen
    # ─────────────────────────────────────────────────────────────────────
    # ZERO-TRUST MODE: The HF score is recorded as context but can NO LONGER
    # unilaterally approve a payload.  ALL image payloads proceed to Tier-2.
    # (Non-image types still use the HF score as the sole signal.)
    # ─────────────────────────────────────────────────────────────────────

    hf_score_normalized: float = 0.0
    gemini_verdict: str = "AUTHENTIC"
    gemini_reasoning: str = "Cleared by Tier 1 mathematical scan."
    tier_used: int = 1
    status_value = ScanStatus.COMPLETED
    result_details: dict = {}
    analysis_result = None
    gemini_model_used = ""
    gemini_confidence = None
    gemini_tier = ""
    # Tier-3 Google Gemini defaults (only populated for images)
    real_gemini_verdict    = "ANALYSIS_FAILED"
    real_gemini_reasoning  = ""
    real_gemini_confidence = None

    content_type = file.content_type

    if content_type and content_type.startswith("audio/"):
        logger.info(f"[SECURITY OVERRIDE] Audio file '{filename}' detected. Bypassing HuggingFace to prevent model crash.")
        try:
            from app.services.gemini_client import run_gemini_analysis
            gemini_result = await run_gemini_analysis(file_bytes, 1.0)
            gemini_verdict = gemini_result.get("gemini_verdict", "AUTHENTIC")
            gemini_reasoning = gemini_result.get("gemini_reasoning", "")
            gemini_model_used = gemini_result.get("gemini_model_used", "")
            gemini_confidence = gemini_result.get("gemini_confidence", None)
            gemini_tier = "tier-2-direct"
            
            hf_score_normalized = 0.85 if gemini_verdict == "DEEPFAKE" else 0.15
            tier_used = 2
            status_value = ScanStatus.COMPLETED
        except Exception as gemini_err:
            logger.error(f"[AUDIO BYPASS] Gemini unavailable: {gemini_err}")
            hf_score_normalized = 0.0
            gemini_verdict = "ANALYSIS_FAILED"
            gemini_reasoning = f"Direct Tier-2 Audio Analysis failed: {str(gemini_err)}"
            gemini_tier = "tier-2-failed"
            tier_used = 2
            status_value = ScanStatus.FAILED
    else:
        try:
            logger.info(f"[TIER-1] Dispatching '{filename}' to HuggingFace deepfake model …")
            analysis_result = await analyze_deepfake(file_bytes, file_info)
    
            hf_score_normalized = analysis_result.probability_score / 100.0
            logger.info(
                f"[TIER-1] Result for '{filename}': "
                f"raw_score={analysis_result.probability_score:.4f}%, "
                f"normalised={hf_score_normalized:.4f}, "
                f"model={analysis_result.model_used}"
            )
    
        except Exception as e:
            logger.error(f"[TIER-1] HuggingFace error for '{filename}': {e}")
            hf_score_normalized = 1.0
            status_value = ScanStatus.FAILED
    
        if file_info.media_type == "image":
            logger.info(
                f"[SECURITY OVERRIDE] Running NVIDIA + Gemini in parallel on '{filename}'."
            )
            try:
                # ── Run NVIDIA NIM and Google Gemini Flash simultaneously ───────────
                nvidia_task  = run_gemini_analysis(file_bytes, hf_score_normalized)
                real_gemini_task = analyze_with_gemini(file_bytes, hf_score_normalized)

                nvidia_result, real_gemini_result = await asyncio.gather(
                    nvidia_task, real_gemini_task, return_exceptions=True
                )

                # ── NVIDIA result ─────────────────────────────────────────────────
                if isinstance(nvidia_result, Exception):
                    logger.warning(f"[TIER-2/NVIDIA] Failed: {nvidia_result}")
                    nvidia_result = {"gemini_verdict": "ANALYSIS_FAILED", "gemini_reasoning": str(nvidia_result)}

                gemini_verdict     = nvidia_result.get("gemini_verdict", "AUTHENTIC")
                gemini_reasoning   = nvidia_result.get("gemini_reasoning", "")
                gemini_model_used  = nvidia_result.get("gemini_model_used", "")
                gemini_confidence  = nvidia_result.get("gemini_confidence", None)
                gemini_tier        = nvidia_result.get("tier", "tier-2")

                # ── Real Gemini Flash result ──────────────────────────────────
                if isinstance(real_gemini_result, Exception):
                    logger.warning(f"[TIER-3/GEMINI] Failed: {real_gemini_result}")
                    real_gemini_result = {"gemini_verdict": "ANALYSIS_FAILED"}

                real_gemini_verdict    = real_gemini_result.get("gemini_verdict", "AUTHENTIC")
                real_gemini_confidence = real_gemini_result.get("gemini_confidence", None)  # 0-100
                real_gemini_reasoning  = real_gemini_result.get("gemini_reasoning", "")

                logger.info(
                    f"[TIER-3/GEMINI] Verdict={real_gemini_verdict} "
                    f"Confidence={real_gemini_confidence} | {real_gemini_reasoning[:80]}"
                )

                tier_used    = 3
                status_value = ScanStatus.COMPLETED

            except Exception as err:
                logger.warning(f"[TIER-2/3] Both AI models failed: {err}")
                gemini_verdict = "DEEPFAKE" if hf_score_normalized >= 0.5 else "AUTHENTIC"
                gemini_reasoning = f"AI models unavailable. Verdict from HF score ({hf_score_normalized*100:.1f}%)."
                gemini_model_used = ""
                gemini_confidence = None
                gemini_tier = "tier-1-fallback"
                real_gemini_verdict = "ANALYSIS_FAILED"
                real_gemini_confidence = None
                real_gemini_reasoning = ""
                tier_used = 1
        else:
            # Video: keep original threshold-based logic
            HF_SUSPICION_THRESHOLD = 0.20
            if hf_score_normalized >= HF_SUSPICION_THRESHOLD:
                logger.info(
                    f"[TIER-2] Non-image score {hf_score_normalized:.4f} >= {HF_SUSPICION_THRESHOLD}. "
                    f"Escalating '{filename}' to Gemini ..."
                )
                try:
                    from app.services.gemini_client import run_gemini_analysis
                    gemini_result = await run_gemini_analysis(file_bytes, hf_score_normalized)
                    gemini_verdict      = gemini_result.get("gemini_verdict", "AUTHENTIC")
                    gemini_reasoning    = gemini_result.get("gemini_reasoning", "")
                    gemini_model_used   = gemini_result.get("gemini_model_used", "")
                    gemini_confidence   = gemini_result.get("gemini_confidence", None)
                    gemini_tier         = gemini_result.get("tier", "tier-2")
                    tier_used = 2
                except RuntimeError as gemini_err:
                    logger.warning(f"[TIER-2] Gemini unavailable: {gemini_err}")
                    gemini_verdict    = "DEEPFAKE" if hf_score_normalized >= 0.5 else "AUTHENTIC"
                    gemini_reasoning  = f"Tier 2 unavailable. Score: {hf_score_normalized * 100:.2f}%."
                    gemini_model_used = ""
                    gemini_confidence = None
                    gemini_tier       = "tier-1-fallback"
            else:
                logger.info(
                    f"[TIER-1] Non-image score {hf_score_normalized:.4f} < {HF_SUSPICION_THRESHOLD}. "
                    f"Verdict: AUTHENTIC."
                )
                gemini_verdict    = "AUTHENTIC"
                gemini_reasoning  = "Cleared by Tier 1 mathematical scan."
                gemini_model_used = ""
                gemini_confidence = None
                gemini_tier       = "tier-1"

    # ── Build final stats ─────────────────────────────────────────────────
    if analysis_result is not None:
        hf_is_deepfake = analysis_result.is_deepfake
        hf_confidence = analysis_result.confidence_level
        hf_model = analysis_result.model_used
        hf_ms = analysis_result.processing_time_ms
    else:
        hf_is_deepfake = hf_score_normalized >= 0.5
        hf_confidence = "low"
        hf_model = "none"
        hf_ms = 0.0

    # ── 3-Way Ensemble: NVIDIA (50%) + Gemini Flash (30%) + HF (20%) ─────────
    # NVIDIA LLaMA-90B: primary deep visual analysis
    # Google Gemini Flash: mandatory cross-check (hackathon requirement)
    # HuggingFace: fast binary pre-screen (supporting only)
    hf_component = float(hf_score_normalized)

    def _verdict_to_signal(verdict: str, confidence_pct) -> float:
        """Convert a text verdict + confidence% to a 0-1 threat signal."""
        if verdict == "DEEPFAKE":
            return confidence_pct / 100.0 if confidence_pct else 0.82
        elif verdict in ("ELEVATED_RISK", "ANALYSIS_FAILED"):
            return 0.60  # uncertain → slightly suspicious
        else:  # AUTHENTIC
            return 1.0 - (confidence_pct / 100.0) if confidence_pct else 0.18

    nvidia_signal  = _verdict_to_signal(gemini_verdict, gemini_confidence)
    gemini_signal  = _verdict_to_signal(
        real_gemini_verdict,
        real_gemini_confidence,
    )

    # Weights: NVIDIA 50%, Gemini 30%, HF 20%
    # If either AI says DEEPFAKE with high confidence, cap HF at 20% max
    nvidia_w, gemini_w, hf_w = 0.50, 0.30, 0.20

    ensemble_score = (
        nvidia_signal  * nvidia_w +
        gemini_signal  * gemini_w +
        hf_component   * hf_w
    )

    # Hard floor: if BOTH AI models say DEEPFAKE, score cannot go below 0.70
    if gemini_verdict == "DEEPFAKE" and real_gemini_verdict == "DEEPFAKE":
        ensemble_score = max(ensemble_score, 0.70)
        logger.info("[ENSEMBLE] Both AI=DEEPFAKE → floor 0.70 applied.")
    # Soft floor: if either AI says DEEPFAKE, score cannot go below 0.55
    elif gemini_verdict == "DEEPFAKE" or real_gemini_verdict == "DEEPFAKE":
        ensemble_score = max(ensemble_score, 0.55)
        logger.info("[ENSEMBLE] One AI=DEEPFAKE → floor 0.55 applied.")

    # Logic Shield: clamp to [0.0, 1.0]
    threat_score_float = max(0.0, min(1.0, ensemble_score))
    threat_score = Decimal(str(round(threat_score_float, 4)))

    logger.info(
        f"[ENSEMBLE-3WAY] NVIDIA={nvidia_signal:.3f}*{nvidia_w} + "
        f"Gemini={gemini_signal:.3f}*{gemini_w} + "
        f"HF={hf_component:.3f}*{hf_w} = {threat_score_float:.4f}"
    )

    result_details = {
        # ── Tier metadata ─────────────────────────────────────────────────
        "tier_used": tier_used,
        # ── Tier-1 (HuggingFace) fields ───────────────────────────────────
        "hf_score": float(hf_score_normalized),
        "hf_score_pct": float(threat_score),
        "is_deepfake": hf_is_deepfake,
        "confidence_level": hf_confidence,
        "model_used": hf_model,
        "processing_time_ms": hf_ms,
        # ── Tier-2 (NVIDIA NIM — LLaMA-3.2-90B Vision) ───────────────────
        "gemini_verdict": gemini_verdict,
        "gemini_reasoning": gemini_reasoning,
        "gemini_model_used": gemini_model_used,
        "gemini_confidence": gemini_confidence,
        "gemini_tier": gemini_tier,
        # ── Tier-3 (Google Gemini Flash) ─────────────────────────────────
        "real_gemini_verdict": real_gemini_verdict,
        "real_gemini_reasoning": real_gemini_reasoning,
        "real_gemini_confidence": real_gemini_confidence,
    }

    logger.info(
        f"[GATEWAY] '{filename}' FINAL: threat={threat_score}%, "
        f"gemini_verdict={gemini_verdict}, tier={tier_used}"
    )

    
    try:
        if pending_scan:
            updated_scan = await update_scan_status(
                scan_id=pending_scan.get("id"),
                status=status_value,
                threat_score=threat_score,
                result_details=result_details,
                file_name=filename,
                file_hash=file_hash,
                media_type=file_info.media_type,
                file_size=total_size,
            )
        else:
            updated_scan = await log_scan(
                user_id=user_id,
                file_name=filename,
                file_hash=file_hash,
                threat_score=threat_score,
                status=status_value,
                media_type=file_info.media_type,
                file_size=total_size,
                result_details=result_details
            )
            
        logger.info(f"Scan logged: {updated_scan.get('id')}, score={threat_score}")
        
        return ScanResponse(
            id=updated_scan.get("id"),
            user_id=user_id,
            file_name=filename,
            file_hash=file_hash,
            threat_score=threat_score,
            status=status_value,
            media_type=file_info.media_type,
            file_size=total_size,
            result_details=result_details,
            created_at=updated_scan.get("created_at"),
            completed_at=updated_scan.get("completed_at"),
            tier2_confidence=gemini_confidence,
        )
        
    except DatabaseError as e:
        logger.error(f"Failed to log final scan result: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to save scan results"
        )


@router.get(
    "/{scan_id}",
    response_model=ScanResponse,
    responses={
        401: {"model": ErrorResponse, "description": "Unauthorized"},
        404: {"model": ErrorResponse, "description": "Scan not found"},
    },
    summary="Get scan by ID",
)
async def get_scan(
    scan_id: str,
    user_id: CurrentUserId,
    _: ValidatedUser,
) -> ScanResponse:
    """Get a specific scan result by ID."""
    try:
        scan = await get_scan_by_id(scan_id, user_id)
        
        if not scan:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Scan {scan_id} not found"
            )
        
        return ScanResponse(
            id=str(scan.get("id") or ""),
            user_id=str(scan.get("user_id") or ""),
            file_name=str(scan.get("file_name") or ""),
            file_hash=str(scan.get("file_hash") or ""),
            threat_score=Decimal(str(scan.get("threat_score", 0))),
            status=ScanStatus(scan.get("status")),
            media_type=scan.get("media_type"),
            file_size=scan.get("file_size"),
            result_details=scan.get("result_details"),
            created_at=scan.get("created_at"),
            completed_at=scan.get("completed_at"),
            tier2_confidence=scan.get("result_details", {}).get("gemini_confidence") if isinstance(scan.get("result_details"), dict) else None,
        )
        
    except DatabaseError as e:
        logger.error(f"Database error getting scan {scan_id}: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to retrieve scan"
        )


@router.get(
    "",
    response_model=dict,
    responses={
        401: {"model": ErrorResponse, "description": "Unauthorized"},
    },
    summary="List user scans",
)
async def list_scans(
    user_id: CurrentUserId,
    _: ValidatedUser,
    page: int = 1,
    page_size: int = 20,
    status_filter: ScanStatus | None = None,
    media_type: str | None = None,
) -> dict[str, Any]:
    """Get paginated list of user's scans."""
    try:
        scans, total = await get_user_scans(
            user_id=user_id,
            page=page,
            page_size=page_size,
            status_filter=status_filter,
            media_type_filter=media_type
        )
        
        scan_responses = [
            ScanResponse(
                id=str(scan.get("id") or ""),
                user_id=str(scan.get("user_id") or ""),
                file_name=str(scan.get("file_name") or ""),
                file_hash=str(scan.get("file_hash") or ""),
                threat_score=Decimal(str(scan.get("threat_score", 0))),
                status=ScanStatus(scan.get("status")),
                media_type=scan.get("media_type"),
                file_size=scan.get("file_size"),
                result_details=scan.get("result_details"),
                created_at=scan.get("created_at"),
                completed_at=scan.get("completed_at"),
                tier2_confidence=scan.get("result_details", {}).get("gemini_confidence") if isinstance(scan.get("result_details"), dict) else None,
            )
            for scan in scans
        ]
        
        return {
            "scans": scan_responses,
            "total": total,
            "page": page,
            "page_size": page_size,
        }
        
    except DatabaseError as e:
        logger.error(f"Database error listing scans: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to retrieve scans"
        )


@router.get(
    "/stats/summary",
    response_model=dict,
    responses={
        401: {"model": ErrorResponse, "description": "Unauthorized"},
    },
    summary="Get user scan statistics",
)
async def get_stats(
    user_id: CurrentUserId,
    _: ValidatedUser,
) -> dict[str, Any]:
    """Get scan statistics for the authenticated user."""
    try:
        stats = await get_user_stats(user_id)
        return stats
    except DatabaseError as e:
        logger.error(f"Database error getting stats: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to retrieve statistics"
        )
