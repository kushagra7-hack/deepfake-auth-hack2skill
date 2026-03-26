"""
Application configuration for Deepfake Authentication Gateway.
Uses Pydantic Settings for type-safe environment variable loading.
"""

from functools import lru_cache
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
    
    SUPABASE_URL: str = Field(..., description="Supabase project URL")
    SUPABASE_ANON_KEY: str = Field(..., description="Supabase anonymous key")
    SUPABASE_SERVICE_ROLE_KEY: str = Field(..., description="Supabase service role key")
    SUPABASE_JWT_SECRET: str = Field(..., description="Supabase JWT secret for token verification")
    
    DATABASE_URL: str = Field(..., description="PostgreSQL connection string")
    
    JWT_AUDIENCE: str = "authenticated"
    JWT_ALGORITHM: str = "HS256"
    
    MAX_FILE_SIZE: int = Field(default=5368709120, description="Max upload size in bytes (5GB)")
    ALLOWED_EXTENSIONS: str = ".mp4,.avi,.mov,.webm,.mkv,.wav,.mp3,.flac,.ogg,.png,.jpg,.jpeg,.gif,.webp,.bmp"
    
    SCAN_TIMEOUT: int = Field(default=300, description="Scan processing timeout in seconds")
    THREAT_THRESHOLD_LOW: float = Field(default=30.0, ge=0, le=100)
    THREAT_THRESHOLD_HIGH: float = Field(default=70.0, ge=0, le=100)
    
    RATE_LIMIT_REQUESTS: int = Field(default=100, description="Requests per minute per IP")
    RATE_LIMIT_ENABLED: bool = True
    
    CORS_ORIGINS: str = "*"
    CORS_ALLOW_CREDENTIALS: bool = True
    CORS_ALLOW_METHODS: str = "*"
    CORS_ALLOW_HEADERS: str = "*"
    
    @field_validator("SUPABASE_URL")
    @classmethod
    def validate_supabase_url(cls, v: str) -> str:
        if not v.startswith("https://"):
            raise ValueError("SUPABASE_URL must start with https://")
        return v.rstrip("/")
    
    @field_validator("SUPABASE_JWT_SECRET")
    @classmethod
    def validate_jwt_secret(cls, v: str) -> str:
        if len(v) < 32:
            raise ValueError("JWT secret must be at least 32 characters")
        return v
    
    @field_validator("ENVIRONMENT")
    @classmethod
    def validate_environment(cls, v: str) -> str:
        allowed = ["development", "staging", "production"]
        if v not in allowed:
            raise ValueError(f"ENVIRONMENT must be one of: {allowed}")
        return v
    
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
