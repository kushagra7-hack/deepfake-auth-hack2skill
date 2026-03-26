"""
API dependencies for Deepfake Authentication Gateway.
Implements Zero-Trust API Perimeter with JWT validation.
"""

from typing import Annotated

import jwt
from fastapi import Depends, HTTPException, Request, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from jwt.exceptions import DecodeError, ExpiredSignatureError, InvalidTokenError

from app.core.config import settings
from app.models.schemas import UserTokenData

security = HTTPBearer(auto_error=False)


class AuthenticationError(HTTPException):
    def __init__(self, detail: str = "Could not validate credentials"):
        super().__init__(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=detail,
            headers={"WWW-Authenticate": "Bearer"}
        )


class TokenValidationError(Exception):
    pass


async def verify_supabase_jwt(
    credentials: Annotated[HTTPAuthorizationCredentials | None, Depends(security)]
) -> UserTokenData:
    """
    Zero-Trust JWT verification dependency.
    
    Validates Supabase JWT token from Authorization header.
    Implements defense-in-depth security:
    1. Presence check - rejects missing tokens
    2. Format validation - validates JWT structure
    3. Signature verification - cryptographically verifies authenticity
    4. Expiration check - ensures token hasn't expired
    5. Audience validation - confirms token is for our application
    
    Args:
        credentials: HTTP Authorization credentials from Bearer token
        
    Returns:
        UserTokenData: Validated user information from token payload
        
    Raises:
        HTTPException: 401 Unauthorized for any validation failure
    """
    if credentials is None:
        raise AuthenticationError("Authorization header missing")
    
    token = credentials.credentials
    
    if not token or not token.strip():
        raise AuthenticationError("Token cannot be empty")
    
    token = token.strip()
    
    token_parts = token.split(".")
    if len(token_parts) != 3:
        raise AuthenticationError("Invalid JWT format - must have 3 parts")
    
    for part in token_parts:
        if not part:
            raise AuthenticationError("Invalid JWT format - empty segment")
    
    try:
        payload = jwt.decode(
            token,
            settings.SUPABASE_JWT_SECRET,
            algorithms=["HS256"],
            audience=settings.JWT_AUDIENCE,
            options={
                "verify_signature": True,
                "verify_exp": True,
                "verify_iat": True,
                "verify_aud": True,
                "require": ["exp", "iat", "sub", "aud"]
            }
        )
        
        user_data = UserTokenData(**payload)
        
        return user_data
        
    except ExpiredSignatureError:
        raise AuthenticationError("Token has expired - please refresh your session")
    except DecodeError as e:
        raise AuthenticationError(f"Invalid token encoding: {str(e)}")
    except InvalidTokenError as e:
        raise AuthenticationError(f"Invalid token: {str(e)}")
    except Exception as e:
        raise AuthenticationError(f"Token validation failed: {str(e)}")


async def verify_supabase_jwt_optional(
    credentials: Annotated[HTTPAuthorizationCredentials | None, Depends(security)]
) -> UserTokenData | None:
    """
    Optional JWT verification - returns None if no token provided.
    
    Useful for endpoints that work with or without authentication,
    but may provide additional data when authenticated.
    
    Args:
        credentials: Optional HTTP Authorization credentials
        
    Returns:
        UserTokenData | None: User data if token valid, None otherwise
    """
    if credentials is None:
        return None
    
    try:
        return await verify_supabase_jwt(credentials)
    except HTTPException:
        return None


async def get_current_user_id(
    user: Annotated[UserTokenData, Depends(verify_supabase_jwt)]
) -> str:
    """
    Extract user ID from validated token.
    
    Args:
        user: Validated user token data
        
    Returns:
        str: User's unique identifier
    """
    return str(user.sub)


async def get_current_user_email(
    user: Annotated[UserTokenData, Depends(verify_supabase_jwt)]
) -> str:
    """
    Extract user email from validated token.
    
    Args:
        user: Validated user token data
        
    Returns:
        str: User's email address
    """
    return user.email


async def require_admin_role(
    user: Annotated[UserTokenData, Depends(verify_supabase_jwt)]
) -> UserTokenData:
    """
    Dependency that requires user to have admin role.
    
    Use this for admin-only endpoints.
    
    Args:
        user: Validated user token data
        
    Returns:
        UserTokenData: User data if admin
        
    Raises:
        HTTPException: 403 Forbidden if not admin
    """
    if user.role != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Admin access required"
        )
    return user


class RateLimiter:
    """
    Simple in-memory rate limiter for API endpoints.
    
    For production, replace with Redis-based rate limiting.
    """
    
    def __init__(self, requests_per_minute: int = 60):
        self.requests_per_minute = requests_per_minute
        self._requests: dict[str, list[float]] = {}
    
    async def __call__(self, request: Request) -> None:
        """
        Check rate limit for current request.
        
        Args:
            request: FastAPI request object
            
        Raises:
            HTTPException: 429 Too Many Requests if limit exceeded
        """
        import time
        
        client_ip = request.client.host if request.client else "unknown"
        current_time = time.time()
        
        if client_ip not in self._requests:
            self._requests[client_ip] = []
        
        self._requests[client_ip] = [
            timestamp
            for timestamp in self._requests[client_ip]
            if current_time - timestamp < 60
        ]
        
        if len(self._requests[client_ip]) >= self.requests_per_minute:
            raise HTTPException(
                status_code=status.HTTP_429_TOO_MANY_REQUESTS,
                detail=f"Rate limit exceeded: {self.requests_per_minute} requests per minute"
            )
        
        self._requests[client_ip].append(current_time)


rate_limiter = RateLimiter(requests_per_minute=100)


ValidatedUser = Annotated[UserTokenData, Depends(verify_supabase_jwt)]
OptionalUser = Annotated[UserTokenData | None, Depends(verify_supabase_jwt_optional)]
AdminUser = Annotated[UserTokenData, Depends(require_admin_role)]
CurrentUserId = Annotated[str, Depends(get_current_user_id)]
CurrentUserEmail = Annotated[str, Depends(get_current_user_email)]
