"""
Core security utilities for Deepfake Authentication Gateway.
Implements malicious payload mitigation through file signature verification
and cryptographic hashing for deduplication.
"""

import hashlib
from dataclasses import dataclass
from enum import Enum
from typing import Optional


class FileSignature(str, Enum):
    MP4 = "mp4"
    MP4_ALT = "mp4_alt"
    AVI = "avi"
    MOV = "mov"
    WAV = "wav"
    MP3 = "mp3"
    FLAC = "flac"
    OGG = "ogg"
    WEBM = "webm"
    MKV = "mkv"
    PNG = "png"
    JPEG = "jpeg"
    GIF = "gif"
    WEBP = "webp"
    BMP = "bmp"


@dataclass
class FileInfo:
    signature: FileSignature
    media_type: str
    mime_type: str
    is_valid: bool
    description: str


FILE_SIGNATURES: dict[tuple[bytes, ...], FileInfo] = {
    (b"\x00\x00\x00\x18\x66\x74\x79\x70", b"\x00\x00\x00\x1c\x66\x74\x79\x70",
     b"\x00\x00\x00\x20\x66\x74\x79\x70", b"\x00\x00\x00\x24\x66\x74\x79\x70",
     b"\x00\x00\x00\x28\x66\x74\x79\x70", b"\x00\x00\x00\x14\x66\x74\x79\x70",
     b"\x00\x00\x00\x08\x66\x74\x79\x70",): FileInfo(
        signature=FileSignature.MP4,
        media_type="video",
        mime_type="video/mp4",
        is_valid=True,
        description="MP4/M4A/MOV container (ISO Base Media ftyp box)"
    ),
    (b"\x1a\x45\xdf\xa3",): FileInfo(
        signature=FileSignature.WEBM,
        media_type="video",
        mime_type="video/webm",
        is_valid=True,
        description="WebM/MKV container"
    ),
    (b"\x66\x4c\x61\x43",): FileInfo(
        signature=FileSignature.FLAC,
        media_type="audio",
        mime_type="audio/flac",
        is_valid=True,
        description="FLAC audio file"
    ),
    (b"\x4f\x67\x67\x53",): FileInfo(
        signature=FileSignature.OGG,
        media_type="audio",
        mime_type="audio/ogg",
        is_valid=True,
        description="OGG container"
    ),
    (b"\x49\x44\x33", b"\xff\xfb", b"\xff\xfa", b"\xff\xf3"): FileInfo(
        signature=FileSignature.MP3,
        media_type="audio",
        mime_type="audio/mpeg",
        is_valid=True,
        description="MP3 audio file"
    ),
    (b"\x89\x50\x4e\x47\x0d\x0a\x1a\x0a",): FileInfo(
        signature=FileSignature.PNG,
        media_type="image",
        mime_type="image/png",
        is_valid=True,
        description="PNG image file"
    ),
    (b"\xff\xd8\xff",): FileInfo(
        signature=FileSignature.JPEG,
        media_type="image",
        mime_type="image/jpeg",
        is_valid=True,
        description="JPEG image file"
    ),
    (b"\x47\x49\x46\x38",): FileInfo(
        signature=FileSignature.GIF,
        media_type="image",
        mime_type="image/gif",
        is_valid=True,
        description="GIF image file"
    ),
    (b"\x42\x4d",): FileInfo(
        signature=FileSignature.BMP,
        media_type="image",
        mime_type="image/bmp",
        is_valid=True,
        description="BMP image file"
    ),
    (b"\x41\x56\x49\x20",): FileInfo(
        signature=FileSignature.AVI,
        media_type="video",
        mime_type="video/x-msvideo",
        is_valid=True,
        description="AVI video file"
    ),
    (b"\x6d\x6f\x6f\x76", b"\x6d\x64\x61\x74", b"\x66\x72\x65\x65"): FileInfo(
        signature=FileSignature.MOV,
        media_type="video",
        mime_type="video/quicktime",
        is_valid=True,
        description="QuickTime MOV file"
    ),
}

MIN_FILE_SIZE = 12
MAX_SIGNATURE_READ = 32


class InvalidFileSignatureError(Exception):
    def __init__(self, message: str = "Invalid file signature - potential malicious payload"):
        self.message = message
        super().__init__(self.message)


class FileTooSmallError(Exception):
    def __init__(self, message: str = "File too small to be a valid media file"):
        self.message = message
        super().__init__(self.message)


