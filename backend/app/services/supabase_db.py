"""
Supabase database operations for Deepfake Authentication Gateway.
Provides scan logging functionality aligned with the actual database schema.

Database table: scan_results
Columns: id, user_id, hf_score, gemini_verdict, gemini_reasoning, created_at
"""

import logging
from datetime import datetime, timezone
from decimal import Decimal
from typing import Any, Optional
from uuid import UUID

import cachetools

from postgrest._async.client import AsyncPostgrestClient
from postgrest.exceptions import APIError
from postgrest import CountMethod
from supabase import AsyncClient, create_async_client

from app.core.config import settings
from app.models.schemas import ScanStatus

logger = logging.getLogger(__name__)

# Database table name (actual Supabase table)
TABLE_NAME = "scan_results"


class DatabaseError(Exception):
    def __init__(self, message: str, original_error: Optional[Exception] = None):
        self.message = message
        self.original_error = original_error
        super().__init__(self.message)


class ScanNotFoundError(DatabaseError):
    pass


class DuplicateScanError(DatabaseError):
    pass


_scanned_hash_cache = cachetools.TTLCache(maxsize=10000, ttl=3600)
_supabase_client: Optional[AsyncClient] = None

async def get_supabase_client() -> AsyncClient:
    """
    Create and return an async Supabase client.
    
    Returns:
        AsyncClient: Supabase async client instance
    """
    global _supabase_client
    if _supabase_client is None:
        _supabase_client = await create_async_client(
            settings.SUPABASE_URL,
            settings.SUPABASE_SERVICE_ROLE_KEY
        )
    return _supabase_client


async def check_hash_exists(file_hash: str, user_id: str) -> Optional[dict[str, Any]]:
    """
    Check if a scan result already exists for this user with matching hash.
    
    Uses in-memory cache for fast deduplication before hitting the DB.
    
    Args:
        file_hash: SHA-256 hash (64 hex characters)
        user_id: User ID to scope the search
        
    Returns:
        Optional[dict]: Cached scan data if exists, None otherwise
        
    Raises:
        DatabaseError: If database query fails
    """
    if file_hash in _scanned_hash_cache:
        cached_score, cached_time = _scanned_hash_cache[file_hash]
        logger.info(f"Cache hit for hash {file_hash[:16]}...")
        return {
            "hf_score": cached_score,
            "created_at": cached_time,
        }
    
    # No DB-level hash dedup since scan_results table doesn't have file_hash column.
    # We rely purely on the in-memory cache for dedup within the same session.
    logger.debug(f"No cache entry found for hash {file_hash[:16]}...")
    return None


async def get_cached_threat_score(file_hash: str, user_id: str) -> Optional[Decimal]:
    """
    Get cached threat score for a file hash if it exists.
    
    Args:
        file_hash: SHA-256 hash to look up
        user_id: User ID to scope the search
        
    Returns:
        Optional[Decimal]: Cached threat score (0-100) if exists, None otherwise
    """
    cached = await check_hash_exists(file_hash, user_id)
    if cached and cached.get("hf_score") is not None:
        return Decimal(str(cached["hf_score"]))
    return None


