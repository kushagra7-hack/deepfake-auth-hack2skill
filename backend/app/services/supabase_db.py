"""
Supabase database operations for Deepfake Authentication Gateway.
Provides cryptographic deduplication and scan logging functionality.
"""

import logging
from datetime import datetime
from decimal import Decimal
from typing import Any, Optional
from uuid import UUID

from postgrest import AsyncPostgrestClient
from postgrest.exceptions import APIError
from supabase import AsyncClient, create_async_client

from app.core.config import settings
from app.models.schemas import ScanResponse, ScanStatus

logger = logging.getLogger(__name__)


class DatabaseError(Exception):
    def __init__(self, message: str, original_error: Optional[Exception] = None):
        self.message = message
        self.original_error = original_error
        super().__init__(self.message)


class ScanNotFoundError(DatabaseError):
    pass


class DuplicateScanError(DatabaseError):
    pass


_scanned_hash_cache: dict[str, tuple[Decimal, datetime, str]] = {}


async def get_supabase_client() -> AsyncClient:
    """
    Create and return an async Supabase client.
    
    Returns:
        AsyncClient: Supabase async client instance
    """
    return await create_async_client(
        settings.SUPABASE_URL,
        settings.SUPABASE_SERVICE_ROLE_KEY
    )


async def check_hash_exists(file_hash: str, user_id: str) -> Optional[dict[str, Any]]:
    """
    Check if a SHA-256 hash already exists in the scans table.
    
    Implements cryptographic deduplication - if a file has already been
    scanned, return the cached result instead of re-analyzing.
    
    Args:
        file_hash: SHA-256 hash (64 hex characters)
        user_id: User ID to scope the search
        
    Returns:
        Optional[dict]: Cached scan data if exists, None otherwise
        
    Raises:
        DatabaseError: If database query fails
    """
    if file_hash in _scanned_hash_cache:
        cached_score, cached_time, cached_status = _scanned_hash_cache[file_hash]
        logger.info(f"Cache hit for hash {file_hash[:16]}...")
        return {
            "threat_score": cached_score,
            "created_at": cached_time,
            "status": cached_status
        }
    
    try:
        client = await get_supabase_client()
        
        response = await client.table("scans").select(
            "id, threat_score, status, created_at, result_details"
        ).eq("file_hash", file_hash).eq("user_id", user_id).order(
            "created_at", desc=True
        ).limit(1).execute()
        
        if response.data and len(response.data) > 0:
            scan_data = response.data[0]
            threat_score = scan_data.get("threat_score")
            if threat_score is not None:
                _scanned_hash_cache[file_hash] = (
                    Decimal(str(threat_score)),
                    datetime.fromisoformat(scan_data["created_at"].replace("Z", "+00:00")),
                    scan_data["status"]
                )
            logger.info(f"Database hit for hash {file_hash[:16]}... for user {user_id}")
            return scan_data
            
        logger.debug(f"No existing scan found for hash {file_hash[:16]}...")
        return None
        
    except APIError as e:
        logger.error(f"Database error checking hash: {e}")
        raise DatabaseError(f"Failed to check file hash: {e.message}", e)
    except Exception as e:
        logger.error(f"Unexpected error checking hash: {e}")
        raise DatabaseError(f"Unexpected error: {str(e)}", e)


