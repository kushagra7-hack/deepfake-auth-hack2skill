"""
API dependencies for Deepfake Authentication Gateway.
Zero-Trust API Perimeter — Firebase ID Token verification.
"""

from typing import Annotated

import cachetools
from firebase_admin import auth as firebase_auth
from firebase_admin.exceptions import FirebaseError
from fastapi import Depends, HTTPException, Request, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer

from app.models.schemas import UserTokenData

security = HTTPBearer(auto_error=False)


class AuthenticationError(HTTPException):
    def __init__(self, detail: str = "Could not validate credentials"):
        super().__init__(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=detail,
            headers={"WWW-Authenticate": "Bearer"},
        )


async def verify_firebase_token(
    credentials: Annotated[HTTPAuthorizationCredentials | None, Depends(security)]
) -> UserTokenData:
    """
    Zero-Trust Firebase ID Token verification dependency.

    Validates Firebase ID Token from the Authorization: Bearer header.
    Steps:
      1. Presence check — rejects missing tokens
      2. Firebase Admin SDK cryptographic verification
      3. Maps Firebase claims -> UserTokenData

    Raises:
      HTTPException 401 for any validation failure
    """
    if credentials is None:
        raise AuthenticationError("Authorization header missing")

    token = credentials.credentials.strip()
    if not token:
        raise AuthenticationError("Token cannot be empty")

    try:
        decoded = firebase_auth.verify_id_token(token, check_revoked=False)
    except firebase_auth.ExpiredIdTokenError:
        raise AuthenticationError("Firebase token has expired — please sign in again")
    except firebase_auth.RevokedIdTokenError:
        raise AuthenticationError("Firebase token has been revoked")
    except firebase_auth.InvalidIdTokenError as e:
        raise AuthenticationError(f"Invalid Firebase token: {e}")
    except FirebaseError as e:
        raise AuthenticationError(f"Firebase auth error: {e}")
    except Exception as e:
        raise AuthenticationError(f"Token validation failed: {e}")

    # Map Firebase claims to our UserTokenData model
    return UserTokenData(
        sub=decoded.get("uid", ""),
        email=decoded.get("email", ""),
        role=decoded.get("role", "user"),
        aud=decoded.get("aud", ""),
        exp=decoded.get("exp", 0),
        iat=decoded.get("iat", 0),
    )


# ── Optional auth ──────────────────────────────────────────────────────────────

async def verify_firebase_token_optional(
    credentials: Annotated[HTTPAuthorizationCredentials | None, Depends(security)]
) -> UserTokenData | None:
    """Optional token verification — returns None if no token provided."""
    if credentials is None:
        return None
    try:
        return await verify_firebase_token(credentials)
    except HTTPException:
        return None


# ── Role helpers ───────────────────────────────────────────────────────────────

async def get_current_user_id(
    user: Annotated[UserTokenData, Depends(verify_firebase_token)]
) -> str:
    return str(user.sub)


async def get_current_user_email(
    user: Annotated[UserTokenData, Depends(verify_firebase_token)]
) -> str:
    return user.email


async def require_admin_role(
    user: Annotated[UserTokenData, Depends(verify_firebase_token)]
) -> UserTokenData:
    if user.role != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Admin access required",
        )
    return user


# ── Rate Limiter (unchanged) ───────────────────────────────────────────────────

class RateLimiter:
    """Simple in-memory rate limiter. Replace with Redis in production."""

    def __init__(self, requests_per_minute: int = 100):
        self.requests_per_minute = requests_per_minute
        self._requests = cachetools.TTLCache(maxsize=10000, ttl=60)

    async def __call__(self, request: Request) -> None:
        import time
        client_ip = request.client.host if request.client else "unknown"
        current_time = time.time()
        try:
            reqs = self._requests[client_ip]
        except KeyError:
            reqs = []
        reqs = [t for t in reqs if current_time - t < 60]
        if len(reqs) >= self.requests_per_minute:
            raise HTTPException(
                status_code=status.HTTP_429_TOO_MANY_REQUESTS,
                detail=f"Rate limit exceeded: {self.requests_per_minute} req/min",
            )
        reqs.append(current_time)
        self._requests[client_ip] = reqs


rate_limiter = RateLimiter(requests_per_minute=100)

# ── Typed shorthand aliases ────────────────────────────────────────────────────

ValidatedUser  = Annotated[UserTokenData, Depends(verify_firebase_token)]
OptionalUser   = Annotated[UserTokenData | None, Depends(verify_firebase_token_optional)]
AdminUser      = Annotated[UserTokenData, Depends(require_admin_role)]
CurrentUserId  = Annotated[str, Depends(get_current_user_id)]
CurrentUserEmail = Annotated[str, Depends(get_current_user_email)]

# Removed legacy Supabase alias
