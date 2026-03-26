"""
Services package initialization.
"""

from app.services.hf_client import (
    DeepfakeAnalysisResult,
    HFAPIConnectionError,
    HFAPIResponseError,
    HFModelError,
    HFTimeoutError,
    HuggingFaceClient,
    analyze_deepfake,
    get_hf_client,
)
from app.services.supabase_db import (
    DatabaseError,
    DuplicateScanError,
    ScanNotFoundError,
    check_hash_exists,
    clear_cache,
    get_cached_threat_score,
    get_scan_by_id,
    get_supabase_client,
    get_user_scans,
    get_user_stats,
    log_scan,
    update_scan_status,
)

__all__ = [
    "DeepfakeAnalysisResult",
    "HFAPIConnectionError",
    "HFAPIResponseError",
    "HFModelError",
    "HFTimeoutError",
    "HuggingFaceClient",
    "analyze_deepfake",
    "get_hf_client",
    "DatabaseError",
    "DuplicateScanError",
    "ScanNotFoundError",
    "check_hash_exists",
    "clear_cache",
    "get_cached_threat_score",
    "get_scan_by_id",
    "get_supabase_client",
    "get_user_scans",
    "get_user_stats",
    "log_scan",
    "update_scan_status",
]