async def get_cached_threat_score(file_hash: str, user_id: str) -> Optional[Decimal]:
    """
    Get cached threat score for a file hash if it exists.
    
    Convenience wrapper around check_hash_exists that returns
    only the threat score.
    
    Args:
        file_hash: SHA-256 hash to look up
        user_id: User ID to scope the search
        
    Returns:
        Optional[Decimal]: Cached threat score (0-100) if exists, None otherwise
    """
    cached = await check_hash_exists(file_hash, user_id)
    if cached and cached.get("threat_score") is not None:
        return Decimal(str(cached["threat_score"]))
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
    
    Creates an audit trail entry for every media scan performed.
    
    Args:
        user_id: ID of the user who submitted the scan
        file_name: Original filename
        file_hash: SHA-256 hash of the file
        threat_score: Deepfake probability score (0-100)
        status: Current scan status
        media_type: Type of media (image/video/audio)
        file_size: File size in bytes
        result_details: Additional analysis results
        
    Returns:
        dict: Created scan record
        
    Raises:
        DatabaseError: If insertion fails
    """
    scan_data = {
        "user_id": user_id,
        "file_name": file_name,
        "file_hash": file_hash,
        "threat_score": float(threat_score),
        "status": status.value,
    }
    
    if media_type:
        scan_data["media_type"] = media_type
    if file_size:
        scan_data["file_size"] = file_size
    if result_details:
        scan_data["result_details"] = result_details
    
    if status == ScanStatus.COMPLETED:
        scan_data["completed_at"] = datetime.utcnow().isoformat()
    
    try:
        client = await get_supabase_client()
        
        response = await client.table("scans").insert(scan_data).execute()
        
        if response.data and len(response.data) > 0:
            created_scan = response.data[0]
            logger.info(
                f"Logged scan {created_scan.get('id')} for user {user_id}, "
                f"hash={file_hash[:16]}..., score={threat_score}"
            )
            
            _scanned_hash_cache[file_hash] = (
                threat_score,
                datetime.fromisoformat(created_scan["created_at"].replace("Z", "+00:00")),
                status.value
            )
            
            return created_scan
            
        raise DatabaseError("No data returned from insert")
        
    except APIError as e:
        if "duplicate" in str(e).lower() or "unique" in str(e).lower():
            logger.warning(f"Duplicate scan attempt for hash {file_hash[:16]}...")
            existing = await check_hash_exists(file_hash, user_id)
            if existing:
                return existing
            raise DuplicateScanError(f"Duplicate scan detected: {e.message}", e)
        logger.error(f"Database error logging scan: {e}")
        raise DatabaseError(f"Failed to log scan: {e.message}", e)
    except Exception as e:
        logger.error(f"Unexpected error logging scan: {e}")
        raise DatabaseError(f"Unexpected error: {str(e)}", e)


async def update_scan_status(
    scan_id: str,
    status: ScanStatus,
    threat_score: Optional[Decimal] = None,
    result_details: Optional[dict[str, Any]] = None
) -> dict[str, Any]:
    """
    Update an existing scan's status and results.
    
    Args:
        scan_id: UUID of the scan to update
        status: New status value
        threat_score: Updated threat score (optional)
        result_details: Updated result details (optional)
        
    Returns:
        dict: Updated scan record
        
    Raises:
        DatabaseError: If update fails
    """
    update_data: dict[str, Any] = {
        "status": status.value
    }
    
    if threat_score is not None:
        update_data["threat_score"] = float(threat_score)
    if result_details is not None:
        update_data["result_details"] = result_details
    
    if status == ScanStatus.COMPLETED:
        update_data["completed_at"] = datetime.utcnow().isoformat()
    
    try:
        client = await get_supabase_client()
        
        response = await client.table("scans").update(
            update_data
        ).eq("id", scan_id).execute()
        
        if response.data and len(response.data) > 0:
            logger.info(f"Updated scan {scan_id} to status {status.value}")
            return response.data[0]
            
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
        status_filter: Optional status to filter by
        
    Returns:
        tuple: (list of scans, total count)
        
    Raises:
        DatabaseError: If query fails
    """
    try:
        client = await get_supabase_client()
        
        offset = (page - 1) * page_size
        
        query = client.table("scans").select(
            "*", count="exact"
        ).eq("user_id", user_id).order("created_at", desc=True)
        
        if status_filter:
            query = query.eq("status", status_filter.value)
        
        response = await query.range(offset, offset + page_size - 1).execute()
        
        scans = response.data or []
        total = response.count if response.count is not None else len(scans)
        
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
        
        response = await client.table("scans").select("*").eq(
            "id", scan_id
        ).eq("user_id", user_id).limit(1).execute()
        
        if response.data and len(response.data) > 0:
            return response.data[0]
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
    
    Args:
        user_id: User ID to get stats for
        
    Returns:
        dict: Statistics including total scans, pending, completed, avg score
        
    Raises:
        DatabaseError: If query fails
    """
    try:
        client = await get_supabase_client()
        
        response = await client.rpc(
            "get_user_scan_stats",
            {"p_user_id": user_id}
        ).execute()
        
        if response.data and len(response.data) > 0:
            return response.data[0]
        
        return {
            "total_scans": 0,
            "pending_scans": 0,
            "completed_scans": 0,
            "avg_threat_score": 0
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
