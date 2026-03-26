"""
Scan API routes for Deepfake Authentication Gateway.
Provides the main POST /scan endpoint for media analysis.
"""

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
    verify_supabase_jwt,
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
from app.services.supabase_db import (
    DatabaseError,
    check_hash_exists,
    get_scan_by_id,
    get_user_scans,
    get_user_stats,
    log_scan,
    update_scan_status,
)

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
    
    try:
        file_chunks = []
        total_size = 0
        
        async for chunk in file.file:
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
    
    file_hash = generate_file_hash(file_bytes)
    logger.debug(f"Generated hash for {filename}: {file_hash[:16]}...")
    
    try:
        existing_scan = await check_hash_exists(file_hash, user_id)
        
        if existing_scan and existing_scan.get("threat_score") is not None:
            logger.info(
                f"Returning cached result for {filename} "
                f"(hash={file_hash[:16]}..., score={existing_scan.get('threat_score')})"
            )
            
            return ScanResponse(
                id=existing_scan.get("id"),
                user_id=user_id,
                file_name=filename,
                file_hash=file_hash,
                threat_score=Decimal(str(existing_scan.get("threat_score", 0))),
                status=ScanStatus.COMPLETED,
                media_type=file_info.media_type,
                file_size=total_size,
                result_details=existing_scan.get("result_details"),
                created_at=existing_scan.get("created_at"),
                completed_at=existing_scan.get("created_at"),
            )
            
    except DatabaseError as e:
        logger.error(f"Database error during deduplication check: {e}")
    
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
    
    try:
        analysis_result = await analyze_deepfake(file_bytes, file_info)
        
        threat_score = Decimal(str(round(analysis_result.probability_score, 2)))
        status_value = ScanStatus.COMPLETED
        
        result_details = {
            "is_deepfake": analysis_result.is_deepfake,
            "confidence_level": analysis_result.confidence_level,
            "model_used": analysis_result.model_used,
            "processing_time_ms": analysis_result.processing_time_ms,
            "raw_probability": float(analysis_result.probability_score),
        }
        
        logger.info(
            f"Analysis complete for {filename}: score={threat_score}%, "
            f"deepfake={analysis_result.is_deepfake}, "
            f"confidence={analysis_result.confidence_level}"
        )
        
    except HFTimeoutError as e:
        logger.error(f"HuggingFace API timeout for {filename}: {e.message}")
        threat_score = Decimal("0")
        status_value = ScanStatus.FAILED
        result_details = {
            "error": "Analysis timeout",
            "error_type": "timeout",
            "message": e.message
        }
        
    except HFAPIResponseError as e:
        logger.error(f"HuggingFace API error for {filename}: {e.message}")
        threat_score = Decimal("0")
        status_value = ScanStatus.FAILED
        result_details = {
            "error": "Analysis failed",
            "error_type": "api_error",
            "status_code": e.status_code,
            "message": e.message
        }
        
    except HFAPIConnectionError as e:
        logger.error(f"HuggingFace connection error for {filename}: {e.message}")
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Deepfake analysis service temporarily unavailable. Please try again."
        )
        
    except Exception as e:
        logger.error(f"Unexpected error during analysis for {filename}: {e}")
        threat_score = Decimal("0")
        status_value = ScanStatus.FAILED
        result_details = {
            "error": "Unexpected error",
            "error_type": "internal",
            "message": str(e)
        }
    
    try:
        if pending_scan:
            updated_scan = await update_scan_status(
                scan_id=pending_scan.get("id"),
                status=status_value,
                threat_score=threat_score,
                result_details=result_details
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
            id=scan.get("id"),
            user_id=scan.get("user_id"),
            file_name=scan.get("file_name"),
            file_hash=scan.get("file_hash"),
            threat_score=Decimal(str(scan.get("threat_score", 0))),
            status=ScanStatus(scan.get("status")),
            media_type=scan.get("media_type"),
            file_size=scan.get("file_size"),
            result_details=scan.get("result_details"),
            created_at=scan.get("created_at"),
            completed_at=scan.get("completed_at"),
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
) -> dict[str, Any]:
    """Get paginated list of user's scans."""
    try:
        scans, total = await get_user_scans(
            user_id=user_id,
            page=page,
            page_size=page_size,
            status_filter=status_filter
        )
        
        scan_responses = [
            ScanResponse(
                id=scan.get("id"),
                user_id=scan.get("user_id"),
                file_name=scan.get("file_name"),
                file_hash=scan.get("file_hash"),
                threat_score=Decimal(str(scan.get("threat_score", 0))),
                status=ScanStatus(scan.get("status")),
                media_type=scan.get("media_type"),
                file_size=scan.get("file_size"),
                result_details=scan.get("result_details"),
                created_at=scan.get("created_at"),
                completed_at=scan.get("completed_at"),
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
