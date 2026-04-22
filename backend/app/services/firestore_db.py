"""
Firestore database operations for Deepfake Authentication Gateway.
Drop-in replacement for supabase_db.py — same function signatures,
Firestore backend instead of PostgreSQL.

Collection: scans
Document fields: user_id, file_name, file_hash, hf_score,
                 gemini_verdict, gemini_reasoning, gemini_model_used,
                 gemini_confidence, gemini_tier, media_type, file_size,
                 status, created_at
"""

import logging
import uuid
from datetime import datetime, timezone
from decimal import Decimal
from typing import Any, Optional

import cachetools
from google.cloud.firestore_v1.base_query import FieldFilter

from app.models.schemas import ScanStatus
from app.services.firebase_config import get_firestore

logger = logging.getLogger(__name__)

COLLECTION = "scans"

_scanned_hash_cache = cachetools.TTLCache(maxsize=10000, ttl=3600)


# ── Custom Exceptions (same interface as supabase_db.py) ─────────────────────

class DatabaseError(Exception):
    def __init__(self, message: str, original_error: Optional[Exception] = None):
        self.message = message
        self.original_error = original_error
        super().__init__(self.message)


class ScanNotFoundError(DatabaseError):
    pass


class DuplicateScanError(DatabaseError):
    pass


# ── Helpers ───────────────────────────────────────────────────────────────────

def _server_timestamp():
    return datetime.now(timezone.utc).isoformat()


def _doc_to_app(doc_id: str, data: dict[str, Any]) -> dict[str, Any]:
    """Map a Firestore document to the application response shape."""
    return {
        "id": doc_id,
        "user_id": data.get("user_id"),
        "file_name": data.get("file_name", "unknown"),
        "file_hash": data.get("file_hash", ""),
        "threat_score": data.get("hf_score"),
        "status": data.get("status", ScanStatus.COMPLETED.value),
        "media_type": data.get("media_type"),
        "file_size": data.get("file_size"),
        "result_details": {
            "gemini_verdict":    data.get("gemini_verdict"),
            "gemini_reasoning":  data.get("gemini_reasoning"),
            "gemini_model_used": data.get("gemini_model_used"),
            "gemini_confidence": data.get("gemini_confidence"),
            "gemini_tier":       data.get("gemini_tier"),
            "hf_score":          data.get("hf_score"),
            "hf_score_pct":      data.get("hf_score_pct"),
            "model_used":        data.get("model_used"),
            "processing_time_ms": data.get("processing_time_ms"),
            "confidence_level":  data.get("confidence_level"),
            "is_deepfake":       data.get("is_deepfake"),
            "tier_used":         data.get("tier_used"),
        },
        "created_at":   data.get("created_at"),
        "completed_at": data.get("completed_at") or data.get("created_at"),
    }


# ── Public API (same signatures as supabase_db.py) ───────────────────────────

async def check_hash_exists(file_hash: str, user_id: str) -> Optional[dict[str, Any]]:
    """Return cached scan data if hash was seen recently, else None."""
    if file_hash in _scanned_hash_cache:
        cached_score, cached_time = _scanned_hash_cache[file_hash]
        logger.info(f"[Firestore] Cache hit for hash {file_hash[:16]}...")
        return {"hf_score": cached_score, "created_at": cached_time}
    return None


async def log_scan(
    user_id: str,
    file_name: str,
    file_hash: str,
    threat_score: Decimal,
    status: ScanStatus,
    media_type: Optional[str] = None,
    file_size: Optional[int] = None,
    result_details: Optional[dict[str, Any]] = None,
) -> dict[str, Any]:
    """Create a new scan document in Firestore."""
    scan_id = str(uuid.uuid4())
    now = _server_timestamp()

    rd = result_details or {}
    doc_data: dict[str, Any] = {
        "user_id":           user_id,
        "file_name":         file_name,
        "file_hash":         file_hash,
        "hf_score":          float(threat_score),
        "hf_score_pct":      float(threat_score),
        "status":            status.value,
        "media_type":        media_type,
        "file_size":         file_size,
        "created_at":        now,
        "completed_at":      now if status == ScanStatus.COMPLETED else None,
        # Tier-2 fields
        "gemini_verdict":    rd.get("gemini_verdict"),
        "gemini_reasoning":  rd.get("gemini_reasoning"),
        "gemini_model_used": rd.get("gemini_model_used"),
        "gemini_confidence": rd.get("gemini_confidence"),
        "gemini_tier":       rd.get("gemini_tier"),
        # Tier-1 fields
        "model_used":        rd.get("model_used"),
        "processing_time_ms": rd.get("processing_time_ms"),
        "confidence_level":  rd.get("confidence_level"),
        "is_deepfake":       rd.get("is_deepfake"),
        "tier_used":         rd.get("tier_used"),
    }

    try:
        db = get_firestore()
        await db.collection(COLLECTION).document(scan_id).set(doc_data)
        _scanned_hash_cache[file_hash] = (threat_score, now)
        logger.info(f"[Firestore] Logged scan {scan_id} for user {user_id}")
        return _doc_to_app(scan_id, doc_data)
    except Exception as e:
        logger.error(f"[Firestore] log_scan failed: {e}")
        raise DatabaseError(f"Failed to log scan: {e}", e)


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
    """Update an existing scan document."""
    rd = result_details or {}
    update_data: dict[str, Any] = {
        "status": status.value,
        "completed_at": _server_timestamp(),
    }

    if threat_score is not None:
        update_data["hf_score"] = float(threat_score)
        update_data["hf_score_pct"] = float(threat_score)

    # Merge Tier-2 fields
    for key in (
        "gemini_verdict", "gemini_reasoning", "gemini_model_used",
        "gemini_confidence", "gemini_tier", "model_used",
        "processing_time_ms", "confidence_level", "is_deepfake", "tier_used",
    ):
        if rd.get(key) is not None:
            update_data[key] = rd[key]

    try:
        db = get_firestore()
        ref = db.collection(COLLECTION).document(scan_id)
        await ref.update(update_data)

        snap = await ref.get()
        if not snap.exists:
            raise ScanNotFoundError(f"Scan {scan_id} not found after update")

        data = snap.to_dict() or {}
        data.update(update_data)
        data.setdefault("file_name", file_name)
        data.setdefault("file_hash", file_hash)
        data.setdefault("media_type", media_type)
        data.setdefault("file_size", file_size)
        logger.info(f"[Firestore] Updated scan {scan_id}")
        return _doc_to_app(scan_id, data)
    except ScanNotFoundError:
        raise
    except Exception as e:
        logger.error(f"[Firestore] update_scan_status failed: {e}")
        raise DatabaseError(f"Failed to update scan: {e}", e)


