"""
Authentication API routes for Deepfake Authentication Gateway.
Handles user authentication, profile management, and session operations.
"""

import logging
from datetime import datetime, timezone
from typing import Annotated, Any

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from pydantic import BaseModel, EmailStr, Field

from app.api.dependencies import (
    CurrentUserEmail,
    CurrentUserId,
    OptionalUser,
    ValidatedUser,
    verify_supabase_jwt,
)
from app.core.config import settings
from app.models.schemas import (
    ErrorResponse,
    UserProfile,
    UserProfileUpdate,
    UserTokenData,
)

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/auth", tags=["authentication"])
security = HTTPBearer()


class LoginRequest(BaseModel):
    email: EmailStr = Field(..., description="User email address")
    password: str = Field(..., min_length=8, description="User password")


class LoginResponse(BaseModel):
    access_token: str = Field(..., description="JWT access token")
    refresh_token: str | None = Field(None, description="Refresh token")
    token_type: str = Field(default="bearer", description="Token type")
    expires_in: int = Field(..., description="Token expiration in seconds")
    user: UserTokenData = Field(..., description="User information")


class RegisterRequest(BaseModel):
    email: EmailStr = Field(..., description="User email address")
    password: str = Field(..., min_length=8, max_length=128, description="User password")
    full_name: str | None = Field(None, max_length=255, description="User full name")


class RegisterResponse(BaseModel):
    message: str = Field(..., description="Success message")
    user_id: str = Field(..., description="Created user ID")
    email: str = Field(..., description="User email")


class RefreshRequest(BaseModel):
    refresh_token: str = Field(..., description="Refresh token")


class LogoutResponse(BaseModel):
    message: str = Field(..., description="Logout confirmation")


class PasswordResetRequest(BaseModel):
    email: EmailStr = Field(..., description="User email address")


class PasswordUpdateRequest(BaseModel):
    current_password: str = Field(..., min_length=8, description="Current password")
    new_password: str = Field(..., min_length=8, max_length=128, description="New password")


class TokenValidationResponse(BaseModel):
    valid: bool = Field(..., description="Token validity")
    user: UserTokenData | None = Field(None, description="User data if valid")
    expires_at: int | None = Field(None, description="Token expiration timestamp")


@router.post(
    "/register",
    response_model=RegisterResponse,
    responses={
        400: {"model": ErrorResponse, "description": "Invalid request"},
        409: {"model": ErrorResponse, "description": "Email already registered"},
    },
    summary="Register new user",
    description="Create a new user account with Supabase Auth",
)
async def register(request_data: RegisterRequest) -> RegisterResponse:
    """
    Register a new user account.
    
    Creates a user in Supabase Auth and triggers profile creation.
    """
    try:
        from app.services.supabase_db import get_supabase_client
        
        client = await get_supabase_client()
        
        result = await client.auth.sign_up({
            "email": request_data.email,
            "password": request_data.password,
            "options": {
                "data": {
                    "full_name": request_data.full_name
                } if request_data.full_name else {}
            }
        })
        
        if result.user is None:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Registration failed - user not created"
            )
        
        logger.info(f"User registered: {request_data.email}")
        
        return RegisterResponse(
            message="Registration successful. Please check your email for verification.",
            user_id=str(result.user.id),
            email=request_data.email,
        )
        
    except Exception as e:
        error_str = str(e).lower()
        
        if "already registered" in error_str or "already exists" in error_str:
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="Email already registered"
            )
        
        logger.error(f"Registration error: {e}")
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Registration failed: {str(e)}"
        )


@router.post(
    "/login",
    response_model=LoginResponse,
    responses={
        401: {"model": ErrorResponse, "description": "Invalid credentials"},
    },
    summary="User login",
    description="Authenticate user and return tokens",
)
async def login(request_data: LoginRequest) -> LoginResponse:
    """
    Authenticate user and return JWT tokens.
    
    Uses Supabase Auth for credential verification.
    """
    try:
        from app.services.supabase_db import get_supabase_client
        
        client = await get_supabase_client()
        
        result = await client.auth.sign_in_with_password({
            "email": request_data.email,
            "password": request_data.password,
        })
        
        if result.session is None or result.user is None:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid credentials"
            )
        
        logger.info(f"User logged in: {request_data.email}")
        
        user_data = UserTokenData(
            sub=result.user.id,
            email=result.user.email or request_data.email,
            role=result.user.user_metadata.get("role", "user"),
            aud="authenticated",
            exp=result.session.expires_at or 0,
            iat=result.session.expires_at - 3600 if result.session.expires_at else 0,
        )
        
        return LoginResponse(
            access_token=result.session.access_token,
            refresh_token=result.session.refresh_token,
            token_type="bearer",
            expires_in=result.session.expires_in or 3600,
            user=user_data,
        )
        
    except Exception as e:
        error_str = str(e).lower()
        
        if "invalid login credentials" in error_str or "invalid" in error_str:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid email or password"
            )
        
        logger.error(f"Login error: {e}")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Authentication failed"
        )