async def log_scan(
    user_id: str,
    file_name: str,
    file_hash: str,
    threat_score: Decimal,
    status: ScanStatus,
    media_type: Optional[str] = None,
    file_size: Optional[int] = None,
    result_details: Optional[dict[str, Any]] = None
) -> dict[str, Any]:
    """
    Log a new scan entry to the database.

    Maps application data to the actual database schema:
      - user_id -> user_id
      - threat_score -> hf_score
      - result_details.gemini_verdict -> gemini_verdict
      - result_details.gemini_reasoning -> gemini_reasoning

    Args:
        user_id: ID of the user who submitted the scan
        file_name: Original filename (stored in result_details for reference)
        file_hash: SHA-256 hash of the file
        threat_score: Deepfake probability score (0-100)
        status: Current scan status
        media_type: Type of media (image/video/audio)
        file_size: File size in bytes
        result_details: Additional analysis results

    Returns:
        dict: Created scan record (with mapped column names)

    Raises:
        DatabaseError: If insertion fails
    """
    logger.info("=" * 80)
    logger.info("SUPABASE_DB.PY - log_scan() CALLED")
    logger.info("=" * 80)
    
    logger.info(f"SUPABASE_URL: {settings.SUPABASE_URL}")
    logger.info(f"SUPABASE_SERVICE_ROLE_KEY: {settings.SUPABASE_SERVICE_ROLE_KEY[:20]}..." if settings.SUPABASE_SERVICE_ROLE_KEY else "SUPABASE_SERVICE_ROLE_KEY: None")
    
    # Extract Gemini analysis data from result_details if available
    gemini_verdict = None
    gemini_reasoning = None
    if result_details:
        # Check for direct gemini fields
        gemini_verdict = result_details.get("gemini_verdict")
        gemini_reasoning = result_details.get("gemini_reasoning")
        
        # Build verdict from analysis results if not explicitly provided
        if gemini_verdict is None:
            is_deepfake = result_details.get("is_deepfake")
            confidence = result_details.get("confidence_level", "unknown")
            if is_deepfake is not None:
                gemini_verdict = f"{'DEEPFAKE' if is_deepfake else 'AUTHENTIC'} ({confidence} confidence)"
        
        # Build reasoning from available details
        if gemini_reasoning is None:
            parts = []
            if result_details.get("model_used"):
                parts.append(f"Model: {result_details['model_used']}")
            if result_details.get("processing_time_ms"):
                parts.append(f"Processing time: {result_details['processing_time_ms']:.0f}ms")
            if result_details.get("raw_probability") is not None:
                parts.append(f"Raw probability: {result_details['raw_probability']:.2f}%")
            if result_details.get("error"):
                parts.append(f"Error: {result_details['error']}")
            if result_details.get("message"):
                parts.append(f"Details: {result_details['message']}")
            # Include file metadata in reasoning
            parts.append(f"File: {file_name}")
            if media_type:
                parts.append(f"Type: {media_type}")
            if file_size:
                parts.append(f"Size: {file_size} bytes")
            parts.append(f"Hash: {file_hash[:16]}...")
            parts.append(f"Status: {status.value}")
            gemini_reasoning = " | ".join(parts) if parts else None
    
    # Prepare payload matching the actual database schema
    scan_data = {
        "user_id": user_id,
        "hf_score": float(threat_score),
        "gemini_verdict": gemini_verdict or f"Score: {float(threat_score):.1f}%",
        "gemini_reasoning": gemini_reasoning or f"Analysis of {file_name} ({media_type or 'unknown'} type, {status.value})",
    }
    
    logger.info(f"PAYLOAD TO INSERT: {scan_data}")

    try:
        logger.info("Attempting to get Supabase client...")
        client = await get_supabase_client()
        logger.info(f"Supabase client obtained: {type(client)}")
        
        logger.info(f"Executing insert on '{TABLE_NAME}' table...")
        response = await client.table(TABLE_NAME).insert(scan_data).execute()
        
        logger.info(f"Response received: {response}")
        logger.info(f"Response data: {response.data}")

        if response.data and len(response.data) > 0:
            created_scan = response.data[0]
            logger.info(
                f"SUCCESS: Logged scan {created_scan.get('id')} for user {user_id}, "
                f"hf_score={threat_score}"
            )

            _scanned_hash_cache[file_hash] = (
                threat_score,
                datetime.now(timezone.utc),
            )
            
            # Map back to application-level field names for compatibility
            result = _map_db_to_app(created_scan, file_name, file_hash, media_type, file_size, status)
            
            logger.info("=" * 80)
            return result

        logger.error("SUPABASE CLIENT ERROR: No data returned from insert")
        raise DatabaseError("No data returned from insert")

    except APIError as e:
        logger.error("=" * 80)
        logger.error(f"SUPABASE CLIENT ERROR (APIError): {e}")
        logger.error(f"Error message: {e.message}")
        logger.error(f"Error details: {e.details if hasattr(e, 'details') else 'N/A'}")
        logger.error("=" * 80)
        
        if "duplicate" in str(e).lower() or "unique" in str(e).lower():
            logger.warning(f"Duplicate scan attempt for hash {file_hash[:16]}...")
            existing = await check_hash_exists(file_hash, user_id)
            if existing:
                return existing
            raise DuplicateScanError(f"Duplicate scan detected: {e.message}", e)
        raise DatabaseError(f"Failed to log scan: {e.message}", e)
    except Exception as e:
        logger.error("=" * 80)
        logger.error(f"SUPABASE CLIENT ERROR (Exception): {type(e).__name__}: {e}")
        logger.error(f"Exception args: {e.args}")
        import traceback
        logger.error(f"Traceback: {traceback.format_exc()}")
        logger.error("=" * 80)
        raise DatabaseError(f"Unexpected error: {str(e)}", e)


