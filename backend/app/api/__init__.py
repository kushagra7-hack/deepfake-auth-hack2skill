"""
API package initialization.
"""

from app.api.dependencies import (
    AdminUser,
    AuthenticationError,
    CurrentUserEmail,
    CurrentUserId,
    OptionalUser,
    ValidatedUser,
    get_current_user_email,
    get_current_user_id,
    rate_limiter,
    require_admin_role,
    verify_supabase_jwt,
    verify_supabase_jwt_optional,
)

__all__ = [
    "AdminUser",
    "AuthenticationError",
    "CurrentUserEmail",
    "CurrentUserId",
    "OptionalUser",
    "ValidatedUser",
    "get_current_user_email",
    "get_current_user_id",
    "rate_limiter",
    "require_admin_role",
    "verify_supabase_jwt",
    "verify_supabase_jwt_optional",
]
