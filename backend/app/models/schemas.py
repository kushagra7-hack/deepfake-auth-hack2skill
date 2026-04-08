"""
Strict Pydantic models for Deepfake Authentication Gateway API.
Provides request/response validation with zero-trust principles.
"""

from datetime import datetime
from decimal import Decimal
from enum import Enum
from typing import Any, Dict, Optional
from uuid import UUID

from pydantic import BaseModel, Field, field_validator, model_validator


class ScanStatus(str, Enum):
    PENDING = "pending"
    PROCESSING = "processing"
    COMPLETED = "completed"
    FAILED = "failed"


class MediaType(str, Enum):
    IMAGE = "image"
    VIDEO = "video"
    AUDIO = "audio"


class UserRole(str, Enum):
    USER = "user"
    ADMIN = "admin"
    ANALYST = "analyst"


class ScanCreate(BaseModel):
    file_name: str = Field(..., min_length=1, max_length=500, description="Original filename")
    file_hash: str = Field(..., min_length=64, max_length=64, description="SHA-256 hash (64 hex chars)")
    file_size: int = Field(..., gt=0, le=5368709120, description="File size in bytes (max 5GB)")
    media_type: MediaType = Field(..., description="Type of media file")

    @field_validator("file_hash")
    @classmethod
    def validate_file_hash(cls, v: str) -> str:
        if not all(c in "0123456789abcdefABCDEF" for c in v):
            raise ValueError("file_hash must be a valid hexadecimal SHA-256 hash")
        return v.lower()

    @field_validator("file_name")
    @classmethod
    def validate_file_name(cls, v: str) -> str:
        forbidden_chars = ["../", "..\\", "\x00"]
        for char in forbidden_chars:
            if char in v:
                raise ValueError(f"file_name contains forbidden sequence: {char}")
        return v


class ScanResponse(BaseModel):
    id: Any = Field(..., description="Unique scan identifier")
    user_id: Any = Field(..., description="Owner user ID")
    file_name: str = Field(..., description="Original filename")
    file_hash: str = Field(..., description="SHA-256 hash")
    threat_score: Optional[Decimal] = Field(None, ge=0, le=100, description="Threat score 0-100")
    status: ScanStatus = Field(..., description="Current scan status")
    media_type: Optional[str] = Field(None, description="Media type")
    file_size: Optional[int] = Field(None, description="File size in bytes")
    result_details: Optional[Dict[str, Any]] = Field(None, description="Detailed analysis results")
    created_at: Optional[datetime] = Field(None, description="Scan creation timestamp")
    completed_at: Optional[datetime] = Field(None, description="Scan completion timestamp")

    model_config = {"from_attributes": True}


class ScanListResponse(BaseModel):
    scans: list[ScanResponse] = Field(..., description="List of scans")
    total: int = Field(..., ge=0, description="Total count")
    page: int = Field(..., ge=1, description="Current page")
    page_size: int = Field(..., ge=1, le=100, description="Items per page")


class UserTokenData(BaseModel):
    sub: UUID = Field(..., description="User ID from Supabase Auth")
    email: str = Field(..., description="User email")
    role: Optional[str] = Field(None, description="User role")
    aud: str = Field(..., description="JWT audience")
    exp: int = Field(..., description="Expiration timestamp")
    iat: int = Field(..., description="Issued at timestamp")

    @field_validator("email")
    @classmethod
    def validate_email(cls, v: str) -> str:
        if "@" not in v or "." not in v.split("@")[-1]:
            raise ValueError("Invalid email format")
        return v.lower()


class UserProfile(BaseModel):
    id: UUID = Field(..., description="User ID")
    email: str = Field(..., description="User email")
    full_name: Optional[str] = Field(None, description="User full name")
    role: UserRole = Field(default=UserRole.USER, description="User role")
    created_at: datetime = Field(..., description="Account creation timestamp")
    is_active: bool = Field(default=True, description="Account active status")

    model_config = {"from_attributes": True}


class UserProfileUpdate(BaseModel):
    full_name: Optional[str] = Field(None, min_length=1, max_length=255)


class ErrorResponse(BaseModel):
    error: str = Field(..., description="Error type")
    message: str = Field(..., description="Error message")
    details: Optional[Dict[str, Any]] = Field(None, description="Additional details")


class ScanStatsResponse(BaseModel):
    total_scans: int = Field(..., ge=0, description="Total number of scans")
    pending_scans: int = Field(..., ge=0, description="Pending scans count")
    completed_scans: int = Field(..., ge=0, description="Completed scans count")
    avg_threat_score: Decimal = Field(..., ge=0, le=100, description="Average threat score")


class FileUploadRequest(BaseModel):
    file_name: str = Field(..., min_length=1, max_length=500)
    media_type: MediaType = Field(...)

    @field_validator("file_name")
    @classmethod
    def sanitize_filename(cls, v: str) -> str:
        forbidden = ["../", "..\\", "\x00", "<", ">", ":", '"', "|", "?", "*"]
        for char in forbidden:
            if char in v:
                raise ValueError(f"Filename contains forbidden character: {char}")
        return v.strip()


class HealthResponse(BaseModel):
    status: str = Field(..., description="Service status")
    version: str = Field(..., description="API version")
    timestamp: datetime = Field(default_factory=datetime.utcnow)