def _map_db_to_app(
    db_record: dict[str, Any],
    file_name: str = "unknown",
    file_hash: str = "",
    media_type: Optional[str] = None,
    file_size: Optional[int] = None,
    status: Optional[ScanStatus] = None,
) -> dict[str, Any]:
    """
    Map database record columns to application-level field names.
    
    The database schema (scan_results) has: id, user_id, hf_score, gemini_verdict, gemini_reasoning, created_at
    The application expects: id, user_id, file_name, file_hash, threat_score, status, media_type, file_size, result_details, created_at, completed_at
    """
    return {
        "id": db_record.get("id"),
        "user_id": db_record.get("user_id"),
        "file_name": file_name,
        "file_hash": file_hash,
        "threat_score": db_record.get("hf_score"),
        "status": status.value if status else "completed",
        "media_type": media_type,
        "file_size": file_size,
        "result_details": {
            "gemini_verdict": db_record.get("gemini_verdict"),
            "gemini_reasoning": db_record.get("gemini_reasoning"),
        },
        "created_at": db_record.get("created_at"),
        "completed_at": db_record.get("created_at"),  # Use created_at as completed_at
    }


async def update_scan_status(
    scan_id: str,
    status: ScanStatus,
    threat_score: Optional[Decimal] = None,
    result_details: Optional[dict[str, Any]] = None,
    file_name: str = "unknown",
    file_hash: str = "",
    media_type: Optional[str] = None,
    file_size: Optional[int] = None,
) -> dict[str, Any]:
    """
    Update an existing scan's status and results.
    
    Args:
        scan_id: UUID of the scan to update
        status: New status value
        threat_score: Updated threat score (optional)
        result_details: Updated result details (optional)
        file_name: Original filename for mapping
        file_hash: File hash for mapping
        media_type: Media type for mapping
        file_size: File size for mapping
        
    Returns:
        dict: Updated scan record
        
    Raises:
        DatabaseError: If update fails
    """
    update_data: dict[str, Any] = {}
    
    if threat_score is not None:
        update_data["hf_score"] = float(threat_score)
    
    if result_details is not None:
        # Extract gemini fields from result_details
        gemini_verdict = result_details.get("gemini_verdict")
        if gemini_verdict is None:
            is_deepfake = result_details.get("is_deepfake")
            confidence = result_details.get("confidence_level", "unknown")
            if is_deepfake is not None:
                gemini_verdict = f"{'DEEPFAKE' if is_deepfake else 'AUTHENTIC'} ({confidence} confidence)"
            elif result_details.get("error"):
                gemini_verdict = f"FAILED: {result_details['error']}"
        
        if gemini_verdict:
            update_data["gemini_verdict"] = gemini_verdict
        
        gemini_reasoning = result_details.get("gemini_reasoning")
        if gemini_reasoning is None:
            parts = []
            for key in ["model_used", "processing_time_ms", "raw_probability", "error", "message", "error_type"]:
                if result_details.get(key) is not None:
                    parts.append(f"{key}: {result_details[key]}")
            if parts:
                gemini_reasoning = " | ".join(parts)
        
        if gemini_reasoning:
            update_data["gemini_reasoning"] = gemini_reasoning
    
    if not update_data:
        logger.warning(f"No updatable fields for scan {scan_id}")
        # Return a basic result since there's nothing to update
        return {
            "id": scan_id,
            "status": status.value,
        }
    
    try:
        client = await get_supabase_client()
        
        response = await client.table(TABLE_NAME).update(
            update_data
        ).eq("id", scan_id).execute()
        
        if response.data and len(response.data) > 0:
            logger.info(f"Updated scan {scan_id} with hf_score={threat_score}")
            return _map_db_to_app(response.data[0], file_name, file_hash, media_type, file_size, status)
            
        raise ScanNotFoundError(f"Scan {scan_id} not found")
        
    except APIError as e:
        logger.error(f"Database error updating scan: {e}")
        raise DatabaseError(f"Failed to update scan: {e.message}", e)
    except Exception as e:
        logger.error(f"Unexpected error updating scan: {e}")
        raise DatabaseError(f"Unexpected error: {str(e)}", e)


