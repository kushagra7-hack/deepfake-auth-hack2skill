"""
Admin APIs for Deepfake Authentication Gateway.
Provides platform statistics and user management capabilities for administrators.
"""

import logging
from typing import Annotated, Any

from fastapi import APIRouter, HTTPException, status
from pydantic import BaseModel, Field

from app.api.dependencies import AdminUser
from app.services.supabase_db import get_supabase_client
from app.models.schemas import UserRole

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/admin", tags=["admin"])


class RoleUpdateRequest(BaseModel):
    role: UserRole = Field(..., description="New role for the user")


class AdminStatsResponse(BaseModel):
    total_users: int = Field(..., description="Total number of registered users")
    total_scans: int = Field(..., description="Total number of scans performed")
    active_users: int = Field(..., description="Number of active users")


@router.get(
    "/stats",
    response_model=AdminStatsResponse,
    summary="Get platform statistics",
    description="Retrieve overall platform statistics (Admin only)",
)
async def get_admin_stats(_: AdminUser) -> AdminStatsResponse:
    try:
        client = await get_supabase_client()
        
        # Get users count
        users_result = await client.table("users").select("id", count=CountMethod.exact).execute()
        total_users = users_result.count if users_result.count is not None else 0
        
        active_users_result = await client.table("users").select("id", count=CountMethod.exact).eq("is_active", True).execute()
        active_users = active_users_result.count if active_users_result.count is not None else 0
        
        # Get scans count
        scans_result = await client.table("scans").select("id", count=CountMethod.exact).execute()
        total_scans = scans_result.count if scans_result.count is not None else 0
        
        return AdminStatsResponse(
            total_users=total_users,
            total_scans=total_scans,
            active_users=active_users
        )
        
    except Exception as e:
        logger.error(f"Error fetching admin stats: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to retrieve platform statistics"
        )


@router.get(
    "/users",
    summary="List all users",
    description="Retrieve a list of all users and their roles (Admin only)",
)
async def list_users(_: AdminUser) -> list[dict[str, Any]]:
    try:
        client = await get_supabase_client()
        
        # Use service role to fetch all users
        result = await client.table("users").select(
            "id, email, full_name, role, created_at, is_active"
        ).order("created_at", desc=True).execute()
        
        return result.data or []
        
    except Exception as e:
        logger.error(f"Error fetching all users: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to retrieve users list"
        )


@router.patch(
    "/users/{user_id}/role",
    summary="Update user role",
    description="Change the role of a specific user (Admin only)",
)
async def update_user_role(
    user_id: str,
    update_data: RoleUpdateRequest,
    _: AdminUser
) -> dict[str, str]:
    try:
        client = await get_supabase_client()
        
        # Update role in public.users table
        result = await client.table("users").update(
            {"role": update_data.role.value}
        ).eq("id", user_id).execute()
        
        if not result.data:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"User {user_id} not found"
            )
            
        # Also attempt to update role in Supabase auth metadata if needed
        try:
            await client.auth.admin.update_user_by_id(
                user_id,
                {"user_metadata": {"role": update_data.role.value}}
            )
        except Exception as auth_err:
            logger.warning(f"Failed to update auth metadata for {user_id}: {auth_err}")
            
        logger.info(f"Admin updated role for user {user_id} to {update_data.role.value}")
        
        return {"message": f"User role successfully updated to {update_data.role.value}"}
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error updating user role: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to update user role"
        )
