"""
FastAPI application entry point for Deepfake Authentication Gateway.
"""

import logging
import sys
from contextlib import asynccontextmanager
from datetime import datetime, timezone
from typing import Any

from fastapi import FastAPI, Request, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from app.api.routes import scan
from app.core.config import settings
from app.models.schemas import ErrorResponse, HealthResponse

logging.basicConfig(
    level=logging.DEBUG if settings.DEBUG else logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    handlers=[logging.StreamHandler(sys.stdout)],
)
# Silence noisy HTTP library logs
logging.getLogger("hpack").setLevel(logging.WARNING)
logging.getLogger("httpcore").setLevel(logging.WARNING)
logging.getLogger("httpx").setLevel(logging.WARNING)

logger = logging.getLogger(__name__)


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Application lifespan manager for startup/shutdown events."""
    logger.info(f"Starting {settings.APP_NAME} v{settings.APP_VERSION}")
    logger.info(f"Environment: {settings.ENVIRONMENT}")
    logger.info(f"Debug mode: {settings.DEBUG}")
    
    from app.services.firebase_config import initialize_firebase, get_firestore
    initialize_firebase()
    try:
        db = get_firestore()
        logger.info("Firestore connection established successfully")
    except Exception as e:
        logger.warning(f"Firestore connection check failed: {e}")
    
    yield
    
    from app.services.hf_client import get_hf_client
    hf_client = await get_hf_client()
    await hf_client.close()
    logger.info("Cleaned up HuggingFace client")
    
    logger.info(f"Shutting down {settings.APP_NAME}")


app = FastAPI(
    title=settings.APP_NAME,
    version=settings.APP_VERSION,
    description="Enterprise-Grade Deepfake Detection API with Zero-Trust Security",
    docs_url="/api/docs" if settings.DEBUG else None,
    redoc_url="/api/redoc" if settings.DEBUG else None,
    openapi_url="/api/openapi.json" if settings.DEBUG else None,
    lifespan=lifespan,
)

# Explicit origins list: browser blocks credentials=true with wildcard *
# Always include the Firebase hosting URL and local dev ports.
_ALLOWED_ORIGINS = [
    "https://nexus-gateway-cca4c.web.app",
    "https://nexus-gateway-cca4c.firebaseapp.com",
    "https://nexus-gateway-cca4c--*.web.app",  # Firebase preview channels
    "http://localhost:3000",
    "http://localhost:8080",
    "http://localhost:5000",
    "http://localhost:52022",
    "http://127.0.0.1:3000",
    "http://127.0.0.1:8080",
    "http://127.0.0.1:52022",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=_ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    # CRITICAL: Cannot use '*' with allow_credentials=True — browsers block the preflight.
    # Must enumerate the exact headers the Flutter client sends.
    allow_headers=["Authorization", "Content-Type", "Accept", "Origin",
                   "X-Requested-With", "X-Request-ID"],
    max_age=600,
)

app.include_router(scan.router, prefix="/api")


@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception) -> JSONResponse:
    """Global exception handler for unhandled errors."""
    logger.error(f"Unhandled exception: {exc}", exc_info=True)
    
    error_response = ErrorResponse(
        error="internal_server_error",
        message="An unexpected error occurred" if not settings.DEBUG else str(exc),
        details={"path": str(request.url)} if settings.DEBUG else None,
    )
    
    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content=error_response.model_dump(),
    )


@app.get(
    "/",
    response_model=HealthResponse,
    tags=["health"],
    summary="Root endpoint",
)
async def root() -> HealthResponse:
    """Root endpoint returning service info."""
    return HealthResponse(
        status="operational",
        version=settings.APP_VERSION,
        timestamp=datetime.now(timezone.utc),
    )


@app.get(
    "/health",
    response_model=HealthResponse,
    tags=["health"],
    summary="Health check endpoint",
)
async def health_check() -> HealthResponse:
    """Health check endpoint for load balancers and monitoring."""
    return HealthResponse(
        status="healthy",
        version=settings.APP_VERSION,
        timestamp=datetime.now(timezone.utc),
    )


@app.get(
    "/ready",
    response_model=dict[str, Any],
    tags=["health"],
    summary="Readiness check endpoint",
)
async def readiness_check() -> dict[str, Any]:
    """
    Readiness check endpoint for Kubernetes/container orchestration.
    Verifies all dependencies are available.
    """
    checks: dict[str, Any] = {
        "status": "ready",
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "version": settings.APP_VERSION,
        "checks": {}
    }
    
    try:
        from app.services.firebase_config import get_firestore
        _ = get_firestore()
        checks["checks"]["database"] = "connected"
    except Exception as e:
        checks["checks"]["database"] = f"error: {str(e)}"
        checks["status"] = "not_ready"
    
    checks["checks"]["huggingface_api"] = "configured" if settings.HUGGINGFACE_API_TOKEN else "not_configured"
    
    all_healthy = all(
        v in ["connected", "configured", "ok"] 
        for v in checks["checks"].values()
    )
    
    if not all_healthy:
        checks["status"] = "degraded"
    
    return checks


@app.middleware("http")
async def add_security_headers(request: Request, call_next):
    """Add security headers to all responses."""
    response = await call_next(request)
    response.headers["X-Content-Type-Options"] = "nosniff"
    response.headers["X-Frame-Options"] = "SAMEORIGIN"
    response.headers["X-XSS-Protection"] = "1; mode=block"
    response.headers["Referrer-Policy"] = "strict-origin-when-cross-origin"
    # NOTE: No Content-Security-Policy here — it blocks Firebase/CDN resources
    return response


@app.middleware("http")
async def log_requests(request: Request, call_next):
    """Log all incoming requests with timing."""
    start_time = datetime.now(timezone.utc)
    response = await call_next(request)
    duration_ms = (datetime.now(timezone.utc) - start_time).total_seconds() * 1000
    logger.info(
        f"{request.method} {request.url.path} - "
        f"Status: {response.status_code} - "
        f"Duration: {duration_ms:.2f}ms"
    )
    return response


if __name__ == "__main__":
    import uvicorn
    
    uvicorn.run(
        "app.main:app",
        host="0.0.0.0",
        port=8000,
        reload=settings.DEBUG,
        workers=1 if settings.DEBUG else 4,
        log_level="debug" if settings.DEBUG else "info",
    )