async def get_user_scans(
    user_id: str,
    page: int = 1,
    page_size: int = 20,
    status_filter: Optional[ScanStatus] = None
) -> tuple[list[dict[str, Any]], int]:
    """
    Get paginated list of scans for a user.
    
    Args:
        user_id: User ID to get scans for
        page: Page number (1-indexed)
        page_size: Number of items per page
        status_filter: Optional status to filter by (not stored in DB, ignored)
        
    Returns:
        tuple: (list of scans, total count)
        
    Raises:
        DatabaseError: If query fails
    """
    try:
        client = await get_supabase_client()
        
        offset = (page - 1) * page_size
        
        query = client.table(TABLE_NAME).select(
            "*", count=CountMethod.exact
        ).eq("user_id", user_id).order("created_at", desc=True)
        
        response = await query.range(offset, offset + page_size - 1).execute()
        
        raw_scans = response.data or []
        total = response.count if response.count is not None else len(raw_scans)
        
        # Map each DB record to application format
        scans = [_map_db_to_app(scan) for scan in raw_scans]
        
        logger.debug(f"Retrieved {len(scans)} scans for user {user_id} (page {page})")
        return scans, total
        
    except APIError as e:
        logger.error(f"Database error getting user scans: {e}")
        raise DatabaseError(f"Failed to get scans: {e.message}", e)
    except Exception as e:
        logger.error(f"Unexpected error getting scans: {e}")
        raise DatabaseError(f"Unexpected error: {str(e)}", e)


async def get_scan_by_id(scan_id: str, user_id: str) -> Optional[dict[str, Any]]:
    """
    Get a specific scan by ID (scoped to user).
    
    Args:
        scan_id: UUID of the scan
        user_id: User ID for access control
        
    Returns:
        Optional[dict]: Scan data if found and owned by user
        
    Raises:
        DatabaseError: If query fails
    """
    try:
        client = await get_supabase_client()
        
        response = await client.table(TABLE_NAME).select("*").eq(
            "id", scan_id
        ).eq("user_id", user_id).limit(1).execute()
        
        if response.data and len(response.data) > 0:
            return _map_db_to_app(response.data[0])
        return None
        
    except APIError as e:
        logger.error(f"Database error getting scan: {e}")
        raise DatabaseError(f"Failed to get scan: {e.message}", e)
    except Exception as e:
        logger.error(f"Unexpected error getting scan: {e}")
        raise DatabaseError(f"Unexpected error: {str(e)}", e)


async def get_user_stats(user_id: str) -> dict[str, Any]:
    """
    Get scan statistics for a user.
    
    Since the database schema only has hf_score and not status,
    we compute stats from available data.
    
    Args:
        user_id: User ID to get stats for
        
    Returns:
        dict: Statistics including total scans, pending, completed, avg score
        
    Raises:
        DatabaseError: If query fails
    """
    try:
        client = await get_supabase_client()
        
        # First try the RPC function
        try:
            response = await client.rpc(
                "get_user_scan_stats",
                {"p_user_id": user_id}
            ).execute()
            
            if response.data and len(response.data) > 0:
                return response.data[0]
        except Exception as rpc_error:
            logger.warning(f"RPC get_user_scan_stats failed, computing manually: {rpc_error}")
        
        # Fallback: compute stats manually from scan_results
        response = await client.table(TABLE_NAME).select(
            "id, hf_score", count=CountMethod.exact
        ).eq("user_id", user_id).execute()
        
        scans = response.data or []
        total = response.count if response.count is not None else len(scans)
        
        scores = [float(s["hf_score"]) for s in scans if s.get("hf_score") is not None]
        avg_score = sum(scores) / len(scores) if scores else 0.0
        
        return {
            "total_scans": total,
            "pending_scans": 0,  # No status column in DB
            "completed_scans": total,  # All stored scans are considered completed
            "avg_threat_score": round(avg_score, 2)
        }
        
    except APIError as e:
        logger.error(f"Database error getting user stats: {e}")
        raise DatabaseError(f"Failed to get stats: {e.message}", e)
    except Exception as e:
        logger.error(f"Unexpected error getting stats: {e}")
        raise DatabaseError(f"Unexpected error: {str(e)}", e)


def clear_cache() -> None:
    """Clear the in-memory hash cache."""
    global _scanned_hash_cache
    _scanned_hash_cache.clear()
    logger.info("Hash cache cleared")