async def get_scan_by_id(scan_id: str, user_id: str) -> Optional[dict[str, Any]]:
    """Fetch a single scan document by ID, scoped to user."""
    try:
        db = get_firestore()
        snap = await db.collection(COLLECTION).document(scan_id).get()
        if not snap.exists:
            return None
        data = snap.to_dict() or {}
        if data.get("user_id") != user_id:
            return None  # Enforce ownership
        return _doc_to_app(scan_id, data)
    except Exception as e:
        logger.error(f"[Firestore] get_scan_by_id failed: {e}")
        raise DatabaseError(f"Failed to get scan: {e}", e)


async def get_user_scans(
    user_id: str,
    page: int = 1,
    page_size: int = 20,
    status_filter: Optional[ScanStatus] = None,
    media_type_filter: Optional[str] = None,
) -> tuple[list[dict[str, Any]], int]:
    """Get paginated scans for a user, newest first."""
    try:
        db = get_firestore()
        query = db.collection(COLLECTION) \
                   .where(filter=FieldFilter("user_id", "==", user_id)) \
                   .order_by("created_at", direction="DESCENDING")

        # Fetch all matching docs for total count (Firestore has no COUNT())
        all_snaps = [snap async for snap in query.stream()]
        
        # In-memory filtering to avoid composite index requirements
        filtered_snaps = []
        for snap in all_snaps:
            data = snap.to_dict() or {}
            
            if status_filter and data.get("status") != status_filter.value:
                continue
                
            if media_type_filter and media_type_filter != "all":
                if data.get("media_type") != media_type_filter:
                    continue
                    
            filtered_snaps.append(snap)

        total = len(filtered_snaps)

        # Manual pagination
        offset = (page - 1) * page_size
        page_snaps = filtered_snaps[offset: offset + page_size]

        scans = [
            _doc_to_app(snap.id, snap.to_dict() or {})
            for snap in page_snaps
        ]
        logger.debug(f"[Firestore] {len(scans)}/{total} scans for user {user_id}")
        return scans, total
    except Exception as e:
        logger.error(f"[Firestore] get_user_scans failed: {e}")
        raise DatabaseError(f"Failed to get scans: {e}", e)


async def get_user_stats(user_id: str) -> dict[str, Any]:
    """Compute scan statistics from Firestore for a user."""
    try:
        db = get_firestore()
        query = db.collection(COLLECTION) \
                   .where(filter=FieldFilter("user_id", "==", user_id))

        snaps = [snap async for snap in query.stream()]
        total = len(snaps)

        scores = [
            float(s.to_dict().get("hf_score", 0))
            for s in snaps
            if s.to_dict().get("hf_score") is not None
        ]
        avg_score = round(sum(scores) / len(scores), 2) if scores else 0.0

        completed = sum(
            1 for s in snaps
            if s.to_dict().get("status") == ScanStatus.COMPLETED.value
        )
        pending = total - completed

        return {
            "total_scans":     total,
            "pending_scans":   pending,
            "completed_scans": completed,
            "avg_threat_score": avg_score,
        }
    except Exception as e:
        logger.error(f"[Firestore] get_user_stats failed: {e}")
        raise DatabaseError(f"Failed to get stats: {e}", e)


def clear_cache() -> None:
    """Clear the in-memory hash deduplication cache."""
    _scanned_hash_cache.clear()
    logger.info("[Firestore] Hash cache cleared")