def verify_file_signature(file_bytes: bytes) -> FileInfo:
    """
    Cryptographically verify file signature using magic bytes.
    
    This function reads the first few bytes (magic numbers) of a file to
    determine if it's a genuine media format, completely ignoring the
    file extension which can be easily spoofed by attackers.
    
    Args:
        file_bytes: Raw bytes of the uploaded file
        
    Returns:
        FileInfo: Validated file information including media type and MIME
        
    Raises:
        FileTooSmallError: If file is smaller than minimum threshold
        InvalidFileSignatureError: If file signature doesn't match known media formats
    """
    if len(file_bytes) < MIN_FILE_SIZE:
        raise FileTooSmallError(
            f"File size {len(file_bytes)} bytes is below minimum {MIN_FILE_SIZE} bytes"
        )
    
    header = file_bytes[:MAX_SIGNATURE_READ]
    
    # ── Generic ftyp-box detector (handles ALL M4A/M4V/MP4 variants) ──
    # The ftyp atom size varies: 0x14, 0x18, 0x1c, 0x20, 0x24, 0x28 …
    # We match any 4-byte big-endian box size followed by the literal b'ftyp'
    if len(file_bytes) >= 12 and header[4:8] == b"ftyp":
        # Peek at the brand to decide audio vs video
        brand = header[8:12]
        # M4A brands: M4A (space), mp42, isom, avc1, dash, etc.
        # Audio-only brands include M4A and f4a among others
        audio_brands = {b"M4A ", b"M4B ", b"M4P ", b"f4a ", b"f4b "}
        if brand in audio_brands:
            return FileInfo(
                signature=FileSignature.MP3,   # reuse MP3 slot — media_type is what matters
                media_type="audio",
                mime_type="audio/mp4",
                is_valid=True,
                description=f"M4A audio file (brand={brand.decode(errors='replace')})"
            )
        return FileInfo(
            signature=FileSignature.MP4,
            media_type="video",
            mime_type="video/mp4",
            is_valid=True,
            description=f"MP4/M4V container (brand={brand.decode(errors='replace')})"
        )

    for magic_bytes, file_info in FILE_SIGNATURES.items():
        for magic in magic_bytes:
            if header.startswith(magic):
                return file_info
    
    wav_riff_check = file_bytes[:4] == b"\x52\x49\x46\x46"
    if wav_riff_check and len(file_bytes) >= 12:
        wave_marker = file_bytes[8:12]
        if wave_marker == b"WAVE":
            return FileInfo(
                signature=FileSignature.WAV,
                media_type="audio",
                mime_type="audio/wav",
                is_valid=True,
                description="WAV audio file (RIFF/WAVE)"
            )
        elif wave_marker == b"WEBP":
            return FileInfo(
                signature=FileSignature.WEBP,
                media_type="image",
                mime_type="image/webp",
                is_valid=True,
                description="WebP image file (RIFF/WEBP)"
            )
        elif wave_marker == b"AVI ":
            return FileInfo(
                signature=FileSignature.AVI,
                media_type="video",
                mime_type="video/x-msvideo",
                is_valid=True,
                description="AVI video file (RIFF/AVI)"
            )
    
    webp_riff_check = (
        len(file_bytes) >= 12 and
        file_bytes[:4] == b"\x52\x49\x46\x46" and
        file_bytes[8:12] == b"WEBP"
    )
    if webp_riff_check:
        return FileInfo(
            signature=FileSignature.WEBP,
            media_type="image",
            mime_type="image/webp",
            is_valid=True,
            description="WebP image file"
        )
    
    hex_preview = file_bytes[:16].hex()
    raise InvalidFileSignatureError(
        f"Unrecognized file signature. First 16 bytes (hex): {hex_preview}. "
        "File does not match any supported media format signatures. "
        "Potential malicious payload detected."
    )


def generate_file_hash(file_bytes: bytes) -> str:
    """
    Generate SHA-256 cryptographic hash of file for deduplication.
    
    This creates a unique fingerprint of the file content that can be used
    for:
    - Cryptographic deduplication (avoid re-scanning identical files)
    - Integrity verification
    - Audit trail linking
    
    Args:
        file_bytes: Raw bytes of the file to hash
        
    Returns:
        str: 64-character lowercase hexadecimal SHA-256 hash
    """
    sha256_hash = hashlib.sha256()
    sha256_hash.update(file_bytes)
    return sha256_hash.hexdigest().lower()


def verify_and_hash_file(file_bytes: bytes) -> tuple[FileInfo, str]:
    """
    Combined verification and hashing for efficiency.
    
    Performs both file signature verification and hash generation
    in a single operation.
    
    Args:
        file_bytes: Raw bytes of the uploaded file
        
    Returns:
        tuple: (FileInfo, sha256_hash) - validated file info and hash
        
    Raises:
        FileTooSmallError: If file is too small
        InvalidFileSignatureError: If signature verification fails
    """
    file_info = verify_file_signature(file_bytes)
    file_hash = generate_file_hash(file_bytes)
    return file_info, file_hash


def get_supported_extensions() -> list[str]:
    """Return list of supported file extensions based on signatures."""
    return [
        ".mp4", ".avi", ".mov", ".webm", ".mkv",
        ".wav", ".mp3", ".flac", ".ogg",
        ".png", ".jpg", ".jpeg", ".gif", ".webp", ".bmp"
    ]


def get_supported_mime_types() -> list[str]:
    """Return list of supported MIME types."""
    return list(set(info.mime_type for info in FILE_SIGNATURES.values()))


def is_media_file(file_bytes: bytes) -> bool:
    """
    Quick check if file is a valid media type.
    
    Args:
        file_bytes: Raw bytes to check
        
    Returns:
        bool: True if file signature matches a supported media format
    """
    try:
        verify_file_signature(file_bytes)
        return True
    except (InvalidFileSignatureError, FileTooSmallError):
        return False
