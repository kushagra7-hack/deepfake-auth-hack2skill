"""
Core package initialization.
"""

from app.core.config import settings
from app.core.security import (
    FileInfo,
    FileSignature,
    FileTooSmallError,
    InvalidFileSignatureError,
    generate_file_hash,
    get_supported_extensions,
    get_supported_mime_types,
    is_media_file,
    verify_and_hash_file,
    verify_file_signature,
)

__all__ = [
    "settings",
    "FileInfo",
    "FileSignature",
    "FileTooSmallError",
    "InvalidFileSignatureError",
    "generate_file_hash",
    "get_supported_extensions",
    "get_supported_mime_types",
    "is_media_file",
    "verify_and_hash_file",
    "verify_file_signature",
]
