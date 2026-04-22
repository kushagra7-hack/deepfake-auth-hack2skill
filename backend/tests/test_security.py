import pytest
from app.core.security import verify_file_signature, generate_file_hash, FileSignature

def test_generate_file_hash():
    data = b"testdata"
    hash_val = generate_file_hash(data)
    assert len(hash_val) == 64
    assert hash_val == "8104ba1dc0409b259f487ed07db477c2250bd6e60b29c54ff916d7a469a47313"

def test_verify_file_signature_jpeg():
    # Valid JPEG header
    jpeg_bytes = b"\xff\xd8\xff\xe0\x00\x10\x4a\x46\x49\x46\x00\x01\x01\x00\x00\x01\x00\x01\x00\x00"
    file_info = verify_file_signature(jpeg_bytes)
    assert file_info.is_valid
    assert file_info.signature == FileSignature.JPEG
    assert file_info.media_type == "image"

def test_verify_file_signature_png():
    # Valid PNG header
    png_bytes = b"\x89\x50\x4e\x47\x0d\x0a\x1a\x0a\x00\x00\x00\x0d\x49\x48\x44\x52"
    file_info = verify_file_signature(png_bytes)
    assert file_info.is_valid
    assert file_info.signature == FileSignature.PNG

def test_verify_file_signature_invalid():
    invalid_bytes = b"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
    file_info = verify_file_signature(invalid_bytes)
    assert not file_info.is_valid

def test_verify_file_signature_riff_wav():
    # RIFF header with WAVE
    wav_bytes = b"\x52\x49\x46\x46\x00\x00\x00\x00\x57\x41\x56\x45"
    file_info = verify_file_signature(wav_bytes)
    assert file_info.is_valid
    assert file_info.signature == FileSignature.WAV
    assert file_info.media_type == "audio"

def test_verify_file_signature_riff_webp():
    # RIFF header with WEBP
    webp_bytes = b"\x52\x49\x46\x46\x00\x00\x00\x00\x57\x45\x42\x50"
    file_info = verify_file_signature(webp_bytes)
    assert file_info.is_valid
    assert file_info.signature == FileSignature.WEBP
    assert file_info.media_type == "image"
