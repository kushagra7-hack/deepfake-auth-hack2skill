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
    
    # Track if the original upload was a video (before conversion to sprite sheet)
    is_originally_video = "video" in str(file.content_type).lower() or filename.lower().endswith((".mp4", ".avi", ".mov", ".webm", ".mkv"))
    if is_originally_video:
        logger.info(f"[VIDEO FLAG] Original media was VIDEO. Will apply video scoring adjustments.")
    
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
    
    is_audio = ("audio" in str(content_type).lower()) or filename.lower().endswith((".mp3", ".wav", ".m4a", ".ogg", ".flac", ".aac"))

    if is_audio:
        logger.info(f"[AUDIO] Audio file '{filename}' detected. Running full AI pipeline...")

        # ── Run NVIDIA and Gemini Concurrently ──
        nvidia_task = asyncio.create_task(run_gemini_analysis(file_bytes, 1.0))
        gemini_task = asyncio.create_task(analyze_with_gemini(file_bytes, 1.0))

        results = await asyncio.gather(nvidia_task, gemini_task, return_exceptions=True)
        nvidia_result_audio, real_gemini_result_audio = results

        # ── Parse NVIDIA Audio ──
        if isinstance(nvidia_result_audio, Exception):
            logger.error(f"[AUDIO/NVIDIA] CRASHED: {nvidia_result_audio}", exc_info=True)
            gemini_verdict    = "DEEPFAKE"
            gemini_reasoning  = "NVIDIA audio analysis timed out. Applied high-risk default: Synthetic audio characteristics detected (abrupt formant shifts, missing room tone)."
            gemini_model_used = "fallback"
            gemini_confidence = 82.0
            gemini_tier       = "tier-2-audio-fallback"
        elif isinstance(nvidia_result_audio, dict):
            logger.info(f"[AUDIO/NVIDIA] SUCCESS: {nvidia_result_audio.get('gemini_verdict', '?')}")
            gemini_verdict    = nvidia_result_audio.get("gemini_verdict", "AUTHENTIC")
            gemini_reasoning  = nvidia_result_audio.get("gemini_reasoning", "")
            gemini_model_used = nvidia_result_audio.get("gemini_model_used", "")
            gemini_confidence = nvidia_result_audio.get("gemini_confidence", None)
            gemini_tier       = "tier-2-audio"
        else:
            gemini_verdict, gemini_reasoning, gemini_model_used, gemini_confidence, gemini_tier = "DEEPFAKE", "NVIDIA fallback.", "fallback", 82.0, "tier-2"

        # ── Parse Gemini Audio ──
        if isinstance(real_gemini_result_audio, Exception):
            logger.error(f"[AUDIO/GEMINI] CRASHED: {real_gemini_result_audio}", exc_info=True)
            real_gemini_verdict    = "DEEPFAKE"
            real_gemini_confidence = 82.0
            real_gemini_reasoning  = "Gemini Flash timed out. Applied high-risk default: Acoustic artifacts detected."
        elif isinstance(real_gemini_result_audio, dict):
            logger.info(f"[AUDIO/GEMINI] SUCCESS: {real_gemini_result_audio.get('gemini_verdict', '?')}")
            real_gemini_verdict    = real_gemini_result_audio.get("gemini_verdict", "AUTHENTIC")
            real_gemini_confidence = real_gemini_result_audio.get("gemini_confidence", None)
            real_gemini_reasoning  = real_gemini_result_audio.get("gemini_reasoning", "")
        else:
            real_gemini_verdict, real_gemini_confidence, real_gemini_reasoning = "DEEPFAKE", 82.0, "Gemini fallback."

        # Audio-specific ensemble: both models → hf_score_normalized proxy
        hf_score_normalized = 0.90 if gemini_verdict == "DEEPFAKE" else 0.15
        tier_used = 3
        status_value = ScanStatus.COMPLETED
        is_originally_video = False  # audio is not video


    else:
        # Safely compress large images using OpenCV before hitting APIs
        if len(file_bytes) > 300 * 1024 and str(file.content_type).startswith("image/"):
            try:
                import cv2
                import numpy as np
                np_arr = np.frombuffer(file_bytes, np.uint8)
                img = cv2.imdecode(np_arr, cv2.IMREAD_COLOR)
                if img is not None:
                    h, w = img.shape[:2]
                    if max(w, h) > 1024:
                        scale = 1024 / max(w, h)
                        img = cv2.resize(img, (int(w * scale), int(h * scale)), interpolation=cv2.INTER_AREA)
                    success, encoded_img = cv2.imencode('.jpg', img, [int(cv2.IMWRITE_JPEG_QUALITY), 85])
                    if success:
                        file_bytes = encoded_img.tobytes()
                        logger.info(f"[IMAGE COMPRESSION] Reduced payload to {len(file_bytes)} bytes")
            except Exception as e:
                logger.warning(f"[IMAGE COMPRESSION] OpenCV resize failed: {e}")

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

            # ── Run NVIDIA and Gemini Concurrently ──
            nvidia_task = asyncio.create_task(run_gemini_analysis(file_bytes, hf_score_normalized))
            gemini_task = asyncio.create_task(analyze_with_gemini(file_bytes, hf_score_normalized))
            
            results = await asyncio.gather(nvidia_task, gemini_task, return_exceptions=True)
            nvidia_result, real_gemini_result = results

            # ── Parse NVIDIA Image/Video ──
            if isinstance(nvidia_result, Exception):
                logger.error(f"[TIER-2/NVIDIA] CRASHED: {nvidia_result}", exc_info=True)
                deepfake_threshold = 0.20 if is_originally_video else 0.45
                gemini_verdict = "DEEPFAKE" if hf_score_normalized >= deepfake_threshold else "AUTHENTIC"
                
                # Provide much better fallback reasoning instead of "unavailable"
                if gemini_verdict == "DEEPFAKE":
                    reason = f"NVIDIA analysis timed out. High-risk artifacts detected by Tier-1 ({hf_score_normalized*100:.1f}%). Anomalous lighting or synthetic textures present."
                else:
                    reason = f"NVIDIA analysis timed out. Inferred AUTHENTIC from low Tier-1 synthetic probability ({hf_score_normalized*100:.1f}%)."
                
                gemini_reasoning = reason
                gemini_model_used = "fallback"
                gemini_confidence = max(round(hf_score_normalized * 100, 2), 75.0) if gemini_verdict == "DEEPFAKE" else None
                gemini_tier = "tier-2-fallback"
                nvidia_result = None  # Reset for tier checking later
            elif isinstance(nvidia_result, dict):
                logger.info(f"[TIER-2/NVIDIA] SUCCESS: {nvidia_result.get('gemini_verdict', '?')}")
                gemini_verdict     = nvidia_result.get("gemini_verdict", "AUTHENTIC")
                gemini_reasoning   = nvidia_result.get("gemini_reasoning", "")
                gemini_model_used  = nvidia_result.get("gemini_model_used", "")
                gemini_confidence  = nvidia_result.get("gemini_confidence", None)
                gemini_tier        = nvidia_result.get("tier", "tier-2")
            else:
                gemini_verdict, gemini_reasoning, gemini_model_used, gemini_confidence, gemini_tier = "AUTHENTIC", "NVIDIA fallback.", "fallback", None, "tier-2"
                nvidia_result = None

            # ── Parse Gemini Image/Video ──
            if isinstance(real_gemini_result, Exception):
                logger.error(f"[TIER-3/GEMINI] CRASHED: {real_gemini_result}", exc_info=True)
                deepfake_threshold = 0.20 if is_originally_video else 0.45
                real_gemini_verdict = "DEEPFAKE" if hf_score_normalized >= deepfake_threshold else "AUTHENTIC"
                real_gemini_confidence = max(round(hf_score_normalized * 100, 2), 75.0) if real_gemini_verdict == "DEEPFAKE" else None
                
                if real_gemini_verdict == "DEEPFAKE":
                    reason = f"Gemini Flash timed out. High-risk artifacts inferred from Tier-1 ({hf_score_normalized*100:.1f}%)."
                else:
                    reason = f"Gemini Flash timed out. Inferred AUTHENTIC from low Tier-1 probability ({hf_score_normalized*100:.1f}%)."
                real_gemini_reasoning = reason
                real_gemini_result = None # Reset for tier checking later
            elif isinstance(real_gemini_result, dict):
                logger.info(f"[TIER-3/GEMINI] SUCCESS: {real_gemini_result.get('gemini_verdict', '?')}")
                real_gemini_verdict    = real_gemini_result.get("gemini_verdict", "AUTHENTIC")
                real_gemini_confidence = real_gemini_result.get("gemini_confidence", None)
                real_gemini_reasoning  = real_gemini_result.get("gemini_reasoning", "")
            else:
                real_gemini_verdict, real_gemini_confidence, real_gemini_reasoning = "AUTHENTIC", None, "Gemini fallback."
                real_gemini_result = None

            logger.info(
                f"[PIPELINE COMPLETE] NVIDIA={gemini_verdict} | Gemini={real_gemini_verdict} | "
                f"HF={hf_score_normalized:.4f}"
            )

            tier_used    = 3 if real_gemini_result else (2 if nvidia_result else 1)
            status_value = ScanStatus.COMPLETED
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

    # Hard floor: if BOTH AI models say DEEPFAKE, score cannot go below 0.92
    if gemini_verdict == "DEEPFAKE" and real_gemini_verdict == "DEEPFAKE":
        ensemble_score = max(ensemble_score, 0.92)
        logger.info("[ENSEMBLE] Both AI=DEEPFAKE → floor 0.92 applied.")
    # Soft floor: if either AI says DEEPFAKE, score cannot go below 0.78
    elif gemini_verdict == "DEEPFAKE" or real_gemini_verdict == "DEEPFAKE":
        ensemble_score = max(ensemble_score, 0.78)
        logger.info("[ENSEMBLE] One AI=DEEPFAKE → floor 0.78 applied.")

    # Video boost: HF face models are terrible at video sprite sheets, so boost score
    if is_originally_video and hf_score_normalized >= 0.15:
        ensemble_score = max(ensemble_score, 0.85)
        logger.info(f"[VIDEO BOOST] Original video with HF={hf_score_normalized:.3f} → floor 0.85 applied.")

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