@router.post(
    "/logout",
    response_model=LogoutResponse,
    responses={
        401: {"model": ErrorResponse, "description": "Unauthorized"},
    },
    summary="User logout",
    description="Invalidate current session",
)
async def logout(
    user_id: CurrentUserId,
    _: ValidatedUser,
    credentials: HTTPAuthorizationCredentials = Depends(security),
) -> LogoutResponse:
    """
    Logout user and invalidate session.
    
    Signs out from Supabase Auth.
    """
    try:
        from app.services.supabase_db import get_supabase_client
        
        client = await get_supabase_client()
        
        await client.auth.sign_out()
        
        logger.info(f"User logged out: {user_id}")
        
        return LogoutResponse(message="Successfully logged out")
        
    except Exception as e:
        logger.error(f"Logout error: {e}")
        return LogoutResponse(message="Logged out (session may still be active)")


@router.post(
    "/refresh",
    response_model=LoginResponse,
    responses={
        401: {"model": ErrorResponse, "description": "Invalid refresh token"},
    },
    summary="Refresh access token",
    description="Exchange refresh token for new access token",
)
async def refresh_token(request_data: RefreshRequest) -> LoginResponse:
    """
    Refresh access token using refresh token.
    
    Returns new JWT tokens.
    """
    try:
        from app.services.supabase_db import get_supabase_client
        
        client = await get_supabase_client()
        
        result = await client.auth.refresh_session(request_data.refresh_token)
        
        if result.session is None or result.user is None:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid or expired refresh token"
            )
        
        logger.info(f"Token refreshed for user: {result.user.id}")
        
        user_data = UserTokenData(
            sub=result.user.id,
            email=result.user.email or "",
            role=result.user.user_metadata.get("role", "user"),
            aud="authenticated",
            exp=result.session.expires_at or 0,
            iat=result.session.expires_at - 3600 if result.session.expires_at else 0,
        )
        
        return LoginResponse(
            access_token=result.session.access_token,
            refresh_token=result.session.refresh_token,
            token_type="bearer",
            expires_in=result.session.expires_in or 3600,
            user=user_data,
        )
        
    except Exception as e:
        logger.error(f"Token refresh error: {e}")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token refresh failed"
        )


@router.post(
    "/password/reset",
    response_model=dict[str, str],
    responses={
        200: {"description": "Reset email sent"},
    },
    summary="Request password reset",
    description="Send password reset email to user",
)
async def request_password_reset(request_data: PasswordResetRequest) -> dict[str, str]:
    """
    Request password reset email.
    
    Sends a password reset link to the user's email.
    """
    try:
        from app.services.supabase_db import get_supabase_client
        
        client = await get_supabase_client()
        
        await client.auth.reset_password_email(request_data.email)
        
        logger.info(f"Password reset requested for: {request_data.email}")
        
        return {
            "message": "If the email exists, a password reset link has been sent"
        }
        
    except Exception as e:
        logger.error(f"Password reset error: {e}")
        return {
            "message": "If the email exists, a password reset link has been sent"
        }


@router.post(
    "/password/update",
    response_model=dict[str, str],
    responses={
        401: {"model": ErrorResponse, "description": "Unauthorized"},
        400: {"model": ErrorResponse, "description": "Invalid password"},
    },
    summary="Update password",
    description="Update user password",
)
async def update_password(
    request_data: PasswordUpdateRequest,
    user_id: CurrentUserId,
    user_email: CurrentUserEmail,
    _: ValidatedUser,
) -> dict[str, str]:
    """
    Update user password.
    
    Requires current password for verification.
    """
    try:
        from app.services.supabase_db import get_supabase_client
        
        client = await get_supabase_client()
        
        # Verify current password
        auth_result = await client.auth.sign_in_with_password({
            "email": user_email,
            "password": request_data.current_password
        })
        
        if auth_result.user is None:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid current password"
            )
            
        await client.auth.update_user({
            "password": request_data.new_password
        })
        
        logger.info(f"Password updated for user: {user_id}")
        
        return {"message": "Password updated successfully"}
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Password update error: {e}")
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Failed to update password"
        )


