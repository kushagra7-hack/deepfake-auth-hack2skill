"""
Application configuration for Deepfake Authentication Gateway.
Uses Pydantic Settings for type-safe environment variable loading.
Firebase replaces Supabase for auth and database.
"""

from functools import lru_cache
from pathlib import Path
from typing import Literal

from pydantic import Field, field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Application settings loaded from environment variables."""

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=True,
        extra="ignore"
    )

    APP_NAME: str = "Deepfake Authentication Gateway"
    APP_VERSION: str = "1.0.0"
    DEBUG: bool = False
    ENVIRONMENT: Literal["development", "staging", "production"] = "production"

    # ── Firebase ─────────────────────────────────────────────────────────────
    FIREBASE_CREDENTIALS_PATH: str = Field(
        default="firebase-service-account.json",
        description="Path to Firebase service account JSON file"
    )
    FIREBASE_PROJECT_ID: str = Field(
        default="nexus-gateway-cca4c",
        description="Firebase / GCP project ID"
    )

    # ── AI APIs ──────────────────────────────────────────────────────────────
    HUGGINGFACE_API_TOKEN: str = Field(..., description="HuggingFace Inference API Token")
    NVIDIA_API_KEY: str = Field(default="", description="NVIDIA NIM API key for Tier-2 analysis")

    # ── JWT (kept for legacy token parsing if needed) ────────────────────────
    JWT_AUDIENCE: str = "authenticated"
    JWT_ALGORITHM: str = "HS256"

    # ── File Upload ───────────────────────────────────────────────────────────
    MAX_FILE_SIZE: int = Field(default=104857600, description="Max upload size in bytes (100 MB)")
    ALLOWED_EXTENSIONS: str = ".mp4,.avi,.mov,.webm,.mkv,.wav,.mp3,.flac,.ogg,.png,.jpg,.jpeg,.gif,.webp,.bmp"

    # ── Scanning ──────────────────────────────────────────────────────────────
    SCAN_TIMEOUT: int = Field(default=300, description="Scan processing timeout in seconds")
    THREAT_THRESHOLD_LOW: float = Field(default=30.0, ge=0, le=100)
    THREAT_THRESHOLD_HIGH: float = Field(default=70.0, ge=0, le=100)

    # ── Rate Limiting ─────────────────────────────────────────────────────────
    RATE_LIMIT_REQUESTS: int = Field(default=100, description="Requests per minute per IP")
    RATE_LIMIT_ENABLED: bool = True

    # ── CORS ─────────────────────────────────────────────────────────────────
    CORS_ORIGINS: str = "http://localhost:3000,http://localhost:8080"
    CORS_ALLOW_CREDENTIALS: bool = True
    CORS_ALLOW_METHODS: str = "*"
    CORS_ALLOW_HEADERS: str = "*"

    # ── Validators ────────────────────────────────────────────────────────────
    @field_validator("FIREBASE_CREDENTIALS_PATH")
    @classmethod
    def validate_credentials_path(cls, v: str) -> str:
        # Allow relative paths — resolved at runtime from CWD (backend/)
        return v

    @field_validator("ENVIRONMENT")
    @classmethod
    def validate_environment(cls, v: str) -> str:
        allowed = ["development", "staging", "production"]
        if v not in allowed:
            raise ValueError(f"ENVIRONMENT must be one of: {allowed}")
        return v

    # ── Computed properties ───────────────────────────────────────────────────
    @property
    def allowed_extensions_list(self) -> list[str]:
        return [ext.strip() for ext in self.ALLOWED_EXTENSIONS.split(",")]

    @property
    def cors_origins_list(self) -> list[str]:
        if self.CORS_ORIGINS == "*":
            return ["*"]
        return [origin.strip() for origin in self.CORS_ORIGINS.split(",")]

    @property
    def is_production(self) -> bool:
        return self.ENVIRONMENT == "production"

    @property
    def is_development(self) -> bool:
        return self.ENVIRONMENT == "development"


@lru_cache
def get_settings() -> Settings:
    return Settings()


settings = get_settings()