@router.get(
    "/me",
    response_model=UserProfile,
    responses={
        401: {"model": ErrorResponse, "description": "Unauthorized"},
    },
    summary="Get current user profile",
    description="Retrieve authenticated user's profile information",
)
async def get_current_profile(
    user_id: CurrentUserId,
    user_email: CurrentUserEmail,
    user: ValidatedUser,
) -> UserProfile:
    """
    Get current user profile.
    
    Returns user information from validated JWT.
    """
    try:
        from app.services.supabase_db import get_supabase_client
        
        client = await get_supabase_client()
        
        result = await client.table("users").select("*").eq("id", user_id).limit(1).execute()
        
        if result.data and len(result.data) > 0:
            profile = result.data[0]
            return UserProfile(
                id=profile.get("id"),
                email=profile.get("email", user_email),
                full_name=profile.get("full_name"),
                role=profile.get("role", "user"),
                created_at=profile.get("created_at"),
                is_active=profile.get("is_active", True),
            )
        
        return UserProfile(
            id=user_id,
            email=user_email,
            full_name=None,
            role="user",
            created_at=datetime.now(timezone.utc),
            is_active=True,
        )
        
    except Exception as e:
        logger.error(f"Error fetching profile: {e}")
        return UserProfile(
            id=user_id,
            email=user_email,
            full_name=None,
            role="user",
            created_at=datetime.now(timezone.utc),
            is_active=True,
        )


@router.patch(
    "/me",
    response_model=UserProfile,
    responses={
        401: {"model": ErrorResponse, "description": "Unauthorized"},
    },
    summary="Update user profile",
    description="Update current user's profile information",
)
async def update_profile(
    update_data: UserProfileUpdate,
    user_id: CurrentUserId,
    user_email: CurrentUserEmail,
    _: ValidatedUser,
) -> UserProfile:
    """
    Update user profile.
    
    Updates user information in database.
    """
    try:
        from app.services.supabase_db import get_supabase_client
        
        client = await get_supabase_client()
        
        update_dict = {}
        if update_data.full_name is not None:
            update_dict["full_name"] = update_data.full_name
            update_dict["updated_at"] = datetime.now(timezone.utc).isoformat()
        
        if update_dict:
            result = await client.table("users").update(update_dict).eq("id", user_id).execute()
            
            if result.data and len(result.data) > 0:
                profile = result.data[0]
                return UserProfile(
                    id=profile.get("id"),
                    email=profile.get("email", user_email),
                    full_name=profile.get("full_name"),
                    role=profile.get("role", "user"),
                    created_at=profile.get("created_at"),
                    is_active=profile.get("is_active", True),
                )
        
        return await get_current_profile(user_id, user_email, _)
        
    except Exception as e:
        logger.error(f"Error updating profile: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to update profile"
        )


@router.get(
    "/validate",
    response_model=TokenValidationResponse,
    summary="Validate JWT token",
    description="Check if the current JWT token is valid",
)
async def validate_token(
    user: OptionalUser,
) -> TokenValidationResponse:
    """
    Validate JWT token.
    
    Returns token validity and user info.
    """
    if user is None:
        return TokenValidationResponse(
            valid=False,
            user=None,
            expires_at=None,
        )
    
    return TokenValidationResponse(
        valid=True,
        user=user,
        expires_at=user.exp,
    )


@router.delete(
    "/me",
    response_model=dict[str, str],
    responses={
        401: {"model": ErrorResponse, "description": "Unauthorized"},
    },
    summary="Delete user account",
    description="Permanently delete user account and all data",
)
async def delete_account(
    user_id: CurrentUserId,
    _: ValidatedUser,
) -> dict[str, str]:
    """
    Delete user account.
    
    Permanently removes user and all associated data.
    """
    try:
        from app.services.supabase_db import get_supabase_client
        
        client = await get_supabase_client()
        
        await client.table("users").delete().eq("id", user_id).execute()
        
        await client.auth.admin.delete_user(user_id)
        
        logger.info(f"User account deleted: {user_id}")
        
        return {"message": "Account deleted successfully"}
        
    except Exception as e:
        logger.error(f"Error deleting account: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to delete account"
        )
