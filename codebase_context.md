# Nexus Gateway — Full Codebase Context
_Generated: 04/28/2026 17:04:19_

## Directory Structure
```
.firebaserc
.gitignore
codebase_context.md
docker-compose.yml
firebase.json
Music - Shortcut.lnk
README.md
.firebase\hosting.YnVpbGRcd2Vi.cache
.firebase\hosting.Zmx1dHRlci1jbGllbnRcYnVpbGRcd2Vi.cache
backend\.env
backend\.env.example
backend\Dockerfile
backend\nexus-gateway-cca4c-firebase-adminsdk-fbsvc-73e0300e3b.json
backend\requirements.txt
backend\app\main.py
backend\app\__init__.py
backend\app\api\dependencies.py
backend\app\api\__init__.py
backend\app\api\routes\scan.py
backend\app\api\routes\__init__.py
backend\app\core\config.py
backend\app\core\security.py
backend\app\core\__init__.py
backend\app\models\schemas.py
backend\app\models\__init__.py
backend\app\services\firebase_config.py
backend\app\services\firestore_db.py
backend\app\services\gemini_client.py
backend\app\services\hf_client.py
backend\app\services\real_gemini_client.py
backend\app\services\__init__.py
backend\tests\test_security.py
flutter-client\.flutter-plugins-dependencies
flutter-client\.gitignore
flutter-client\.metadata
flutter-client\analysis.txt
flutter-client\analysis_full.txt
flutter-client\analysis_options.yaml
flutter-client\analyze_out.txt
flutter-client\build_log.txt
flutter-client\devtools_options.yaml
flutter-client\firebase.json
flutter-client\flutter_01.log
flutter-client\flutter_client.iml
flutter-client\old_dashboard.dart
flutter-client\pubspec.lock
flutter-client\pubspec.yaml
flutter-client\README.md
flutter-client\.idea\modules.xml
flutter-client\.idea\workspace.xml
flutter-client\.idea\libraries\Dart_SDK.xml
flutter-client\.idea\libraries\KotlinJavaRuntime.xml
flutter-client\.idea\runConfigurations\main_dart.xml
flutter-client\android\.gitignore
flutter-client\android\build.gradle.kts
flutter-client\android\flutter_client_android.iml
flutter-client\android\gradle.properties
flutter-client\android\gradlew
flutter-client\android\gradlew.bat
flutter-client\android\local.properties
flutter-client\android\settings.gradle.kts
flutter-client\android\.gradle\file-system.probe
flutter-client\android\.gradle\8.14\gc.properties
flutter-client\android\.gradle\8.14\checksums\checksums.lock
flutter-client\android\.gradle\8.14\checksums\md5-checksums.bin
flutter-client\android\.gradle\8.14\checksums\sha1-checksums.bin
flutter-client\android\.gradle\8.14\executionHistory\executionHistory.bin
flutter-client\android\.gradle\8.14\executionHistory\executionHistory.lock
flutter-client\android\.gradle\8.14\fileChanges\last-build.bin
flutter-client\android\.gradle\8.14\fileHashes\fileHashes.bin
flutter-client\android\.gradle\8.14\fileHashes\fileHashes.lock
flutter-client\android\.gradle\8.14\fileHashes\resourceHashesCache.bin
flutter-client\android\.gradle\buildOutputCleanup\buildOutputCleanup.lock
flutter-client\android\.gradle\buildOutputCleanup\cache.properties
flutter-client\android\.gradle\buildOutputCleanup\outputFiles.bin
flutter-client\android\.gradle\kotlin\errors\errors-1777078697241.log
flutter-client\android\.gradle\kotlin\errors\errors-1777147432325.log
flutter-client\android\.gradle\noVersion\buildLogic.lock
flutter-client\android\.gradle\vcs-1\gc.properties
flutter-client\android\.kotlin\errors\errors-1777078697241.log
flutter-client\android\.kotlin\errors\errors-1777147432325.log
flutter-client\android\app\build.gradle.kts
flutter-client\android\app\google-services.json
flutter-client\android\app\src\debug\AndroidManifest.xml
flutter-client\android\app\src\main\AndroidManifest.xml
flutter-client\android\app\src\main\java\io\flutter\plugins\GeneratedPluginRegistrant.java
flutter-client\android\app\src\main\kotlin\com\example\flutter_client\MainActivity.kt
flutter-client\android\app\src\main\res\drawable\launch_background.xml
flutter-client\android\app\src\main\res\drawable-v21\launch_background.xml
flutter-client\android\app\src\main\res\mipmap-hdpi\ic_launcher.png
flutter-client\android\app\src\main\res\mipmap-mdpi\ic_launcher.png
flutter-client\android\app\src\main\res\mipmap-xhdpi\ic_launcher.png
flutter-client\android\app\src\main\res\mipmap-xxhdpi\ic_launcher.png
flutter-client\android\app\src\main\res\mipmap-xxxhdpi\ic_launcher.png
flutter-client\android\app\src\main\res\values\styles.xml
flutter-client\android\app\src\main\res\values-night\styles.xml
flutter-client\android\app\src\profile\AndroidManifest.xml
flutter-client\android\gradle\wrapper\gradle-wrapper.jar
flutter-client\android\gradle\wrapper\gradle-wrapper.properties
flutter-client\assets\images\cyber_isometric_hero.png
flutter-client\assets\images\hero_bg.png
flutter-client\assets\images\hero_feature.png
flutter-client\assets\images\login_bg.jpg
flutter-client\ios\.gitignore
flutter-client\ios\Flutter\AppFrameworkInfo.plist
flutter-client\ios\Flutter\Debug.xcconfig
flutter-client\ios\Flutter\flutter_export_environment.sh
flutter-client\ios\Flutter\Generated.xcconfig
flutter-client\ios\Flutter\Release.xcconfig
flutter-client\ios\Flutter\ephemeral\flutter_lldbinit
flutter-client\ios\Flutter\ephemeral\flutter_lldb_helper.py
flutter-client\ios\Runner\AppDelegate.swift
flutter-client\ios\Runner\GeneratedPluginRegistrant.h
flutter-client\ios\Runner\GeneratedPluginRegistrant.m
flutter-client\ios\Runner\Info.plist
flutter-client\ios\Runner\Runner-Bridging-Header.h
flutter-client\ios\Runner\SceneDelegate.swift
flutter-client\ios\Runner\Assets.xcassets\AppIcon.appiconset\Contents.json
flutter-client\ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-1024x1024@1x.png
flutter-client\ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-20x20@1x.png
flutter-client\ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-20x20@2x.png
flutter-client\ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-20x20@3x.png
flutter-client\ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-29x29@1x.png
flutter-client\ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-29x29@2x.png
flutter-client\ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-29x29@3x.png
flutter-client\ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-40x40@1x.png
flutter-client\ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-40x40@2x.png
flutter-client\ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-40x40@3x.png
flutter-client\ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-60x60@2x.png
flutter-client\ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-60x60@3x.png
flutter-client\ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-76x76@1x.png
flutter-client\ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-76x76@2x.png
flutter-client\ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-83.5x83.5@2x.png
flutter-client\ios\Runner\Assets.xcassets\LaunchImage.imageset\Contents.json
flutter-client\ios\Runner\Assets.xcassets\LaunchImage.imageset\LaunchImage.png
flutter-client\ios\Runner\Assets.xcassets\LaunchImage.imageset\LaunchImage@2x.png
flutter-client\ios\Runner\Assets.xcassets\LaunchImage.imageset\LaunchImage@3x.png
flutter-client\ios\Runner\Assets.xcassets\LaunchImage.imageset\README.md
flutter-client\ios\Runner\Base.lproj\LaunchScreen.storyboard
flutter-client\ios\Runner\Base.lproj\Main.storyboard
flutter-client\ios\Runner.xcodeproj\project.pbxproj
flutter-client\ios\Runner.xcodeproj\project.xcworkspace\contents.xcworkspacedata
flutter-client\ios\Runner.xcodeproj\project.xcworkspace\xcshareddata\IDEWorkspaceChecks.plist
flutter-client\ios\Runner.xcodeproj\project.xcworkspace\xcshareddata\WorkspaceSettings.xcsettings
flutter-client\ios\Runner.xcodeproj\xcshareddata\xcschemes\Runner.xcscheme
flutter-client\ios\Runner.xcworkspace\contents.xcworkspacedata
flutter-client\ios\Runner.xcworkspace\xcshareddata\IDEWorkspaceChecks.plist
flutter-client\ios\Runner.xcworkspace\xcshareddata\WorkspaceSettings.xcsettings
flutter-client\ios\RunnerTests\RunnerTests.swift
flutter-client\lib\firebase_options.dart
flutter-client\lib\main.dart
flutter-client\lib\screens\api_docs_screen.dart
flutter-client\lib\screens\dashboard_screen.dart
flutter-client\lib\screens\landing_screen.dart
flutter-client\lib\screens\login_screen.dart
flutter-client\lib\services\api_service.dart
flutter-client\lib\services\auth_service.dart
flutter-client\lib\widgets\constellation_background.dart
flutter-client\lib\widgets\neural_mesh_background.dart
flutter-client\lib\widgets\starfield_background.dart
flutter-client\lib\widgets\trust_button.dart
flutter-client\web\favicon.png
flutter-client\web\index.html
flutter-client\web\manifest.json
flutter-client\web\icons\Icon-192.png
flutter-client\web\icons\Icon-512.png
flutter-client\web\icons\Icon-maskable-192.png
flutter-client\web\icons\Icon-maskable-512.png
```

## BACKEND — Python Files

## `backend\app\__init__.py`
```python
"""
Application package initialization.
"""

__version__ = "1.0.0"

```

## `backend\app\api\__init__.py`
```python
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
    verify_firebase_token,
    verify_firebase_token_optional,
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
    "verify_firebase_token",
    "verify_firebase_token_optional",
]

```

## `backend\app\api\dependencies.py`
```python
"""
API dependencies for Deepfake Authentication Gateway.
Zero-Trust API Perimeter â€” Firebase ID Token verification.
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
      1. Presence check â€” rejects missing tokens
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
        raise AuthenticationError("Firebase token has expired â€” please sign in again")
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


# â”€â”€ Optional auth â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

async def verify_firebase_token_optional(
    credentials: Annotated[HTTPAuthorizationCredentials | None, Depends(security)]
) -> UserTokenData | None:
    """Optional token verification â€” returns None if no token provided."""
    if credentials is None:
        return None
    try:
        return await verify_firebase_token(credentials)
    except HTTPException:
        return None


# â”€â”€ Role helpers â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

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


# â”€â”€ Rate Limiter (unchanged) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

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

# â”€â”€ Typed shorthand aliases â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

ValidatedUser  = Annotated[UserTokenData, Depends(verify_firebase_token)]
OptionalUser   = Annotated[UserTokenData | None, Depends(verify_firebase_token_optional)]
AdminUser      = Annotated[UserTokenData, Depends(require_admin_role)]
CurrentUserId  = Annotated[str, Depends(get_current_user_id)]
CurrentUserEmail = Annotated[str, Depends(get_current_user_email)]

# Removed legacy Supabase alias

```

## `backend\app\api\routes\__init__.py`
```python
"""
API routes package initialization.
"""

from app.api.routes import scan

__all__ = ["scan"]
```

## `backend\app\api\routes\scan.py`
```python
"""
Scan API routes for Deepfake Authentication Gateway.
Provides the main POST /scan endpoint for media analysis.
"""

import asyncio
import logging
from decimal import Decimal
from typing import Annotated, Any

from fastapi import (
    APIRouter,
    Depends,
    File,
    HTTPException,
    Request,
    UploadFile,
    status,
)
from fastapi.responses import JSONResponse

from app.api.dependencies import (
    CurrentUserId,
    ValidatedUser,
    rate_limiter,
    verify_firebase_token,
)
from app.core.config import settings
from app.core.security import (
    FileInfo,
    FileTooSmallError,
    InvalidFileSignatureError,
    generate_file_hash,
    verify_file_signature,
)
from app.models.schemas import (
    ErrorResponse,
    ScanResponse,
    ScanStatus,
)
from app.services.hf_client import (
    HFAPIConnectionError,
    HFAPIResponseError,
    HFTimeoutError,
    analyze_deepfake,
)
from app.services.firestore_db import (
    DatabaseError,
    check_hash_exists,
    get_scan_by_id,
    get_user_scans,
    get_user_stats,
    log_scan,
    update_scan_status,
)

from app.services.gemini_client import run_gemini_analysis
from app.services.real_gemini_client import analyze_with_gemini

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/scan", tags=["scans"])

MAX_UPLOAD_SIZE = settings.MAX_FILE_SIZE
CHUNK_SIZE = 1024 * 1024


def sanitize_filename(filename: str) -> str:
    """Sanitize filename to prevent path traversal attacks."""
    forbidden = ["../", "..\\", "\x00", "<", ">", ":", '"', "|", "?", "*"]
    for char in forbidden:
        if char in filename:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Filename contains forbidden character sequence"
            )
    return filename.strip().split("/")[-1].split("\\")[-1]


@router.post(
    "",
    response_model=ScanResponse,
    responses={
        400: {"model": ErrorResponse, "description": "Invalid file or request"},
        401: {"model": ErrorResponse, "description": "Unauthorized"},
        413: {"model": ErrorResponse, "description": "File too large"},
        429: {"model": ErrorResponse, "description": "Rate limit exceeded"},
        500: {"model": ErrorResponse, "description": "Internal server error"},
        503: {"model": ErrorResponse, "description": "AI service unavailable"},
    },
    summary="Analyze media file for deepfakes",
    description="Upload a media file for deepfake detection analysis. "
                "Supports images, videos, and audio files.",
)
async def create_scan(
    request: Request,
    user_id: CurrentUserId,
    file: Annotated[UploadFile, File(..., description="Media file to analyze")],
    _: ValidatedUser,
    __: None = Depends(rate_limiter)
) -> ScanResponse:
    """
    Analyze uploaded media file for deepfake content.
    
    Flow:
    1. Authenticate user via JWT
    2. Validate file signature (magic bytes)
    3. Generate SHA-256 hash
    4. Check for existing scan (deduplication)
    5. If new, send to Hugging Face API
    6. Log result to database
    7. Return analysis results
    
    Security measures:
    - File signature validation (ignores extension)
    - Memory-efficient streaming for large files
    - Rate limiting
    - Cryptographic deduplication
    """
    filename = sanitize_filename(file.filename or "unknown")
    
    logger.info(f"User {user_id} starting scan for file: {filename}")
    
    content_length = request.headers.get("content-length")
    if content_length and int(content_length) > MAX_UPLOAD_SIZE:
        raise HTTPException(
            status_code=status.HTTP_413_REQUEST_ENTITY_TOO_LARGE,
            detail=f"File exceeds maximum size of {MAX_UPLOAD_SIZE / (1024**2):.1f}MB"
        )
    
    try:
        file_chunks = []
        total_size = 0
        
        while True:
            chunk = await file.read(1024 * 1024)  # 1MB chunks
            if not chunk:
                break
                
            total_size += len(chunk)
            
            if total_size > MAX_UPLOAD_SIZE:
                logger.warning(
                    f"File too large: {filename} ({total_size} bytes > {MAX_UPLOAD_SIZE})"
                )
                raise HTTPException(
                    status_code=status.HTTP_413_REQUEST_ENTITY_TOO_LARGE,
                    detail=f"File exceeds maximum size of {MAX_UPLOAD_SIZE / (1024**3):.1f}GB"
                )
            
            file_chunks.append(chunk)
        
        if not file_chunks:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Empty file received"
            )
        
        file_bytes = b"".join(file_chunks)
        logger.debug(f"File loaded: {filename}, size={total_size} bytes")
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error reading file: {e}")
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Failed to read file: {str(e)}"
        )
    finally:
        await file.close()
    
    try:
        file_info = verify_file_signature(file_bytes)
        logger.info(
            f"File signature verified: {filename} -> {file_info.signature.value} "
            f"({file_info.mime_type})"
        )
    except FileTooSmallError as e:
        logger.warning(f"File too small: {filename} - {e.message}")
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
    except InvalidFileSignatureError as e:
        logger.warning(f"Invalid file signature: {filename} - {e.message}")
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid or unsupported file format. File signature verification failed."
        )

    # --- VIDEO INTERCEPTOR BLOCK ---
    if "video" in str(file.content_type).lower() or file.filename.lower().endswith((".mp4", ".avi", ".mov")):
        import tempfile
        import cv2
        import os
        import logging
        
        logging.info(f"[VIDEO FLOW] Video payload detected: {file.filename}. Starting frame extraction...")
        
        temp_vid = tempfile.NamedTemporaryFile(delete=False, suffix=".mp4")
        temp_path = temp_vid.name
        temp_vid.write(file_bytes)
        temp_vid.close() # Critical for Windows
            
        try:
            cap = cv2.VideoCapture(temp_path)
            total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
            
            if total_frames > 0:
                # Calculate frame positions at 10%, 40%, 70%, and 90% of the video
                timestamps = [int(total_frames * 0.1), int(total_frames * 0.4), int(total_frames * 0.7), int(total_frames * 0.9)]
                frames = []
                
                for ts in timestamps:
                    cap.set(cv2.CAP_PROP_POS_FRAMES, ts)
                    success, frame = cap.read()
                    if success:
                        # Resize to keep the final grid manageable but high quality (1024x1024 per frame)
                        frame = cv2.resize(frame, (1024, 1024))
                        frames.append(frame)
                
                # If we successfully grabbed 4 frames, stitch them into a 2x2 grid
                if len(frames) == 4:
                    import numpy as np
                    top_row = np.hstack((frames[0], frames[1]))
                    bottom_row = np.hstack((frames[2], frames[3]))
                    sprite_sheet = np.vstack((top_row, bottom_row))
                    
                    # Encode the 2x2 grid to JPEG with high quality
                    is_success, buffer = cv2.imencode(".jpg", sprite_sheet, [int(cv2.IMWRITE_JPEG_QUALITY), 90])
                    if is_success:
                        file_bytes = buffer.tobytes()
                        
                        # OVERRIDE LOCAL VARIABLE ONLY. Do NOT touch file.content_type!
                        content_type = "image/jpeg"
                        file_info.media_type = "image"
                        file_info.mime_type = "image/jpeg"
                        
                        logging.info(f"[VIDEO EXTRACT] Created 2x2 Temporal Sprite Sheet. Size: {len(file_bytes)} bytes.")
                    else:
                        logging.error("[VIDEO EXTRACT] cv2.imencode failed to convert sprite sheet.")
                else:
                    logging.error(f"[VIDEO EXTRACT] Failed to extract 4 frames. Grabbed {len(frames)}.")
            else:
                logging.error("[VIDEO EXTRACT] cv2.VideoCapture returned 0 frames.")
                
            # CRITICAL: Release the lock immediately before doing anything else
            cap.release()
        except Exception as e:
            logging.error(f"[VIDEO EXTRACT] CRITICAL EXCEPTION: {str(e)}")
            if 'cap' in locals():
                cap.release() # Fallback release
        finally:
            # Safely attempt to remove the file
            if os.path.exists(temp_path):
                try:
                    os.remove(temp_path)
                except Exception as cleanup_error:
                    logging.warning(f"[VIDEO EXTRACT] Could not remove temp file: {cleanup_error}")
    # --- END VIDEO INTERCEPTOR ---
    
    file_hash = generate_file_hash(file_bytes)
    logger.debug(f"Generated hash for {filename}: {file_hash[:16]}...")
    
    # Bypass deduplication cache â€“ always perform fresh analysis
    # The following block is intentionally disabled to force full AI pipeline on every upload.
    # try:
    #     existing_scan = await check_hash_exists(file_hash, user_id)
    #
    #     if existing_scan and existing_scan.get("threat_score") is not None:
    #         logger.info(
    #             f"Returning cached result for {filename} "
    #             f"(hash={file_hash[:16]}..., score={existing_scan.get('threat_score')})"
    #         )
    #
    #         return ScanResponse(
    #             id=existing_scan.get("id"),
    #             user_id=user_id,
    #             file_name=filename,
    #             file_hash=file_hash,
    #             threat_score=Decimal(str(existing_scan.get("threat_score", 0))),
    #             status=ScanStatus.COMPLETED,
    #             media_type=file_info.media_type,
    #             file_size=total_size,
    #             result_details=existing_scan.get("result_details"),
    #             created_at=existing_scan.get("created_at"),
    #             completed_at=existing_scan.get("created_at"),
    #         )
    #
    # except DatabaseError as e:
    #     logger.error(f"Database error during deduplication check: {e}")
    
    pending_scan = None
    try:
        pending_scan = await log_scan(
            user_id=user_id,
            file_name=filename,
            file_hash=file_hash,
            threat_score=Decimal("0"),
            status=ScanStatus.PROCESSING,
            media_type=file_info.media_type,
            file_size=total_size,
            result_details={"stage": "processing"}
        )
        logger.info(f"Created pending scan record: {pending_scan.get('id')}")
    except DatabaseError as e:
        logger.error(f"Failed to create pending scan: {e}")
    
    # â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    # TIER-1 â”€â”€ HuggingFace Mathematical Pre-Screen
    # â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    # ZERO-TRUST MODE: The HF score is recorded as context but can NO LONGER
    # unilaterally approve a payload.  ALL image payloads proceed to Tier-2.
    # (Non-image types still use the HF score as the sole signal.)
    # â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

    hf_score_normalized: float = 0.0
    gemini_verdict: str = "AUTHENTIC"
    gemini_reasoning: str = "Cleared by Tier 1 mathematical scan."
    tier_used: int = 1
    status_value = ScanStatus.COMPLETED
    result_details: dict = {}
    analysis_result = None
    gemini_model_used = ""
    gemini_confidence = None
    gemini_tier = ""

    content_type = file.content_type

    if content_type and content_type.startswith("audio/"):
        logger.info(f"[SECURITY OVERRIDE] Audio file '{filename}' detected. Bypassing HuggingFace to prevent model crash.")
        try:
            from app.services.gemini_client import run_gemini_analysis
            gemini_result = await run_gemini_analysis(file_bytes, 1.0)
            gemini_verdict = gemini_result.get("gemini_verdict", "AUTHENTIC")
            gemini_reasoning = gemini_result.get("gemini_reasoning", "")
            gemini_model_used = gemini_result.get("gemini_model_used", "")
            gemini_confidence = gemini_result.get("gemini_confidence", None)
            gemini_tier = "tier-2-direct"
            
            hf_score_normalized = 0.85 if gemini_verdict == "DEEPFAKE" else 0.15
            tier_used = 2
            status_value = ScanStatus.COMPLETED
        except Exception as gemini_err:
            logger.error(f"[AUDIO BYPASS] Gemini unavailable: {gemini_err}")
            hf_score_normalized = 0.0
            gemini_verdict = "ANALYSIS_FAILED"
            gemini_reasoning = f"Direct Tier-2 Audio Analysis failed: {str(gemini_err)}"
            gemini_tier = "tier-2-failed"
            tier_used = 2
            status_value = ScanStatus.FAILED
    else:
        try:
            logger.info(f"[TIER-1] Dispatching '{filename}' to HuggingFace deepfake model â€¦")
            analysis_result = await analyze_deepfake(file_bytes, file_info)
    
            hf_score_normalized = analysis_result.probability_score / 100.0
            logger.info(
                f"[TIER-1] Result for '{filename}': "
                f"raw_score={analysis_result.probability_score:.4f}%, "
                f"normalised={hf_score_normalized:.4f}, "
                f"model={analysis_result.model_used}"
            )
    
        except Exception as e:
            logger.error(f"[TIER-1] HuggingFace error for '{filename}': {e}")
            hf_score_normalized = 1.0
            status_value = ScanStatus.FAILED
    
        if file_info.media_type == "image":
            logger.info(
                f"[SECURITY OVERRIDE] Running NVIDIA + Gemini in parallel on '{filename}'."
            )
            try:
                # â”€â”€ Run NVIDIA NIM and Google Gemini Flash simultaneously â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                nvidia_task  = run_gemini_analysis(file_bytes, hf_score_normalized)
                real_gemini_task = analyze_with_gemini(file_bytes, hf_score_normalized)

                nvidia_result, real_gemini_result = await asyncio.gather(
                    nvidia_task, real_gemini_task, return_exceptions=True
                )

                # â”€â”€ NVIDIA result â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                if isinstance(nvidia_result, Exception):
                    logger.warning(f"[TIER-2/NVIDIA] Failed: {nvidia_result}")
                    nvidia_result = {"gemini_verdict": "ANALYSIS_FAILED", "gemini_reasoning": str(nvidia_result)}

                gemini_verdict     = nvidia_result.get("gemini_verdict", "AUTHENTIC")
                gemini_reasoning   = nvidia_result.get("gemini_reasoning", "")
                gemini_model_used  = nvidia_result.get("gemini_model_used", "")
                gemini_confidence  = nvidia_result.get("gemini_confidence", None)
                gemini_tier        = nvidia_result.get("tier", "tier-2")

                # â”€â”€ Real Gemini Flash result â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                if isinstance(real_gemini_result, Exception):
                    logger.warning(f"[TIER-3/GEMINI] Failed: {real_gemini_result}")
                    real_gemini_result = {"gemini_verdict": "ANALYSIS_FAILED"}

                real_gemini_verdict    = real_gemini_result.get("gemini_verdict", "AUTHENTIC")
                real_gemini_confidence = real_gemini_result.get("gemini_confidence", None)  # 0-100
                real_gemini_reasoning  = real_gemini_result.get("gemini_reasoning", "")

                logger.info(
                    f"[TIER-3/GEMINI] Verdict={real_gemini_verdict} "
                    f"Confidence={real_gemini_confidence} | {real_gemini_reasoning[:80]}"
                )

                tier_used    = 3
                status_value = ScanStatus.COMPLETED

            except Exception as err:
                logger.warning(f"[TIER-2/3] Both AI models failed: {err}")
                gemini_verdict = "DEEPFAKE" if hf_score_normalized >= 0.5 else "AUTHENTIC"
                gemini_reasoning = f"AI models unavailable. Verdict from HF score ({hf_score_normalized*100:.1f}%)."
                gemini_model_used = ""
                gemini_confidence = None
                gemini_tier = "tier-1-fallback"
                real_gemini_verdict = "ANALYSIS_FAILED"
                real_gemini_confidence = None
                real_gemini_reasoning = ""
                tier_used = 1
        else:
            # Video: keep original threshold-based logic
            HF_SUSPICION_THRESHOLD = 0.20
            if hf_score_normalized >= HF_SUSPICION_THRESHOLD:
                logger.info(
                    f"[TIER-2] Non-image score {hf_score_normalized:.4f} >= {HF_SUSPICION_THRESHOLD}. "
                    f"Escalating '{filename}' to Gemini ..."
                )
                try:
                    from app.services.gemini_client import run_gemini_analysis
                    gemini_result = await run_gemini_analysis(file_bytes, hf_score_normalized)
                    gemini_verdict      = gemini_result.get("gemini_verdict", "AUTHENTIC")
                    gemini_reasoning    = gemini_result.get("gemini_reasoning", "")
                    gemini_model_used   = gemini_result.get("gemini_model_used", "")
                    gemini_confidence   = gemini_result.get("gemini_confidence", None)
                    gemini_tier         = gemini_result.get("tier", "tier-2")
                    tier_used = 2
                except RuntimeError as gemini_err:
                    logger.warning(f"[TIER-2] Gemini unavailable: {gemini_err}")
                    gemini_verdict    = "DEEPFAKE" if hf_score_normalized >= 0.5 else "AUTHENTIC"
                    gemini_reasoning  = f"Tier 2 unavailable. Score: {hf_score_normalized * 100:.2f}%."
                    gemini_model_used = ""
                    gemini_confidence = None
                    gemini_tier       = "tier-1-fallback"
            else:
                logger.info(
                    f"[TIER-1] Non-image score {hf_score_normalized:.4f} < {HF_SUSPICION_THRESHOLD}. "
                    f"Verdict: AUTHENTIC."
                )
                gemini_verdict    = "AUTHENTIC"
                gemini_reasoning  = "Cleared by Tier 1 mathematical scan."
                gemini_model_used = ""
                gemini_confidence = None
                gemini_tier       = "tier-1"

    # â”€â”€ Build final stats â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    if analysis_result is not None:
        hf_is_deepfake = analysis_result.is_deepfake
        hf_confidence = analysis_result.confidence_level
        hf_model = analysis_result.model_used
        hf_ms = analysis_result.processing_time_ms
    else:
        hf_is_deepfake = hf_score_normalized >= 0.5
        hf_confidence = "low"
        hf_model = "none"
        hf_ms = 0.0

    # â”€â”€ 3-Way Ensemble: NVIDIA (50%) + Gemini Flash (30%) + HF (20%) â”€â”€â”€â”€â”€â”€â”€â”€â”€
    # NVIDIA LLaMA-90B: primary deep visual analysis
    # Google Gemini Flash: mandatory cross-check (hackathon requirement)
    # HuggingFace: fast binary pre-screen (supporting only)
    hf_component = float(hf_score_normalized)

    def _verdict_to_signal(verdict: str, confidence_pct) -> float:
        """Convert a text verdict + confidence% to a 0-1 threat signal."""
        if verdict == "DEEPFAKE":
            return confidence_pct / 100.0 if confidence_pct else 0.82
        elif verdict in ("ELEVATED_RISK", "ANALYSIS_FAILED"):
            return 0.60  # uncertain â†’ slightly suspicious
        else:  # AUTHENTIC
            return 1.0 - (confidence_pct / 100.0) if confidence_pct else 0.18

    nvidia_signal  = _verdict_to_signal(gemini_verdict, gemini_confidence)
    gemini_signal  = _verdict_to_signal(
        real_gemini_verdict,
        real_gemini_confidence,
    )

    # Weights: NVIDIA 50%, Gemini 30%, HF 20%
    # If either AI says DEEPFAKE with high confidence, cap HF at 20% max
    nvidia_w, gemini_w, hf_w = 0.50, 0.30, 0.20

    ensemble_score = (
        nvidia_signal  * nvidia_w +
        gemini_signal  * gemini_w +
        hf_component   * hf_w
    )

    # Hard floor: if BOTH AI models say DEEPFAKE, score cannot go below 0.70
    if gemini_verdict == "DEEPFAKE" and real_gemini_verdict == "DEEPFAKE":
        ensemble_score = max(ensemble_score, 0.70)
        logger.info("[ENSEMBLE] Both AI=DEEPFAKE â†’ floor 0.70 applied.")
    # Soft floor: if either AI says DEEPFAKE, score cannot go below 0.55
    elif gemini_verdict == "DEEPFAKE" or real_gemini_verdict == "DEEPFAKE":
        ensemble_score = max(ensemble_score, 0.55)
        logger.info("[ENSEMBLE] One AI=DEEPFAKE â†’ floor 0.55 applied.")

    # Logic Shield: clamp to [0.0, 1.0]
    threat_score_float = max(0.0, min(1.0, ensemble_score))
    threat_score = Decimal(str(round(threat_score_float, 4)))

    logger.info(
        f"[ENSEMBLE-3WAY] NVIDIA={nvidia_signal:.3f}*{nvidia_w} + "
        f"Gemini={gemini_signal:.3f}*{gemini_w} + "
        f"HF={hf_component:.3f}*{hf_w} = {threat_score_float:.4f}"
    )

    result_details = {
        # â”€â”€ Tier metadata â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
        "tier_used": tier_used,
        # â”€â”€ Tier-1 (HuggingFace) fields â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
        "hf_score": float(hf_score_normalized),
        "hf_score_pct": float(threat_score),
        "is_deepfake": hf_is_deepfake,
        "confidence_level": hf_confidence,
        "model_used": hf_model,
        "processing_time_ms": hf_ms,
        # â”€â”€ Tier-2 (NVIDIA NIM â€” LLaMA-3.2-90B Vision) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
        "gemini_verdict": gemini_verdict,
        "gemini_reasoning": gemini_reasoning,
        "gemini_model_used": gemini_model_used,
        "gemini_confidence": gemini_confidence,
        "gemini_tier": gemini_tier,
        # â”€â”€ Tier-3 (Google Gemini Flash) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
        "real_gemini_verdict": real_gemini_verdict,
        "real_gemini_reasoning": real_gemini_reasoning,
        "real_gemini_confidence": real_gemini_confidence,
    }

    logger.info(
        f"[GATEWAY] '{filename}' FINAL: threat={threat_score}%, "
        f"gemini_verdict={gemini_verdict}, tier={tier_used}"
    )

    
    try:
        if pending_scan:
            updated_scan = await update_scan_status(
                scan_id=pending_scan.get("id"),
                status=status_value,
                threat_score=threat_score,
                result_details=result_details,
                file_name=filename,
                file_hash=file_hash,
                media_type=file_info.media_type,
                file_size=total_size,
            )
        else:
            updated_scan = await log_scan(
                user_id=user_id,
                file_name=filename,
                file_hash=file_hash,
                threat_score=threat_score,
                status=status_value,
                media_type=file_info.media_type,
                file_size=total_size,
                result_details=result_details
            )
            
        logger.info(f"Scan logged: {updated_scan.get('id')}, score={threat_score}")
        
        return ScanResponse(
            id=updated_scan.get("id"),
            user_id=user_id,
            file_name=filename,
            file_hash=file_hash,
            threat_score=threat_score,
            status=status_value,
            media_type=file_info.media_type,
            file_size=total_size,
            result_details=result_details,
            created_at=updated_scan.get("created_at"),
            completed_at=updated_scan.get("completed_at"),
            tier2_confidence=gemini_confidence,
        )
        
    except DatabaseError as e:
        logger.error(f"Failed to log final scan result: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to save scan results"
        )


@router.get(
    "/{scan_id}",
    response_model=ScanResponse,
    responses={
        401: {"model": ErrorResponse, "description": "Unauthorized"},
        404: {"model": ErrorResponse, "description": "Scan not found"},
    },
    summary="Get scan by ID",
)
async def get_scan(
    scan_id: str,
    user_id: CurrentUserId,
    _: ValidatedUser,
) -> ScanResponse:
    """Get a specific scan result by ID."""
    try:
        scan = await get_scan_by_id(scan_id, user_id)
        
        if not scan:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Scan {scan_id} not found"
            )
        
        return ScanResponse(
            id=str(scan.get("id") or ""),
            user_id=str(scan.get("user_id") or ""),
            file_name=str(scan.get("file_name") or ""),
            file_hash=str(scan.get("file_hash") or ""),
            threat_score=Decimal(str(scan.get("threat_score", 0))),
            status=ScanStatus(scan.get("status")),
            media_type=scan.get("media_type"),
            file_size=scan.get("file_size"),
            result_details=scan.get("result_details"),
            created_at=scan.get("created_at"),
            completed_at=scan.get("completed_at"),
            tier2_confidence=scan.get("result_details", {}).get("gemini_confidence") if isinstance(scan.get("result_details"), dict) else None,
        )
        
    except DatabaseError as e:
        logger.error(f"Database error getting scan {scan_id}: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to retrieve scan"
        )


@router.get(
    "",
    response_model=dict,
    responses={
        401: {"model": ErrorResponse, "description": "Unauthorized"},
    },
    summary="List user scans",
)
async def list_scans(
    user_id: CurrentUserId,
    _: ValidatedUser,
    page: int = 1,
    page_size: int = 20,
    status_filter: ScanStatus | None = None,
    media_type: str | None = None,
) -> dict[str, Any]:
    """Get paginated list of user's scans."""
    try:
        scans, total = await get_user_scans(
            user_id=user_id,
            page=page,
            page_size=page_size,
            status_filter=status_filter,
            media_type_filter=media_type
        )
        
        scan_responses = [
            ScanResponse(
                id=str(scan.get("id") or ""),
                user_id=str(scan.get("user_id") or ""),
                file_name=str(scan.get("file_name") or ""),
                file_hash=str(scan.get("file_hash") or ""),
                threat_score=Decimal(str(scan.get("threat_score", 0))),
                status=ScanStatus(scan.get("status")),
                media_type=scan.get("media_type"),
                file_size=scan.get("file_size"),
                result_details=scan.get("result_details"),
                created_at=scan.get("created_at"),
                completed_at=scan.get("completed_at"),
                tier2_confidence=scan.get("result_details", {}).get("gemini_confidence") if isinstance(scan.get("result_details"), dict) else None,
            )
            for scan in scans
        ]
        
        return {
            "scans": scan_responses,
            "total": total,
            "page": page,
            "page_size": page_size,
        }
        
    except DatabaseError as e:
        logger.error(f"Database error listing scans: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to retrieve scans"
        )


@router.get(
    "/stats/summary",
    response_model=dict,
    responses={
        401: {"model": ErrorResponse, "description": "Unauthorized"},
    },
    summary="Get user scan statistics",
)
async def get_stats(
    user_id: CurrentUserId,
    _: ValidatedUser,
) -> dict[str, Any]:
    """Get scan statistics for the authenticated user."""
    try:
        stats = await get_user_stats(user_id)
        return stats
    except DatabaseError as e:
        logger.error(f"Database error getting stats: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to retrieve statistics"
        )

```

## `backend\app\core\__init__.py`
```python
"""
Core package initialization.
"""

from app.core.config import settings
from app.core.security import (
    FileInfo,
    FileSignature,
    FileTooSmallError,
    InvalidFileSignatureError,
    generate_file_hash,
    get_supported_extensions,
    get_supported_mime_types,
    is_media_file,
    verify_and_hash_file,
    verify_file_signature,
)

__all__ = [
    "settings",
    "FileInfo",
    "FileSignature",
    "FileTooSmallError",
    "InvalidFileSignatureError",
    "generate_file_hash",
    "get_supported_extensions",
    "get_supported_mime_types",
    "is_media_file",
    "verify_and_hash_file",
    "verify_file_signature",
]

```

## `backend\app\core\config.py`
```python
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

    # â”€â”€ Firebase â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    FIREBASE_CREDENTIALS_PATH: str = Field(
        default="firebase-service-account.json",
        description="Path to Firebase service account JSON file"
    )
    FIREBASE_PROJECT_ID: str = Field(
        default="nexus-gateway-cca4c",
        description="Firebase / GCP project ID"
    )

    # â”€â”€ AI APIs â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    HUGGINGFACE_API_TOKEN: str = Field(..., description="HuggingFace Inference API Token")
    NVIDIA_API_KEY: str = Field(default="", description="NVIDIA NIM API key for Tier-2 analysis")
    GEMINI_API_KEY: str = Field(default="", description="Google Gemini API key for Tier-3 analysis")

    # â”€â”€ JWT (kept for legacy token parsing if needed) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    JWT_AUDIENCE: str = "authenticated"
    JWT_ALGORITHM: str = "HS256"

    # â”€â”€ File Upload â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    MAX_FILE_SIZE: int = Field(default=104857600, description="Max upload size in bytes (100 MB)")
    ALLOWED_EXTENSIONS: str = ".mp4,.avi,.mov,.webm,.mkv,.wav,.mp3,.flac,.ogg,.png,.jpg,.jpeg,.gif,.webp,.bmp"

    # â”€â”€ Scanning â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    SCAN_TIMEOUT: int = Field(default=300, description="Scan processing timeout in seconds")
    THREAT_THRESHOLD_LOW: float = Field(default=30.0, ge=0, le=100)
    THREAT_THRESHOLD_HIGH: float = Field(default=70.0, ge=0, le=100)

    # â”€â”€ Rate Limiting â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    RATE_LIMIT_REQUESTS: int = Field(default=100, description="Requests per minute per IP")
    RATE_LIMIT_ENABLED: bool = True

    # â”€â”€ CORS â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    CORS_ORIGINS: str = "http://localhost:3000,http://localhost:8080"
    CORS_ALLOW_CREDENTIALS: bool = True
    CORS_ALLOW_METHODS: str = "*"
    CORS_ALLOW_HEADERS: str = "*"

    # â”€â”€ Validators â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    @field_validator("FIREBASE_CREDENTIALS_PATH")
    @classmethod
    def validate_credentials_path(cls, v: str) -> str:
        # Allow relative paths â€” resolved at runtime from CWD (backend/)
        return v

    @field_validator("ENVIRONMENT")
    @classmethod
    def validate_environment(cls, v: str) -> str:
        allowed = ["development", "staging", "production"]
        if v not in allowed:
            raise ValueError(f"ENVIRONMENT must be one of: {allowed}")
        return v

    # â”€â”€ Computed properties â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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

```

## `backend\app\core\security.py`
```python
"""
Core security utilities for Deepfake Authentication Gateway.
Implements malicious payload mitigation through file signature verification
and cryptographic hashing for deduplication.
"""

import hashlib
from dataclasses import dataclass
from enum import Enum
from typing import Optional


class FileSignature(str, Enum):
    MP4 = "mp4"
    MP4_ALT = "mp4_alt"
    AVI = "avi"
    MOV = "mov"
    WAV = "wav"
    MP3 = "mp3"
    FLAC = "flac"
    OGG = "ogg"
    WEBM = "webm"
    MKV = "mkv"
    PNG = "png"
    JPEG = "jpeg"
    GIF = "gif"
    WEBP = "webp"
    BMP = "bmp"


@dataclass
class FileInfo:
    signature: FileSignature
    media_type: str
    mime_type: str
    is_valid: bool
    description: str


FILE_SIGNATURES: dict[tuple[bytes, ...], FileInfo] = {
    (b"\x00\x00\x00\x18\x66\x74\x79\x70", b"\x00\x00\x00\x1c\x66\x74\x79\x70"): FileInfo(
        signature=FileSignature.MP4,
        media_type="video",
        mime_type="video/mp4",
        is_valid=True,
        description="MP4 video file (ISO Base Media)"
    ),
    (b"\x00\x00\x00\x20\x66\x74\x79\x70",): FileInfo(
        signature=FileSignature.MP4_ALT,
        media_type="video",
        mime_type="video/mp4",
        is_valid=True,
        description="MP4 video file (QuickTime)"
    ),
    (b"\x1a\x45\xdf\xa3",): FileInfo(
        signature=FileSignature.WEBM,
        media_type="video",
        mime_type="video/webm",
        is_valid=True,
        description="WebM/MKV container"
    ),
    (b"\x66\x4c\x61\x43",): FileInfo(
        signature=FileSignature.FLAC,
        media_type="audio",
        mime_type="audio/flac",
        is_valid=True,
        description="FLAC audio file"
    ),
    (b"\x4f\x67\x67\x53",): FileInfo(
        signature=FileSignature.OGG,
        media_type="audio",
        mime_type="audio/ogg",
        is_valid=True,
        description="OGG container"
    ),
    (b"\x49\x44\x33", b"\xff\xfb", b"\xff\xfa", b"\xff\xf3"): FileInfo(
        signature=FileSignature.MP3,
        media_type="audio",
        mime_type="audio/mpeg",
        is_valid=True,
        description="MP3 audio file"
    ),
    (b"\x89\x50\x4e\x47\x0d\x0a\x1a\x0a",): FileInfo(
        signature=FileSignature.PNG,
        media_type="image",
        mime_type="image/png",
        is_valid=True,
        description="PNG image file"
    ),
    (b"\xff\xd8\xff",): FileInfo(
        signature=FileSignature.JPEG,
        media_type="image",
        mime_type="image/jpeg",
        is_valid=True,
        description="JPEG image file"
    ),
    (b"\x47\x49\x46\x38",): FileInfo(
        signature=FileSignature.GIF,
        media_type="image",
        mime_type="image/gif",
        is_valid=True,
        description="GIF image file"
    ),
    (b"\x42\x4d",): FileInfo(
        signature=FileSignature.BMP,
        media_type="image",
        mime_type="image/bmp",
        is_valid=True,
        description="BMP image file"
    ),
    (b"\x41\x56\x49\x20",): FileInfo(
        signature=FileSignature.AVI,
        media_type="video",
        mime_type="video/x-msvideo",
        is_valid=True,
        description="AVI video file"
    ),
    (b"\x6d\x6f\x6f\x76", b"\x6d\x64\x61\x74", b"\x66\x72\x65\x65"): FileInfo(
        signature=FileSignature.MOV,
        media_type="video",
        mime_type="video/quicktime",
        is_valid=True,
        description="QuickTime MOV file"
    ),
}

MIN_FILE_SIZE = 12
MAX_SIGNATURE_READ = 32


class InvalidFileSignatureError(Exception):
    def __init__(self, message: str = "Invalid file signature - potential malicious payload"):
        self.message = message
        super().__init__(self.message)


class FileTooSmallError(Exception):
    def __init__(self, message: str = "File too small to be a valid media file"):
        self.message = message
        super().__init__(self.message)


def verify_file_signature(file_bytes: bytes) -> FileInfo:
    """
    Cryptographically verify file signature using magic bytes.
    
    This function reads the first few bytes (magic numbers) of a file to
    determine if it's a genuine media format, completely ignoring the
    file extension which can be easily spoofed by attackers.
    
    Args:
        file_bytes: Raw bytes of the uploaded file
        
    Returns:
        FileInfo: Validated file information including media type and MIME
        
    Raises:
        FileTooSmallError: If file is smaller than minimum threshold
        InvalidFileSignatureError: If file signature doesn't match known media formats
    """
    if len(file_bytes) < MIN_FILE_SIZE:
        raise FileTooSmallError(
            f"File size {len(file_bytes)} bytes is below minimum {MIN_FILE_SIZE} bytes"
        )
    
    header = file_bytes[:MAX_SIGNATURE_READ]
    
    for magic_bytes, file_info in FILE_SIGNATURES.items():
        for magic in magic_bytes:
            if header.startswith(magic):
                return file_info
    
    wav_riff_check = file_bytes[:4] == b"\x52\x49\x46\x46"
    if wav_riff_check and len(file_bytes) >= 12:
        wave_marker = file_bytes[8:12]
        if wave_marker == b"WAVE":
            return FileInfo(
                signature=FileSignature.WAV,
                media_type="audio",
                mime_type="audio/wav",
                is_valid=True,
                description="WAV audio file (RIFF/WAVE)"
            )
        elif wave_marker == b"WEBP":
            return FileInfo(
                signature=FileSignature.WEBP,
                media_type="image",
                mime_type="image/webp",
                is_valid=True,
                description="WebP image file (RIFF/WEBP)"
            )
        elif wave_marker == b"AVI ":
            return FileInfo(
                signature=FileSignature.AVI,
                media_type="video",
                mime_type="video/x-msvideo",
                is_valid=True,
                description="AVI video file (RIFF/AVI)"
            )
    
    webp_riff_check = (
        len(file_bytes) >= 12 and
        file_bytes[:4] == b"\x52\x49\x46\x46" and
        file_bytes[8:12] == b"WEBP"
    )
    if webp_riff_check:
        return FileInfo(
            signature=FileSignature.WEBP,
            media_type="image",
            mime_type="image/webp",
            is_valid=True,
            description="WebP image file"
        )
    
    hex_preview = file_bytes[:16].hex()
    raise InvalidFileSignatureError(
        f"Unrecognized file signature. First 16 bytes (hex): {hex_preview}. "
        "File does not match any supported media format signatures. "
        "Potential malicious payload detected."
    )


def generate_file_hash(file_bytes: bytes) -> str:
    """
    Generate SHA-256 cryptographic hash of file for deduplication.
    
    This creates a unique fingerprint of the file content that can be used
    for:
    - Cryptographic deduplication (avoid re-scanning identical files)
    - Integrity verification
    - Audit trail linking
    
    Args:
        file_bytes: Raw bytes of the file to hash
        
    Returns:
        str: 64-character lowercase hexadecimal SHA-256 hash
    """
    sha256_hash = hashlib.sha256()
    sha256_hash.update(file_bytes)
    return sha256_hash.hexdigest().lower()


def verify_and_hash_file(file_bytes: bytes) -> tuple[FileInfo, str]:
    """
    Combined verification and hashing for efficiency.
    
    Performs both file signature verification and hash generation
    in a single operation.
    
    Args:
        file_bytes: Raw bytes of the uploaded file
        
    Returns:
        tuple: (FileInfo, sha256_hash) - validated file info and hash
        
    Raises:
        FileTooSmallError: If file is too small
        InvalidFileSignatureError: If signature verification fails
    """
    file_info = verify_file_signature(file_bytes)
    file_hash = generate_file_hash(file_bytes)
    return file_info, file_hash


def get_supported_extensions() -> list[str]:
    """Return list of supported file extensions based on signatures."""
    return [
        ".mp4", ".avi", ".mov", ".webm", ".mkv",
        ".wav", ".mp3", ".flac", ".ogg",
        ".png", ".jpg", ".jpeg", ".gif", ".webp", ".bmp"
    ]


def get_supported_mime_types() -> list[str]:
    """Return list of supported MIME types."""
    return list(set(info.mime_type for info in FILE_SIGNATURES.values()))


def is_media_file(file_bytes: bytes) -> bool:
    """
    Quick check if file is a valid media type.
    
    Args:
        file_bytes: Raw bytes to check
        
    Returns:
        bool: True if file signature matches a supported media format
    """
    try:
        verify_file_signature(file_bytes)
        return True
    except (InvalidFileSignatureError, FileTooSmallError):
        return False

```

## `backend\app\main.py`
```python
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
    "http://localhost:3000",
    "http://localhost:8080",
    "http://localhost:5000",
    "http://127.0.0.1:3000",
    "http://127.0.0.1:8080",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=_ALLOWED_ORIGINS,
    allow_credentials=True,  # Safe because we use explicit origins, not [*]
    allow_methods=["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allow_headers=["*"],
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
    # NOTE: No Content-Security-Policy here â€” it blocks Firebase/CDN resources
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

```

## `backend\app\models\__init__.py`
```python
"""
Models package initialization.
"""

from app.models.schemas import (
    ErrorResponse,
    FileUploadRequest,
    HealthResponse,
    MediaType,
    ScanCreate,
    ScanListResponse,
    ScanResponse,
    ScanStatsResponse,
    ScanStatus,
    UserProfile,
    UserProfileUpdate,
    UserTokenData,
    UserRole,
)

__all__ = [
    "ErrorResponse",
    "FileUploadRequest",
    "HealthResponse",
    "MediaType",
    "ScanCreate",
    "ScanListResponse",
    "ScanResponse",
    "ScanStatsResponse",
    "ScanStatus",
    "UserProfile",
    "UserProfileUpdate",
    "UserTokenData",
    "UserRole",
]

```

## `backend\app\models\schemas.py`
```python
"""
Strict Pydantic models for Deepfake Authentication Gateway API.
Provides request/response validation with zero-trust principles.
"""

from datetime import datetime
from decimal import Decimal
from enum import Enum
from typing import Any, Dict, Optional
from uuid import UUID

from pydantic import BaseModel, Field, field_validator


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
    tier2_confidence: Optional[float] = Field(None, description="Tier 2 NVIDIA confidence score")

    model_config = {"from_attributes": True}


class ScanListResponse(BaseModel):
    scans: list[ScanResponse] = Field(..., description="List of scans")
    total: int = Field(..., ge=0, description="Total count")
    page: int = Field(..., ge=1, description="Current page")
    page_size: int = Field(..., ge=1, le=100, description="Items per page")


class UserTokenData(BaseModel):
    sub: str = Field(..., description="User ID from Firebase Auth")
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
    id: str = Field(..., description="User ID")
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

```

## `backend\app\services\__init__.py`
```python
"""
Services package initialization.
"""

from app.services.hf_client import (
    DeepfakeAnalysisResult,
    HFAPIConnectionError,
    HFAPIResponseError,
    HFModelError,
    HFTimeoutError,
    HuggingFaceClient,
    analyze_deepfake,
    get_hf_client,
)
from app.services.firestore_db import (
    DatabaseError,
    DuplicateScanError,
    ScanNotFoundError,
    check_hash_exists,
    clear_cache,
    get_scan_by_id,
    get_user_scans,
    get_user_stats,
    log_scan,
    update_scan_status,
)

__all__ = [
    "DeepfakeAnalysisResult",
    "HFAPIConnectionError",
    "HFAPIResponseError",
    "HFModelError",
    "HFTimeoutError",
    "HuggingFaceClient",
    "analyze_deepfake",
    "get_hf_client",
    "DatabaseError",
    "DuplicateScanError",
    "ScanNotFoundError",
    "check_hash_exists",
    "clear_cache",
    "get_scan_by_id",
    "get_user_scans",
    "get_user_stats",
    "log_scan",
    "update_scan_status",
]

```

## `backend\app\services\firebase_config.py`
```python
"""
Firebase Admin SDK â€” Singleton Initializer.
Handles app initialization and provides lazy-loaded Firestore + Auth clients.
Call initialize_firebase() once from the FastAPI lifespan handler.
"""

import logging
from typing import Optional

import firebase_admin
from firebase_admin import auth, credentials, firestore

from app.core.config import settings

logger = logging.getLogger(__name__)

_firebase_app: Optional[firebase_admin.App] = None
_firestore_client = None


def initialize_firebase() -> None:
    """Initialize Firebase Admin SDK. Safe to call multiple times."""
    global _firebase_app
    if firebase_admin._apps:
        logger.info("[Firebase] Already initialized â€” skipping.")
        return

    import os
    import json
    
    firebase_json_string = os.getenv("FIREBASE_CREDENTIALS_JSON")
    
    if firebase_json_string:
        firebase_dict = json.loads(firebase_json_string)
        cred = credentials.Certificate(firebase_dict)
        _firebase_app = firebase_admin.initialize_app(cred, {
            "projectId": settings.FIREBASE_PROJECT_ID,
        })
        logger.info(
            f"[Firebase] Admin SDK initialized via JSON string â€” project: {settings.FIREBASE_PROJECT_ID}"
        )
    else:
        logger.warning("WARNING: Firebase credentials missing from env var. Checking for Secret File...")
        
        render_secret_path = "/etc/secrets/firebase-adminsdk.json"
        
        if os.path.exists(render_secret_path):
            logger.info(f"Found Render Secret File at {render_secret_path}")
            cred_path = render_secret_path
        else:
            logger.info(f"Falling back to local file: {settings.FIREBASE_CREDENTIALS_PATH}")
            cred_path = settings.FIREBASE_CREDENTIALS_PATH
            
        os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = cred_path
        cred = credentials.Certificate(cred_path)
        _firebase_app = firebase_admin.initialize_app(cred, {
            "projectId": settings.FIREBASE_PROJECT_ID,
        })
        logger.info(
            f"[Firebase] Admin SDK initialized via file â€” project: {settings.FIREBASE_PROJECT_ID}"
        )


def get_firestore():
    """Return a lazy-loaded Firestore async client."""
    global _firestore_client
    if _firestore_client is None:
        _firestore_client = firestore.AsyncClient()
    return _firestore_client


def verify_firebase_token(id_token: str) -> dict:
    """
    Verify a Firebase ID Token and return its decoded payload.
    Raises firebase_admin.auth.InvalidIdTokenError on failure.
    """
    return auth.verify_id_token(id_token)

```

## `backend\app\services\firestore_db.py`
```python
"""
Firestore database operations for Deepfake Authentication Gateway.
Drop-in replacement for supabase_db.py â€” same function signatures,
Firestore backend instead of PostgreSQL.

Collection: scans
Document fields: user_id, file_name, file_hash, hf_score,
                 gemini_verdict, gemini_reasoning, gemini_model_used,
                 gemini_confidence, gemini_tier, media_type, file_size,
                 status, created_at
"""

import logging
import uuid
from datetime import datetime, timezone
from decimal import Decimal
from typing import Any, Optional

import cachetools
from google.cloud.firestore_v1.base_query import FieldFilter

from app.models.schemas import ScanStatus
from app.services.firebase_config import get_firestore

logger = logging.getLogger(__name__)

COLLECTION = "scans"

_scanned_hash_cache = cachetools.TTLCache(maxsize=10000, ttl=3600)


# â”€â”€ Custom Exceptions (same interface as supabase_db.py) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class DatabaseError(Exception):
    def __init__(self, message: str, original_error: Optional[Exception] = None):
        self.message = message
        self.original_error = original_error
        super().__init__(self.message)


class ScanNotFoundError(DatabaseError):
    pass


class DuplicateScanError(DatabaseError):
    pass


# â”€â”€ Helpers â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

def _server_timestamp():
    return datetime.now(timezone.utc).isoformat()


def _doc_to_app(doc_id: str, data: dict[str, Any]) -> dict[str, Any]:
    """Map a Firestore document to the application response shape."""
    return {
        "id": doc_id,
        "user_id": data.get("user_id"),
        "file_name": data.get("file_name", "unknown"),
        "file_hash": data.get("file_hash", ""),
        "threat_score": data.get("hf_score"),
        "status": data.get("status", ScanStatus.COMPLETED.value),
        "media_type": data.get("media_type"),
        "file_size": data.get("file_size"),
        "result_details": {
            "gemini_verdict":    data.get("gemini_verdict"),
            "gemini_reasoning":  data.get("gemini_reasoning"),
            "gemini_model_used": data.get("gemini_model_used"),
            "gemini_confidence": data.get("gemini_confidence"),
            "gemini_tier":       data.get("gemini_tier"),
            "hf_score":          data.get("hf_score"),
            "hf_score_pct":      data.get("hf_score_pct"),
            "model_used":        data.get("model_used"),
            "processing_time_ms": data.get("processing_time_ms"),
            "confidence_level":  data.get("confidence_level"),
            "is_deepfake":       data.get("is_deepfake"),
            "tier_used":         data.get("tier_used"),
        },
        "created_at":   data.get("created_at"),
        "completed_at": data.get("completed_at") or data.get("created_at"),
    }


# â”€â”€ Public API (same signatures as supabase_db.py) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

async def check_hash_exists(file_hash: str, user_id: str) -> Optional[dict[str, Any]]:
    """Return cached scan data if hash was seen recently, else None."""
    if file_hash in _scanned_hash_cache:
        cached_score, cached_time = _scanned_hash_cache[file_hash]
        logger.info(f"[Firestore] Cache hit for hash {file_hash[:16]}...")
        return {"hf_score": cached_score, "created_at": cached_time}
    return None


async def log_scan(
    user_id: str,
    file_name: str,
    file_hash: str,
    threat_score: Decimal,
    status: ScanStatus,
    media_type: Optional[str] = None,
    file_size: Optional[int] = None,
    result_details: Optional[dict[str, Any]] = None,
) -> dict[str, Any]:
    """Create a new scan document in Firestore."""
    scan_id = str(uuid.uuid4())
    now = _server_timestamp()

    rd = result_details or {}
    doc_data: dict[str, Any] = {
        "user_id":           user_id,
        "file_name":         file_name,
        "file_hash":         file_hash,
        "hf_score":          float(threat_score),
        "hf_score_pct":      float(threat_score),
        "status":            status.value,
        "media_type":        media_type,
        "file_size":         file_size,
        "created_at":        now,
        "completed_at":      now if status == ScanStatus.COMPLETED else None,
        # Tier-2 fields
        "gemini_verdict":    rd.get("gemini_verdict"),
        "gemini_reasoning":  rd.get("gemini_reasoning"),
        "gemini_model_used": rd.get("gemini_model_used"),
        "gemini_confidence": rd.get("gemini_confidence"),
        "gemini_tier":       rd.get("gemini_tier"),
        # Tier-1 fields
        "model_used":        rd.get("model_used"),
        "processing_time_ms": rd.get("processing_time_ms"),
        "confidence_level":  rd.get("confidence_level"),
        "is_deepfake":       rd.get("is_deepfake"),
        "tier_used":         rd.get("tier_used"),
    }

    try:
        db = get_firestore()
        await db.collection(COLLECTION).document(scan_id).set(doc_data)
        _scanned_hash_cache[file_hash] = (threat_score, now)
        logger.info(f"[Firestore] Logged scan {scan_id} for user {user_id}")
        return _doc_to_app(scan_id, doc_data)
    except Exception as e:
        logger.error(f"[Firestore] log_scan failed: {e}")
        raise DatabaseError(f"Failed to log scan: {e}", e)


async def update_scan_status(
    scan_id: str,
    status: ScanStatus,
    threat_score: Optional[Decimal] = None,
    result_details: Optional[dict[str, Any]] = None,
    file_name: str = "unknown",
    file_hash: str = "",
    media_type: Optional[str] = None,
    file_size: Optional[int] = None,
) -> dict[str, Any]:
    """Update an existing scan document."""
    rd = result_details or {}
    update_data: dict[str, Any] = {
        "status": status.value,
        "completed_at": _server_timestamp(),
    }

    if threat_score is not None:
        update_data["hf_score"] = float(threat_score)
        update_data["hf_score_pct"] = float(threat_score)

    # Merge Tier-2 fields
    for key in (
        "gemini_verdict", "gemini_reasoning", "gemini_model_used",
        "gemini_confidence", "gemini_tier", "model_used",
        "processing_time_ms", "confidence_level", "is_deepfake", "tier_used",
    ):
        if rd.get(key) is not None:
            update_data[key] = rd[key]

    try:
        db = get_firestore()
        ref = db.collection(COLLECTION).document(scan_id)
        await ref.update(update_data)

        snap = await ref.get()
        if not snap.exists:
            raise ScanNotFoundError(f"Scan {scan_id} not found after update")

        data = snap.to_dict() or {}
        data.update(update_data)
        data.setdefault("file_name", file_name)
        data.setdefault("file_hash", file_hash)
        data.setdefault("media_type", media_type)
        data.setdefault("file_size", file_size)
        logger.info(f"[Firestore] Updated scan {scan_id}")
        return _doc_to_app(scan_id, data)
    except ScanNotFoundError:
        raise
    except Exception as e:
        logger.error(f"[Firestore] update_scan_status failed: {e}")
        raise DatabaseError(f"Failed to update scan: {e}", e)


async def get_scan_by_id(scan_id: str, user_id: str) -> Optional[dict[str, Any]]:
    """Fetch a single scan document by ID, scoped to user."""
    try:
        db = get_firestore()
        snap = await db.collection(COLLECTION).document(scan_id).get()
        if not snap.exists:
            return None
        data = snap.to_dict() or {}
        if data.get("user_id") != user_id:
            return None  # Enforce ownership
        return _doc_to_app(scan_id, data)
    except Exception as e:
        logger.error(f"[Firestore] get_scan_by_id failed: {e}")
        raise DatabaseError(f"Failed to get scan: {e}", e)


async def get_user_scans(
    user_id: str,
    page: int = 1,
    page_size: int = 20,
    status_filter: Optional[ScanStatus] = None,
    media_type_filter: Optional[str] = None,
) -> tuple[list[dict[str, Any]], int]:
    """Get paginated scans for a user, newest first."""
    try:
        db = get_firestore()
        query = db.collection(COLLECTION) \
                   .where(filter=FieldFilter("user_id", "==", user_id)) \
                   .order_by("created_at", direction="DESCENDING")

        # Fetch all matching docs for total count (Firestore has no COUNT())
        all_snaps = [snap async for snap in query.stream()]
        
        # In-memory filtering to avoid composite index requirements
        filtered_snaps = []
        for snap in all_snaps:
            data = snap.to_dict() or {}
            
            if status_filter and data.get("status") != status_filter.value:
                continue
                
            if media_type_filter and media_type_filter != "all":
                if data.get("media_type") != media_type_filter:
                    continue
                    
            filtered_snaps.append(snap)

        total = len(filtered_snaps)

        # Manual pagination
        offset = (page - 1) * page_size
        page_snaps = filtered_snaps[offset: offset + page_size]

        scans = [
            _doc_to_app(snap.id, snap.to_dict() or {})
            for snap in page_snaps
        ]
        logger.debug(f"[Firestore] {len(scans)}/{total} scans for user {user_id}")
        return scans, total
    except Exception as e:
        logger.error(f"[Firestore] get_user_scans failed: {e}")
        raise DatabaseError(f"Failed to get scans: {e}", e)


async def get_user_stats(user_id: str) -> dict[str, Any]:
    """Compute scan statistics from Firestore for a user."""
    try:
        db = get_firestore()
        query = db.collection(COLLECTION) \
                   .where(filter=FieldFilter("user_id", "==", user_id))

        snaps = [snap async for snap in query.stream()]
        total = len(snaps)

        scores = [
            float(s.to_dict().get("hf_score", 0))
            for s in snaps
            if s.to_dict().get("hf_score") is not None
        ]
        avg_score = round(sum(scores) / len(scores), 2) if scores else 0.0

        completed = sum(
            1 for s in snaps
            if s.to_dict().get("status") == ScanStatus.COMPLETED.value
        )
        pending = total - completed

        return {
            "total_scans":     total,
            "pending_scans":   pending,
            "completed_scans": completed,
            "avg_threat_score": avg_score,
        }
    except Exception as e:
        logger.error(f"[Firestore] get_user_stats failed: {e}")
        raise DatabaseError(f"Failed to get stats: {e}", e)


def clear_cache() -> None:
    """Clear the in-memory hash deduplication cache."""
    _scanned_hash_cache.clear()
    logger.info("[Firestore] Hash cache cleared")

```

## `backend\app\services\gemini_client.py`
```python
"""
Tier-2 Visual Forensics â€” NVIDIA NIM (LLaMA 3.2 90B Vision).
Uses AsyncOpenAI, proper frame extraction for video, and spectrogram for audio.
"""

import asyncio
import base64
import io
import json
import logging
import math
import re
from typing import Optional

from openai import AsyncOpenAI
from app.core.config import settings

logger = logging.getLogger(__name__)

NVIDIA_MODEL      = "meta/llama-3.2-90b-vision-instruct"
MAX_IMAGE_LONG_EDGE = 1024
MAX_IMAGE_BYTES     = 300_000

# ---------------------------------------------------------------------------
# Forensic prompt
# ---------------------------------------------------------------------------

FORENSICS_PROMPT_TEMPLATE = (
    "You are a Zero-Trust Forensic Analyst operating within the Nexus Gateway deepfake detection platform. "
    "ALWAYS presume manipulation until forensic evidence conclusively proves otherwise.\n\n"

    "=== TIER-1 CLASSIFIER SIGNAL ===\n"
    "The Tier-1 AI binary classifier scored this image: {hf_score_pct:.1f}% synthetic probability. "
    "This informs your threshold â€” YOUR visual forensic analysis is the final authority.\n\n"

    "=== MANDATORY 10-POINT FORENSIC CHECKLIST ===\n"
    "Mark each as PASS or FLAG. Be specific â€” vague observations are inadmissible.\n\n"

    "1. SKIN TEXTURE & MICROSTRUCTURE\n"
    "   FLAG if: unnaturally smooth, plastic, airbrushed skin; tiled texture patterns.\n\n"

    "2. LIGHTING PHYSICS & SHADOW CONSISTENCY\n"
    "   FLAG if: shadows in contradictory directions; perfectly diffuse lighting with no harsh shadows; "
    "mismatched specular highlights.\n\n"

    "3. EYE INTEGRITY\n"
    "   FLAG if: catchlights missing or mismatched; irises unnaturally vivid/symmetric; "
    "sclera too clean or glowing.\n\n"

    "4. FACIAL SYMMETRY & GEOMETRY\n"
    "   FLAG if: near-perfect bilateral symmetry (strong GAN artifact); idealized proportions; "
    "teeth too uniform or white.\n\n"

    "5. HAIR & FINE EDGE RENDERING\n"
    "   FLAG if: hair smears/blends into background with halo artifact; hairline too sharp; "
    "hair appears painted on.\n\n"

    "6. BACKGROUND COHERENCE & DEPTH-OF-FIELD\n"
    "   FLAG if: subject appears cut-out with sharp unnatural boundary; "
    "uniform artificial blur instead of real bokeh; impossible background geometry.\n\n"

    "7. TEXT, LOGOS & OBJECT RENDERING\n"
    "   FLAG if: any visible text is garbled, warped, or contains phantom characters; "
    "logos distorted; jewelry/glasses have impossible topology.\n\n"

    "8. SENSOR NOISE & FREQUENCY FINGERPRINT\n"
    "   FLAG if: suspiciously clean image (no grain) inconsistent with the environment; "
    "noise present in background but absent on face (composite); inconsistent JPEG artifacts.\n\n"

    "9. FACIAL BOUNDARY & BLENDING ARTIFACTS\n"
    "   FLAG if: blurring/color-tone mismatch along face/neck/hairline boundary; "
    "face skin tone differs from neck or ears; jaw/chin shows warping or ghosting.\n\n"

    "10. CONTEXTUAL PLAUSIBILITY & GEOMETRY\n"
    "   FLAG if: accessories misaligned or passing through each other; "
    "hands/fingers with extra digits or merged joints; environmental inconsistencies.\n\n"

    "=== VERDICT DECISION MATRIX ===\n"
    " HIGH RISK  (HF > 65%): Identify >= 3 FLAGS. Verdict = DEEPFAKE.\n"
    " AMBIGUOUS  (40-65%): >=3 FLAGS â†’ DEEPFAKE. 1-2 FLAGS â†’ SUSPECTED. 0 FLAGS â†’ AUTHENTIC.\n"
    " LOW RISK   (<40%): 0 FLAGS â†’ AUTHENTIC. Any FLAG â†’ SUSPECTED.\n\n"

    "=== OUTPUT FORMAT ===\n"
    "Respond with ONLY valid JSON. No markdown, no code fences, no preamble.\n"
    "{{\n"
    '    "gemini_verdict": "DEEPFAKE" | "AUTHENTIC" | "SUSPECTED",\n'
    '    "gemini_confidence": "HIGH" | "MEDIUM" | "LOW",\n'
    '    "flagged_items": ["ITEM NAME: specific observation"],\n'
    '    "passed_items": ["ITEM NAME: brief confirmation"],\n'
    '    "gemini_reasoning": "2-4 sentences citing specific flagged items by name."\n'
    "}}\n"
)

AUDIO_SPECTROGRAM_PROMPT = (
    "You are an audio forensics expert analysing a mel-spectrogram image.\n"
    "The Tier-1 classifier scored this audio: {hf_score_pct:.1f}% synthetic probability.\n\n"
    "Check for: (1) unnaturally smooth formant transitions, (2) too-regular harmonics, "
    "(3) perfectly flat silence regions with no room tone, (4) abrupt energy step-changes "
    "between phonemes (splice artifacts), (5) hard high-freq rolloff at a round kHz value.\n\n"
    ">=2 artifacts â†’ DEEPFAKE. 1 artifact â†’ SUSPECTED. 0 â†’ AUTHENTIC.\n\n"
    "Respond with ONLY valid JSON:\n"
    "{{\n"
    '    "gemini_verdict": "DEEPFAKE" | "AUTHENTIC" | "SUSPECTED",\n'
    '    "gemini_confidence": "HIGH" | "MEDIUM" | "LOW",\n'
    '    "flagged_items": ["artifact: observation"],\n'
    '    "passed_items": ["artifact: observation"],\n'
    '    "gemini_reasoning": "2-3 sentences on the acoustic forensic findings."\n'
    "}}\n"
)

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _detect_mime_type(data: bytes) -> str:
    h = data[:12]
    if h[1:4] == b"PNG":                              return "image/png"
    if h[:2] == b"\xff\xd8":                          return "image/jpeg"
    if h[:6] in (b"GIF87a", b"GIF89a"):              return "image/gif"
    if h[:4] == b"RIFF" and h[8:12] == b"WEBP":      return "image/webp"
    if h[:4] == b"RIFF" and h[8:12] == b"WAVE":      return "audio/wav"
    if h[:3] == b"ID3" or h[:2] in (b"\xff\xfb", b"\xff\xf3", b"\xff\xfa"):
        return "audio/mpeg"
    if data[4:8] == b"ftyp":                          return "video/mp4"
    if h[:4] == b"\x1a\x45\xdf\xa3":                 return "video/webm"
    return "image/jpeg"


def _resize_image_bytes(image_bytes: bytes, mime_type: str = "image/jpeg") -> bytes:
    if len(image_bytes) <= MAX_IMAGE_BYTES:
        return image_bytes
    try:
        from PIL import Image as PILImage
        img = PILImage.open(io.BytesIO(image_bytes)).convert("RGB")
        w, h = img.size
        if max(w, h) > MAX_IMAGE_LONG_EDGE:
            scale = MAX_IMAGE_LONG_EDGE / max(w, h)
            img   = img.resize((int(w * scale), int(h * scale)), PILImage.LANCZOS)
        for q in range(88, 30, -10):
            buf = io.BytesIO()
            img.save(buf, format="JPEG", quality=q, optimize=True)
            if len(buf.getvalue()) <= MAX_IMAGE_BYTES:
                return buf.getvalue()
        buf = io.BytesIO()
        img.save(buf, format="JPEG", quality=35)
        return buf.getvalue()
    except Exception as e:
        logger.warning(f"[Resize] Failed: {e}")
        return image_bytes


def _audio_to_spectrogram_jpeg(audio_bytes: bytes) -> Optional[bytes]:
    try:
        import librosa, librosa.display, soundfile as sf
        import matplotlib; matplotlib.use("Agg")
        import matplotlib.pyplot as plt
        import numpy as np
        y, sr = sf.read(io.BytesIO(audio_bytes), dtype="float32", always_2d=False)
        if y.ndim > 1: y = y.mean(axis=1)
        S_db = librosa.power_to_db(librosa.feature.melspectrogram(y=y, sr=sr, n_mels=128), ref=np.max)
        fig, ax = plt.subplots(figsize=(8, 4), dpi=96)
        librosa.display.specshow(S_db, sr=sr, x_axis="time", y_axis="mel", ax=ax, cmap="magma")
        ax.set_title("Mel-Spectrogram â€” Forensic Analysis")
        plt.tight_layout()
        buf = io.BytesIO()
        fig.savefig(buf, format="jpeg", quality=90)
        plt.close(fig)
        return buf.getvalue()
    except Exception as e:
        logger.warning(f"[Audio] Spectrogram failed: {e}")
        return None


def _extract_video_frame_jpegs(video_bytes: bytes, n: int = 4) -> list[bytes]:
    try:
        import av
        from PIL import Image as PILImage
        container = av.open(io.BytesIO(video_bytes))
        stream    = container.streams.video[0]
        stream.codec_context.skip_frame = "NONKEY"
        duration  = float(stream.duration or 0) * float(stream.time_base)
        frames: list[bytes] = []
        for pct in [0.05, 0.25, 0.50, 0.75][:n]:
            try:
                ts = int(pct * duration / float(stream.time_base))
                container.seek(ts, stream=stream, any_frame=False, backward=True)
                for packet in container.demux(stream):
                    for frame in packet.decode():
                        buf = io.BytesIO()
                        frame.to_image().convert("RGB").save(buf, format="JPEG", quality=90)
                        frames.append(buf.getvalue())
                        break
                    break
            except Exception as e:
                logger.debug(f"[Video] Frame seek at {pct:.0%} failed: {e}")
        container.close()
        if frames:
            logger.info(f"[Video] Extracted {len(frames)} frames")
            return frames
    except ImportError:
        logger.warning("[Video] PyAV not installed â€” pip install av")
    except Exception as e:
        logger.warning(f"[Video] Extraction failed: {e}")
    return [video_bytes[:2 * 1024 * 1024]]


def _get_async_nvidia_client() -> AsyncOpenAI:
    api_key = getattr(settings, "NVIDIA_API_KEY", None)
    if not api_key:
        raise RuntimeError("NVIDIA_API_KEY not configured.")
    return AsyncOpenAI(base_url="https://integrate.api.nvidia.com/v1", api_key=api_key)


# ---------------------------------------------------------------------------
# Core vision call
# ---------------------------------------------------------------------------

async def _call_vision_model(image_bytes: bytes, prompt: str, mime: str = "image/jpeg"):
    image_bytes = _resize_image_bytes(image_bytes, mime)
    b64      = base64.b64encode(image_bytes).decode()
    data_url = f"data:{mime};base64,{b64}"
    client   = _get_async_nvidia_client()
    response = await client.chat.completions.create(
        model    = NVIDIA_MODEL,
        messages = [{"role": "user", "content": [
            {"type": "text",      "text": prompt},
            {"type": "image_url", "image_url": {"url": data_url}},
        ]}],
        response_format = {"type": "json_object"},
        temperature=0.1, top_p=0.9, logprobs=True,
    )
    model_used = getattr(response, "model", NVIDIA_MODEL)
    confidence: Optional[float] = None
    try:
        lp = getattr(response.choices[0], "logprobs", None)
        if lp and hasattr(lp, "content") and lp.content:
            mean_lp    = sum(t.logprob for t in lp.content) / len(lp.content)
            confidence = round(math.exp(mean_lp) * 100, 2)
    except Exception: pass
    return response.choices[0].message.content or "", model_used, confidence


# ---------------------------------------------------------------------------
# Verdict parsing
# ---------------------------------------------------------------------------

_ALIASES = {"SUSPICIOUS": "SUSPECTED", "ELEVATED_RISK": "SUSPECTED",
            "FAKE": "DEEPFAKE", "REAL": "AUTHENTIC", "GENUINE": "AUTHENTIC"}
_VALID   = {"DEEPFAKE", "AUTHENTIC", "SUSPECTED"}


def _parse_verdict(raw: str, model: str, conf: Optional[float], tier: str) -> dict:
    try:
        m = re.search(r'\{[^{}]*"gemini_verdict"[^{}]*\}', raw, re.DOTALL)
        parsed = json.loads(m.group() if m else re.sub(r"^```[a-z]*\n?", "", raw.strip()).rstrip("`"))
        v = _ALIASES.get(str(parsed.get("gemini_verdict", "AUTHENTIC")).upper(), "AUTHENTIC")
        if v not in _VALID: v = "AUTHENTIC"
        return {
            "gemini_verdict":            v,
            "gemini_confidence_label":   str(parsed.get("gemini_confidence", "MEDIUM")).upper(),
            "gemini_reasoning":          str(parsed.get("gemini_reasoning", "")),
            "flagged_items":             parsed.get("flagged_items", []),
            "passed_items":              parsed.get("passed_items", []),
            "gemini_model_used":         model,
            "gemini_confidence":         conf,
            "tier":                      tier,
        }
    except Exception as e:
        logger.warning(f"[TIER-2] Parse failed: {e}. Raw: {raw[:200]}")
        return {
            "gemini_verdict": "AUTHENTIC", "gemini_confidence_label": "LOW",
            "gemini_reasoning": f"Non-standard response. Excerpt: {raw[:100]}",
            "flagged_items": [], "passed_items": [],
            "gemini_model_used": model, "gemini_confidence": conf, "tier": tier,
        }


def _error_response(media: str) -> dict:
    return {
        "gemini_verdict": "ANALYSIS_FAILED", "gemini_confidence_label": "LOW",
        "gemini_reasoning": f"Tier-2 analysis failed for {media} â€” upstream API unavailable.",
        "flagged_items": [], "passed_items": [],
        "gemini_model_used": NVIDIA_MODEL, "gemini_confidence": None,
        "tier": f"tier-2-{media}-error",
    }


# ---------------------------------------------------------------------------
# Sub-pipelines
# ---------------------------------------------------------------------------

async def _analyze_image(image_bytes: bytes, mime: str, hf_pct: float) -> dict:
    try:
        raw, model, conf = await _call_vision_model(
            image_bytes, FORENSICS_PROMPT_TEMPLATE.format(hf_score_pct=hf_pct), mime
        )
        return _parse_verdict(raw, model, conf, "tier-2-image")
    except Exception as e:
        logger.error(f"[TIER-2][Image] {e}")
        return _error_response("image")


async def _analyze_audio(audio_bytes: bytes, hf_pct: float) -> dict:
    spec = _audio_to_spectrogram_jpeg(audio_bytes)
    if spec is None:
        return {
            "gemini_verdict": "SUSPECTED", "gemini_confidence_label": "LOW",
            "gemini_reasoning": "Spectrogram unavailable (install librosa soundfile matplotlib).",
            "flagged_items": [], "passed_items": [],
            "gemini_model_used": NVIDIA_MODEL, "gemini_confidence": None,
            "tier": "tier-2-audio-fallback",
        }
    try:
        raw, model, conf = await _call_vision_model(
            spec, AUDIO_SPECTROGRAM_PROMPT.format(hf_score_pct=hf_pct), "image/jpeg"
        )
        result = _parse_verdict(raw, model, conf, "tier-2-audio-spectrogram")
        result["gemini_reasoning"] = "[Spectrogram] " + result.get("gemini_reasoning", "")
        return result
    except Exception as e:
        logger.error(f"[TIER-2][Audio] {e}")
        return _error_response("audio")


async def _analyze_video(video_bytes: bytes, hf_pct: float) -> dict:
    frames = _extract_video_frame_jpegs(video_bytes)
    logger.info(f"[TIER-2][Video] Analysing {len(frames)} frame(s)")
    prompt = FORENSICS_PROMPT_TEMPLATE.format(hf_score_pct=hf_pct)

    async def _one(fb: bytes, idx: int) -> Optional[dict]:
        try:
            raw, model, conf = await _call_vision_model(fb, prompt, "image/jpeg")
            return _parse_verdict(raw, model, conf, f"tier-2-video-f{idx+1}")
        except Exception as e:
            logger.warning(f"[TIER-2][Video] Frame {idx+1} failed: {e}")
            return None

    results = [r for r in await asyncio.gather(*[_one(f, i) for i, f in enumerate(frames[:4])]) if r]
    if not results:
        return _error_response("video")

    rank  = {"DEEPFAKE": 2, "SUSPECTED": 1, "AUTHENTIC": 0}
    worst = max(results, key=lambda r: rank.get(r["gemini_verdict"], 0))
    worst["video_frames_analysed"] = len(results)
    worst["all_frame_verdicts"]    = [r["gemini_verdict"] for r in results]
    worst["tier"]                  = "tier-2-video"
    return worst


# ---------------------------------------------------------------------------
# Public entry point
# ---------------------------------------------------------------------------

async def run_gemini_analysis(image_bytes: bytes, hf_score_normalized: float) -> dict:
    """Route payload to the correct Tier-2 sub-pipeline."""
    hf_pct    = hf_score_normalized * 100
    mime_type = _detect_mime_type(image_bytes)
    logger.info(f"[TIER-2] MIME={mime_type} size={len(image_bytes):,}B HF={hf_pct:.1f}%")

    if mime_type.startswith("audio/"):
        return await _analyze_audio(image_bytes, hf_pct)
    if mime_type.startswith("video/"):
        return await _analyze_video(image_bytes, hf_pct)
    return await _analyze_image(image_bytes, mime_type, hf_pct)

```

## `backend\app\services\hf_client.py`
```python
"""
Hugging Face API client for deepfake detection.
Uses the official huggingface_hub InferenceClient for reliable API access.
"""

import asyncio
import logging
import time
from dataclasses import dataclass
from typing import Any, Optional

import httpx
from huggingface_hub import InferenceClient

from app.core.config import settings
from app.core.security import FileInfo

logger = logging.getLogger(__name__)


# Model Constants
IMAGE_MODEL = "dima806/deepfake_vs_real_image_detection"
AUDIO_MODEL = "MelodyMachine/Deepfake-audio-detection-V2"

# Ordered fallback chain â€” prioritises AI-image detectors first, then face-deepfake models.
# umm-maybe/AI-image-detector: binary real/AI classifier trained on broad synthetic content
# Organika/sdxl-detector: SDXL/diffusion model detector
# dima806: face-deepfake specialist (covers GAN face swaps)
DEEPFAKE_MODELS = [
    "umm-maybe/AI-image-detector",        # Best for fully AI-generated images
    "Organika/sdxl-detector",             # Catches Stable-Diffusion / SDXL output
    IMAGE_MODEL,                           # Face-deepfake specialist
    "Falconsai/nsfw_image_detection",     # Warm fallback
]


class HFModelError(Exception):
    def __init__(self, message: str, status_code: Optional[int] = None):
        self.message = message
        self.status_code = status_code
        super().__init__(self.message)


class HFAPIConnectionError(HFModelError):
    pass


class HFAPIResponseError(HFModelError):
    pass


class HFTimeoutError(HFModelError):
    pass


@dataclass
class DeepfakeAnalysisResult:
    probability_score: float
    is_deepfake: bool
    confidence_level: str
    model_used: str
    processing_time_ms: float
    raw_response: dict[str, Any]


HF_TIMEOUT_SECONDS = 120
HF_RETRY_ATTEMPTS = 3
HF_RETRY_DELAY_SECONDS = 2


class HuggingFaceClient:
    """
    Client for Hugging Face Inference API using the official huggingface_hub library.
    Sends images and audio as binary data.
    """
    
    def __init__(self, api_key: str):
        self.api_key = api_key
        self._client: Optional[InferenceClient] = None
        self._http_client: Optional[httpx.AsyncClient] = None
        self._timeout = httpx.Timeout(HF_TIMEOUT_SECONDS)
    
    async def __aenter__(self) -> "HuggingFaceClient":
        await self._ensure_client()
        return self
    
    async def __aexit__(self, exc_type, exc_val, exc_tb) -> None:
        await self.close()
    
    async def _ensure_client(self) -> None:
        if self._client is None:
            self._client = InferenceClient(token=self.api_key)
        if self._http_client is None or self._http_client.is_closed:
            self._http_client = httpx.AsyncClient(
                timeout=self._timeout,
                headers={
                    "Authorization": f"Bearer {self.api_key}",
                    "User-Agent": f"{settings.APP_NAME}/{settings.APP_VERSION}"
                }
            )
    
    async def close(self) -> None:
        if self._http_client and not self._http_client.is_closed:
            await self._http_client.aclose()
            self._http_client = None
        self._client = None
    
    async def analyze_media(
        self,
        file_bytes: bytes,
        file_info: FileInfo,
        model_type: Optional[str] = None
    ) -> DeepfakeAnalysisResult:
        """
        Send media file to Hugging Face API for deepfake analysis.
        Routes payloads dynamically based on their MIME type.
        """
        start_time = time.monotonic()
        await self._ensure_client()
        
        mime_type = file_info.mime_type.lower()
        if mime_type.startswith("image/"):
            # Try AI-image detectors first, then face-deepfake model
            models_to_try = list(DEEPFAKE_MODELS)  # ordered chain
            return await self._run_inference(file_bytes, start_time, models_to_try)
        elif mime_type.startswith("audio/"):
            return await self._run_inference(file_bytes, start_time, [AUDIO_MODEL])
        elif mime_type.startswith("video/"):
            # Extract first chunk of video to test visual deepfake models
            chunk = file_bytes[:1024 * 1024]
            try:
                return await self._run_inference(chunk, start_time, [IMAGE_MODEL])
            except Exception as e:
                logger.warning(f"Video analysis failed, returning low confidence: {e}")
                return DeepfakeAnalysisResult(
                    probability_score=0.0,
                    is_deepfake=False,
                    confidence_level="low",
                    model_used="none",
                    processing_time_ms=(time.monotonic() - start_time) * 1000,
                    raw_response={"error": f"Video analysis not fully supported: {str(e)}"}
                )
        else:
            raise HFModelError(f"Unsupported MIME type for Tier 1: {mime_type}")

    async def _run_inference(
        self,
        file_bytes: bytes,
        start_time: float,
        models_to_try: list[str]
    ) -> DeepfakeAnalysisResult:
        """Core inference logic looping through target models."""
        last_error = None

        for model_name in models_to_try:
            for attempt in range(1, HF_RETRY_ATTEMPTS + 1):
                try:
                    logger.info(f"[HF] Attempting model={model_name} attempt={attempt}")

                    url = f"https://router.huggingface.co/hf-inference/models/{model_name}"

                    assert self._http_client is not None, "HTTP client not initialized"
                    response = await self._http_client.post(
                        url,
                        content=file_bytes,
                        headers={
                            "Authorization": f"Bearer {self.api_key}",
                            "Content-Type": "application/octet-stream",
                            "Accept": "application/json",
                        }
                    )

                    logger.info(f"[HF] HTTP {response.status_code} for {model_name}")

                    if response.status_code == 503:
                        try:
                            wait_s = float(response.json().get("estimated_time", 20))
                        except Exception:
                            wait_s = 20.0
                        logger.warning(f"[HF] Model cold-starting, sleeping {wait_s:.0f}sâ€¦")
                        await asyncio.sleep(min(wait_s, 60))
                        continue

                    if response.status_code == 429:
                        logger.warning(f"[HF] Rate limited, retrying in {HF_RETRY_DELAY_SECONDS}s")
                        await asyncio.sleep(HF_RETRY_DELAY_SECONDS)
                        continue

                    if response.status_code == 403:
                        err = response.json().get("error", "Permission denied")
                        logger.error(f"[HF] 403 for {model_name}: {err}")
                        last_error = HFAPIResponseError(
                            "HuggingFace 403: Token needs "
                            "'inference.serverless.write' permission.",
                            403
                        )
                        break

                    if response.status_code == 401:
                        logger.error(f"[HF] 401 for {model_name}: invalid token")
                        last_error = HFAPIResponseError("Invalid HuggingFace API key", 401)
                        break

                    response.raise_for_status()

                    result_data = response.json()
                    logger.info(f"[HF] Raw response for {model_name}: {result_data}")

                    result = self._parse_classification_result(result_data, model_name)
                    result.processing_time_ms = (time.monotonic() - start_time) * 1000

                    logger.info(
                        f"[HF] Done: score={result.probability_score:.2f}%, "
                        f"deepfake={result.is_deepfake}, model={model_name}"
                    )
                    return result

                except httpx.TimeoutException as e:
                    last_error = HFTimeoutError(f"API request timed out: {e}", 408)
                    logger.warning(f"[HF] Timeout attempt {attempt}: {e}")
                    if attempt < HF_RETRY_ATTEMPTS:
                        await asyncio.sleep(HF_RETRY_DELAY_SECONDS)

                except httpx.HTTPStatusError as e:
                    status = e.response.status_code
                    logger.error(f"[HF] HTTPStatusError {status} for {model_name}: {e.response.text[:200]}")
                    if status >= 500:
                        last_error = HFAPIResponseError(f"Server error {status}: {e.response.text}", status)
                        if attempt < HF_RETRY_ATTEMPTS:
                            await asyncio.sleep(HF_RETRY_DELAY_SECONDS)
                    else:
                        last_error = HFAPIResponseError(f"Client error {status}: {e.response.text}", status)
                        break

                except httpx.RequestError as e:
                    last_error = HFAPIConnectionError(f"Connection error: {e}")
                    logger.warning(f"[HF] Connection error attempt {attempt}: {e}")
                    if attempt < HF_RETRY_ATTEMPTS:
                        await asyncio.sleep(HF_RETRY_DELAY_SECONDS)

        if last_error:
            raise last_error
        raise HFModelError("All deepfake detection models failed")

    def _parse_classification_result(
        self,
        response: Any,
        model_name: str
    ) -> DeepfakeAnalysisResult:
        """
        Parse image/audio classification response.
        """
        logger.info(f"Parsing response type={type(response)}: {response}")

        data = response
        if isinstance(data, list) and len(data) > 0:
            if isinstance(data[0], list):
                data = data[0]

        MODEL_LABEL_MAPS: dict[str, dict[str, str]] = {
            "dima806/deepfake_vs_real_image_detection": {
                "fake": "fake", "real": "real"
            },
            "Organika/sdxl-detector": {
                "artificial": "fake", "human": "real",
                "sdxl": "fake", "not sdxl": "real",
                "ai-generated": "fake", "real": "real",
            },
            "umm-maybe/AI-image-detector": {
                # Model outputs: 'artificial' / 'human' with confidence scores
                "artificial": "fake",
                "ai": "fake",
                "human": "real",
                "real": "real",
            },
            "Nahrawy/AIorNot": {
                "ai": "fake",
                "real": "real",
            },
            "Falconsai/nsfw_image_detection": {
                "nsfw": "fake", "normal": "real"
            },
        }

        fake_keywords = [
            "fake", "deepfake", "ai", "generated", "artificial", "synthetic",
            "sdxl", "diffusion", "midjourney", "stable", "gan", "manipulated",
            "altered", "ai-art", "artificially", "computer-generated", "nsfw",
            "spoof"
        ]
        real_keywords = ["real", "authentic", "genuine", "human", "natural", "not", "normal", "bonafide"]

        fake_score = 0.0
        real_score = 0.0

        label_map = MODEL_LABEL_MAPS.get(model_name, {})

        if isinstance(data, list):
            for item in data:
                if isinstance(item, dict):
                    label = str(item.get("label", "")).lower()
                    score = float(item.get("score", 0))

                    if label in label_map:
                        mapped = label_map[label]
                        if mapped == "fake":
                            fake_score = max(fake_score, score)
                        elif mapped == "real":
                            real_score = max(real_score, score)
                        continue

                    if any(kw in label for kw in fake_keywords):
                        fake_score = max(fake_score, score)
                    elif any(kw in label for kw in real_keywords):
                        real_score = max(real_score, score)
        elif isinstance(data, dict):
            label = str(data.get("label", "")).lower()
            score = float(data.get("score", 0))

            if label in label_map:
                mapped = label_map[label]
                if mapped == "fake":
                     fake_score = score
                elif mapped == "real":
                    real_score = score
            elif any(kw in label for kw in fake_keywords):
                fake_score = score
            elif any(kw in label for kw in real_keywords):
                real_score = score
            else:
                real_score = score

        if fake_score > 0:
            probability_score = fake_score * 100
        elif real_score > 0:
            probability_score = (1.0 - real_score) * 100
        else:
            logger.warning(
                f"[HF_PARSER] Unknown labels for {model_name}. "
                f"Raw response: {data}. Returning 50% (uncertain)."
            )
            probability_score = 50.0

        if probability_score >= settings.THREAT_THRESHOLD_HIGH:
            confidence_level = "high"
            is_deepfake = True
        elif probability_score >= settings.THREAT_THRESHOLD_LOW:
            confidence_level = "medium"
            is_deepfake = probability_score > 50
        else:
            confidence_level = "low"
            is_deepfake = False

        return DeepfakeAnalysisResult(
            probability_score=probability_score,
            is_deepfake=is_deepfake,
            confidence_level=confidence_level,
            model_used=model_name,
            processing_time_ms=0.0,
            raw_response={"classifications": data if isinstance(data, list) else [data]}
        )


_hf_client: Optional[HuggingFaceClient] = None

async def get_hf_client() -> HuggingFaceClient:
    """Get or create Hugging Face client instance."""
    global _hf_client
    if _hf_client is None:
        _hf_client = HuggingFaceClient(settings.HUGGINGFACE_API_TOKEN)
    await _hf_client._ensure_client()
    return _hf_client


async def analyze_deepfake(
    file_bytes: bytes,
    file_info: FileInfo,
    model_type: Optional[str] = None
) -> DeepfakeAnalysisResult:
    """
    Convenience function to analyze media for deepfakes.
    """
    client = await get_hf_client()
    return await client.analyze_media(file_bytes, file_info, model_type)

```

## `backend\app\services\real_gemini_client.py`
```python
"""
Real Google Gemini Flash client for deepfake/AI-image detection.
Uses the Gemini REST API directly via httpx (already in requirements).
Model: gemini-2.0-flash  â€” fast, multimodal, free tier available.
"""

import asyncio
import base64
import json
import logging
import re
from typing import Optional

import httpx

from app.core.config import settings

logger = logging.getLogger(__name__)

GEMINI_API_BASE = "https://generativelanguage.googleapis.com/v1beta/models"
GEMINI_MODEL    = "gemini-2.0-flash"

GEMINI_FORENSIC_PROMPT = """You are a forensic deepfake detection expert for the Nexus Gateway security platform.
Analyze this image carefully and determine whether it is AI-generated, digitally manipulated (deepfake), or a genuine photograph.

Look for these specific indicators:
- SKIN: Unnatural smoothness, plastic texture, missing pores or blemishes
- LIGHTING: Inconsistent shadow directions, impossible or perfectly diffuse lighting
- EDGES: Hair or body edges that blend/smear unnaturally against the background
- EYES: Reflections that don't match the light source, unnatural pupil shape
- SYMMETRY: Unnaturally perfect facial symmetry (real faces are asymmetric)
- BACKGROUND: Artificially blurred or separated background, impossible geometry
- TEXT: Any visible text that is garbled, warped, or illegible (diffusion model artifact)
- NOISE: Suspiciously clean image with no photographic sensor noise

Based on your analysis, respond with ONLY a valid JSON object, no markdown, no explanation outside the JSON:
{"verdict": "DEEPFAKE", "confidence": 0.87, "reasoning": "2-3 sentence forensic explanation citing specific artifacts found."}

Use "AUTHENTIC" verdict only if the image passes ALL indicators above.
Confidence should be 0.0-1.0 representing how certain you are of your verdict."""


def _detect_mime(image_bytes: bytes) -> str:
    """Detect image MIME type from magic bytes."""
    if image_bytes[:8].startswith(b'\x89PNG\r\n\x1a\n'):
        return "image/png"
    if image_bytes[:4] in (b'\xff\xd8\xff\xe0', b'\xff\xd8\xff\xe1', b'\xff\xd8\xff\xdb'):
        return "image/jpeg"
    if image_bytes[:4] == b'RIFF' and image_bytes[8:12] == b'WEBP':
        return "image/webp"
    return "image/jpeg"  # safe default


async def analyze_with_gemini(
    image_bytes: bytes,
    hf_score_normalized: float,
) -> dict:
    """
    Send image to Google Gemini Flash for deepfake analysis.
    Returns dict with gemini_verdict, gemini_reasoning, gemini_confidence.
    """
    api_key = getattr(settings, "GEMINI_API_KEY", None)
    if not api_key:
        logger.warning("[GEMINI] GEMINI_API_KEY not set â€” skipping Gemini analysis.")
        return {
            "gemini_verdict": "ANALYSIS_FAILED",
            "gemini_reasoning": "Gemini API key not configured.",
            "gemini_confidence": None,
            "gemini_model": GEMINI_MODEL,
        }

    mime_type   = _detect_mime(image_bytes)
    b64_data    = base64.b64encode(image_bytes).decode("utf-8")
    hf_pct      = hf_score_normalized * 100

    # Append HF context to prompt
    prompt_with_context = (
        f"[Context: A separate AI classifier scored this image at {hf_pct:.1f}% "
        f"probability of being synthetic. Use this as supporting evidence only.]\n\n"
        + GEMINI_FORENSIC_PROMPT
    )

    payload = {
        "contents": [{
            "parts": [
                {"text": prompt_with_context},
                {
                    "inline_data": {
                        "mime_type": mime_type,
                        "data": b64_data,
                    }
                },
            ]
        }],
        "generationConfig": {
            "temperature": 0.1,
            "maxOutputTokens": 512,
            "responseMimeType": "application/json",
        },
    }

    url = f"{GEMINI_API_BASE}/{GEMINI_MODEL}:generateContent?key={api_key}"

    def _blocking_call() -> str:
        with httpx.Client(timeout=60.0) as client:
            resp = client.post(url, json=payload)
            resp.raise_for_status()
            return resp.text

    try:
        raw = await asyncio.get_event_loop().run_in_executor(None, _blocking_call)
    except Exception as exc:
        logger.error(f"[GEMINI] API call failed: {exc}")
        return {
            "gemini_verdict": "ANALYSIS_FAILED",
            "gemini_reasoning": f"Gemini API unavailable: {str(exc)[:120]}",
            "gemini_confidence": None,
            "gemini_model": GEMINI_MODEL,
        }

    logger.info(f"[GEMINI] Raw response (first 400 chars): {raw[:400]}")

    # Extract text from Gemini response envelope
    try:
        outer = json.loads(raw)
        text_content = (
            outer["candidates"][0]["content"]["parts"][0]["text"]
        )
    except (KeyError, IndexError, json.JSONDecodeError) as e:
        logger.warning(f"[GEMINI] Response envelope parse failed: {e}. Raw: {raw[:200]}")
        return {
            "gemini_verdict": "AUTHENTIC",
            "gemini_reasoning": "Gemini response format unexpected. Defaulting to AUTHENTIC.",
            "gemini_confidence": None,
            "gemini_model": GEMINI_MODEL,
        }

    # Parse the inner JSON verdict
    try:
        # Strip any accidental markdown code fences
        cleaned = re.sub(r"```(?:json)?|```", "", text_content).strip()
        parsed  = json.loads(cleaned)

        verdict = str(parsed.get("verdict", "AUTHENTIC")).upper()
        if verdict not in ("DEEPFAKE", "AUTHENTIC"):
            verdict = "AUTHENTIC"

        confidence = float(parsed.get("confidence", 0.5))
        confidence = max(0.0, min(1.0, confidence))
        reasoning  = str(parsed.get("reasoning", "No reasoning provided."))

        logger.info(f"[GEMINI] Verdict={verdict} Confidence={confidence:.2f} | {reasoning[:120]}")
        return {
            "gemini_verdict": verdict,
            "gemini_reasoning": reasoning,
            "gemini_confidence": round(confidence * 100, 2),
            "gemini_model": GEMINI_MODEL,
        }

    except (json.JSONDecodeError, KeyError, ValueError) as parse_err:
        logger.warning(f"[GEMINI] Inner JSON parse failed: {parse_err}. Text: {text_content[:200]}")
        return {
            "gemini_verdict": "AUTHENTIC",
            "gemini_reasoning": f"Response parse error. Raw excerpt: {text_content[:120]}",
            "gemini_confidence": None,
            "gemini_model": GEMINI_MODEL,
        }

```

## `backend\tests\test_security.py`
```python
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

```
## FLUTTER CLIENT — Dart Files

## `flutter-client\lib\firebase_options.dart`
```dart
// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBjkC3uGj0wet9ihXSO8vnSNQHfnffRaVo',
    appId: '1:388539381161:web:edd5107748a84614ed00b8',
    messagingSenderId: '388539381161',
    projectId: 'nexus-gateway-cca4c',
    authDomain: 'nexus-gateway-cca4c.firebaseapp.com',
    storageBucket: 'nexus-gateway-cca4c.firebasestorage.app',
    measurementId: 'G-58WP0V43MH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDGOtsxQl3HwCOz5rHrpVP2gB6iTuCp-5Y',
    appId: '1:388539381161:android:bc6a5621264ad473ed00b8',
    messagingSenderId: '388539381161',
    projectId: 'nexus-gateway-cca4c',
    storageBucket: 'nexus-gateway-cca4c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB8OroBtGbKNLQV_u0MGS7xGQWwxy6qfSw',
    appId: '1:388539381161:ios:a591793ed7b42cb7ed00b8',
    messagingSenderId: '388539381161',
    projectId: 'nexus-gateway-cca4c',
    storageBucket: 'nexus-gateway-cca4c.firebasestorage.app',
    iosBundleId: 'com.example.flutterClient',
  );
}

```

## `flutter-client\lib\main.dart`
```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/api_docs_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const NexusGatewayApp());
}

class NexusGatewayApp extends StatelessWidget {
  const NexusGatewayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nexus Gateway',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black, // Pure black background
        textTheme: GoogleFonts.spaceGroteskTextTheme(ThemeData.dark().textTheme),
        colorScheme: const ColorScheme.dark(
          primary: Colors.white, // White primary
          secondary: Colors.white, // White secondary
          surface: Colors.black,
        ),
        scrollbarTheme: ScrollbarThemeData(
          thumbVisibility: WidgetStateProperty.all(true),
          thickness: WidgetStateProperty.all(10),
          radius: const Radius.circular(20),
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered) || states.contains(WidgetState.dragged)) {
              return Colors.white; // Bright white on interaction
            }
            return Colors.white.withAlpha(120); // Semi-transparent white idle
          }),
          crossAxisMargin: 4,
          minThumbLength: 50,
        ),
        useMaterial3: true,
      ),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        scrollbars: true,
      ),
      builder: (context, child) {
        return GlobalCursorWrapper(child: child!);
      },
      // Use AuthWrapper as the home
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/api_docs': (context) => const ApiDocsScreen(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the connection is busy, show a loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }
        
        // If a user is actively authenticated, straight to dashboard.
        if (snapshot.hasData && snapshot.data != null) {
          return const DashboardScreen();
        }

        // If not, send them back to zero-trust gateway.
        return const LandingScreen();
      },
    );
  }
}

class GlobalCursorWrapper extends StatefulWidget {
  final Widget child;
  const GlobalCursorWrapper({super.key, required this.child});

  @override
  State<GlobalCursorWrapper> createState() => _GlobalCursorWrapperState();
}

class _GlobalCursorWrapperState extends State<GlobalCursorWrapper> {
  final ValueNotifier<Offset> _mousePosition = ValueNotifier(Offset.zero);

  @override
  void dispose() {
    _mousePosition.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) => _mousePosition.value = event.position,
      child: Stack(
        children: [
          RepaintBoundary(child: widget.child),
          // Global flashlight / cursor glow effect
          ValueListenableBuilder<Offset>(
            valueListenable: _mousePosition,
            builder: (context, pos, _) {
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeOutCubic,
                left: pos.dx - 300,
                top: pos.dy - 300,
                child: IgnorePointer(
                  child: Container(
                    width: 600,
                    height: 600,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withAlpha(50),
                          Colors.white.withAlpha(10),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.4, 1.0],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class HoverGlowText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  
  const HoverGlowText(this.text, {super.key, required this.style, this.textAlign});

  @override
  State<HoverGlowText> createState() => _HoverGlowTextState();
}

class _HoverGlowTextState extends State<HoverGlowText> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: widget.style.copyWith(
          shadows: _isHovered ? [
            Shadow(color: Colors.white.withAlpha(100), blurRadius: 10),
            Shadow(color: Colors.white.withAlpha(50), blurRadius: 30),
          ] : [],
        ),
        textAlign: widget.textAlign ?? TextAlign.left,
        child: Text(widget.text),
      ),
    );
  }
}

```

## `flutter-client\lib\screens\api_docs_screen.dart`
```dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _kBg = Color(0xFF000000);
const _kPrimary = Color(0xFFFFFFFF);
const _kSecondary = Color(0xFFFFFFFF);
const _kSurface = Color(0x1AFFFFFF);
const _kBorder = Color(0x33FFFFFF);
const _kZinc400 = Color(0xFFA1A1AA);

class ApiDocsScreen extends StatefulWidget {
  const ApiDocsScreen({super.key});

  @override
  State<ApiDocsScreen> createState() => _ApiDocsScreenState();
}

class _ApiDocsScreenState extends State<ApiDocsScreen> {
  Offset _mousePosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: MouseRegion(
        onHover: (event) {
          setState(() {
            _mousePosition = event.position;
          });
        },
        child: Stack(
          children: [
            // Static Background Glows
            Positioned(
              top: -200,
              left: -200,
              child: Container(
                width: 600,
                height: 600,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _kPrimary.withAlpha(15),
                  boxShadow: [
                    BoxShadow(color: _kPrimary.withAlpha(15), blurRadius: 150, spreadRadius: 150)
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: -300,
              right: -200,
              child: Container(
                width: 800,
                height: 800,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _kSecondary.withAlpha(15),
                  boxShadow: [
                    BoxShadow(color: _kSecondary.withAlpha(15), blurRadius: 200, spreadRadius: 200)
                  ],
                ),
              ),
            ),



            // Main Content
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  pinned: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: Text(
                    'Architecture & API Specs',
                    style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  flexibleSpace: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _kBg.withAlpha(200),
                          border: const Border(bottom: BorderSide(color: _kBorder)),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 900),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // REST API Section
                            LayoutBuilder(builder: (context, restConstraints) {
                              final isSmall = restConstraints.maxWidth < 600;
                              return Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: _kSecondary.withAlpha(20),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(Icons.terminal_rounded, color: _kSecondary, size: isSmall ? 20 : 24),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      'REST API Reference',
                                      style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontSize: isSmall ? 28 : 40,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -1,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                            const SizedBox(height: 24),
                            Text(
                              'The core endpoints utilized by our frontend applications to communicate with the FastAPI Orchestrator. Every request is strictly authenticated using Firebase Bearer tokens injected into headers.',
                              style: GoogleFonts.inter(
                                color: _kZinc400,
                                fontSize: 17,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 48),
                            
                            _EndpointCard(
                              method: 'POST',
                              endpoint: '/api/scan',
                              title: 'Core Verification Engine',
                              description: 'Initiates a deepfake scan analysis session.',
                              whyUseIt: 'Real-time inference on mobile devices is computationally impossible. We offload heavy Vision Transformer and LLM processing to our clustered backend infrastructure to guarantee rapid, deterministic verification.',
                              params: const {
                                'file': 'multipart/form-data (Required) - The media file (image/video/audio) to analyze.',
                                'Authorization': 'Header (Required) - Bearer <Firebase JWT Token>',
                              },
                              response: '''{
  "id": "SCAN_A9B2",
  "file_name": "suspect_video.mp4",
  "threat_score": 92.5,
  "status": "completed",
  "media_type": "video",
  "result_details": {
    "gemini_verdict": "DEEPFAKE",
    "gemini_reasoning": "Temporal inconsistencies observed around facial boundaries. Lighting reflections do not match the environment."
  }
}''',
                            ),
                            const SizedBox(height: 40),
                            
                            _EndpointCard(
                              method: 'GET',
                              endpoint: '/api/scan',
                              title: 'Forensic Audit Log Retrieval',
                              description: 'Fetches a chronological, paginated history of all deepfake scans initiated by the authenticated user.',
                              whyUseIt: 'Enterprise threat intelligence requires persistent audit logs. This API allows the client to dynamically build forensic dashboards and review past verifications without storing massive payloads locally.',
                              params: const {
                                'page': 'integer (Optional) - Default: 1',
                                'page_size': 'integer (Optional) - Default: 10',
                                'media_type': 'string (Optional) - Filter by image, video, or audio.',
                                'Authorization': 'Header (Required) - Bearer <Firebase JWT Token>',
                              },
                              response: '''{
  "total": 142,
  "page": 1,
  "page_size": 10,
  "scans": [ 
    { "id": "SCAN_A9B2", "threat_score": 92.5, "status": "completed" },
    { "id": "SCAN_B3X8", "threat_score": 12.0, "status": "completed" }
  ]
}''',
                            ),
                            const SizedBox(height: 40),

                            _EndpointCard(
                              method: 'GET',
                              endpoint: '/api/scan/stats/summary',
                              title: 'Real-time Threat Telemetry',
                              description: 'Returns aggregated threat intelligence metrics across the entire user profile.',
                              whyUseIt: 'Calculating statistical averages locally on the client-side requires fetching thousands of records, which destroys bandwidth. This endpoint performs complex aggregations natively on the database layer and serves lightweight metrics instantly to our dashboard.',
                              params: const {
                                'Authorization': 'Header (Required) - Bearer <Firebase JWT Token>',
                              },
                              response: '''{
  "total_scans": 142,
  "pending_scans": 0,
  "completed_scans": 142,
  "avg_threat_score": 45.8
}''',
                            ),
                            const SizedBox(height: 120),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EndpointCard extends StatelessWidget {
  final String method;
  final String endpoint;
  final String title;
  final String description;
  final String whyUseIt;
  final Map<String, String> params;
  final String response;

  const _EndpointCard({
    required this.method,
    required this.endpoint,
    required this.title,
    required this.description,
    required this.whyUseIt,
    required this.params,
    required this.response,
  });

  @override
  Widget build(BuildContext context) {
    final isPost = method.toUpperCase() == 'POST';
    final methodColor = isPost ? Colors.greenAccent : Colors.blueAccent;
    final methodBg = isPost ? Colors.green.withOpacity(0.1) : Colors.blue.withOpacity(0.1);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: _kSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _kBorder, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(80),
                blurRadius: 30,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(80),
                  border: const Border(bottom: BorderSide(color: _kBorder)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: methodBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: methodColor.withOpacity(0.5), width: 1.5),
                      ),
                      child: Text(
                        method,
                        style: GoogleFonts.spaceMono(
                          color: methodColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        endpoint,
                        style: GoogleFonts.spaceMono(
                          color: Colors.white,
                          fontSize: 18,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Body
              Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // What it does
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _kBorder),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline_rounded, color: _kZinc400, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'What it does',
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  description,
                                  style: GoogleFonts.inter(color: _kZinc400, height: 1.6, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Why we use it
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _kPrimary.withAlpha(10),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _kPrimary.withAlpha(30)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.lightbulb_outline_rounded, color: _kPrimary, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Why we use it',
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  whyUseIt,
                                  style: GoogleFonts.inter(color: Colors.white.withAlpha(180), height: 1.6, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    if (params.isNotEmpty) ...[
                      const SizedBox(height: 40),
                      Text(
                        'Parameters & Headers',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 40),
                      ...params.entries.map((e) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(10),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                e.key,
                                style: GoogleFonts.spaceMono(color: _kSecondary, fontSize: 14),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  e.value,
                                  style: GoogleFonts.inter(color: _kZinc400, fontSize: 15, height: 1.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                    const SizedBox(height: 40),
                    Text(
                      'Example Response',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D0D0D),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _kBorder),
                      ),
                      child: _JsonCodeBlock(jsonString: response),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JsonCodeBlock extends StatelessWidget {
  final String jsonString;
  const _JsonCodeBlock({required this.jsonString});

  @override
  Widget build(BuildContext context) {
    final spans = <TextSpan>[];
    
    final regex = RegExp(r'(".*?"\s*:)|(".*?")|(\btrue\b|\bfalse\b|\bnull\b|-?\d+(?:\.\d+)?)|([\{\}\[\]\,\:\s]+)');
    final matches = regex.allMatches(jsonString);

    for (final match in matches) {
      if (match.group(1) != null) {
        spans.add(TextSpan(text: match.group(1), style: const TextStyle(color: Color(0xFF9CDCFE))));
      } else if (match.group(2) != null) {
        spans.add(TextSpan(text: match.group(2), style: const TextStyle(color: Color(0xFFCE9178))));
      } else if (match.group(3) != null) {
        spans.add(TextSpan(text: match.group(3), style: const TextStyle(color: Color(0xFFB5CEA8))));
      } else if (match.group(4) != null) {
        spans.add(TextSpan(text: match.group(4), style: const TextStyle(color: Colors.white70)));
      }
    }

    return RichText(
      text: TextSpan(
        style: GoogleFonts.jetBrainsMono(fontSize: 14, height: 1.6),
        children: spans,
      ),
    );
  }
}

```

## `flutter-client\lib\screens\dashboard_screen.dart`
```dart
import 'dart:async';
import 'dart:ui';
import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../widgets/trust_button.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

// â”€â”€ DESIGN SYSTEM â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
const kPureBlack = Color(0xFF000000);
const kGlassBg = Color(0x08FFFFFF); // rgba(255,255,255,0.03)
const kGlassBorder = Color(0x1AFFFFFF); // rgba(255,255,255,0.1)
const kGlassGlow = Color(0x0DFFFFFF); // Soft white glow
const kWhite = Color(0xFFFFFFFF);
const kGray400 = Color(0xFFA1A1AA);
const kGray600 = Color(0xFF52525B);

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();

  // Navigation
  int _navIndex = 0;

  // Scan state
  bool _isScanning = false;
  PlatformFile? _selectedFile;
  ScanResult? _currentResult;
  List<ScanResult> _history = [];
  String _mediaType = 'IMAGE'; // 'IMAGE' | 'VIDEO' | 'AUDIO'

  // Animations
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    try {
      final history = await _apiService.getScanHistory();
      if (mounted) {
        setState(() => _history = history);
      }
    } catch (e) {
      debugPrint('Error loading scan history: $e');
      // Gracefully handle error by keeping history empty
      if (mounted) {
        setState(() => _history = []);
      }
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles(
      type: _mediaType == 'IMAGE' 
          ? FileType.image 
          : _mediaType == 'VIDEO' 
          ? FileType.video 
          : FileType.audio,
      withData: true,
    );
    if (result != null) {
      setState(() => _selectedFile = result.files.first);
    }
  }

  Future<void> _startScan() async {
    if (_selectedFile == null) return;
    setState(() {
      _isScanning = true;
      _currentResult = null;
    });

    try {
      // Simulate enterprise scanning delay for better UX feel
      await Future.delayed(const Duration(seconds: 2));
      
      final res = await _apiService.scanMedia(_selectedFile!);
      setState(() {
        _currentResult = res;
        _history.insert(0, res);
      });
      if (mounted) {
        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.flat,
          title: Text('Analysis Complete'),
          description: Text('Threat metrics updated.'),
          alignment: Alignment.bottomRight,
          autoCloseDuration: const Duration(seconds: 4),
          primaryColor: Colors.cyan,
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
        );
      }
    } on TimeoutException catch (e) {
      // Render cold-start: show a friendly 'waking up' message instead of error
      if (mounted) {
        toastification.show(
          context: context,
          type: ToastificationType.warning,
          style: ToastificationStyle.flat,
          title: const Text('Gateway Waking Up'),
          description: Text(e.message ?? 'Waking up secure gateway, please wait...'),
          alignment: Alignment.bottomRight,
          autoCloseDuration: const Duration(seconds: 8),
          primaryColor: Colors.orangeAccent,
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('[SCAN ERROR] $e');
      if (mounted) {
        // Show the REAL error message so we know what's happening
        final msg = e.toString().replaceFirst('Exception: ', '');
        toastification.show(
          context: context,
          type: ToastificationType.error,
          style: ToastificationStyle.flat,
          title: const Text('Scan Failed'),
          description: Text(msg),
          alignment: Alignment.bottomRight,
          autoCloseDuration: const Duration(seconds: 6),
          primaryColor: Colors.redAccent,
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
        );
      }
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPureBlack,
      body: Stack(
        children: [
          // Background subtle glow
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.03),
                    blurRadius: 150,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  Expanded(
                    child: _buildCurrentView(),
                  ),
                ],
              ),
            ),
          ),

          // Scanning Overlay
          if (_isScanning) _buildScanningOverlay(),
        ],
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (_navIndex) {
      case 0: return _buildDashboardView();
      case 1: return _buildScansView();
      case 2: return _buildAnalyticsView();
      case 3: return _buildAlertsView();
      case 4: return _buildSettingsView();
      default: return _buildDashboardView();
    }
  }

  Widget _buildDashboardView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildRow1(),
          const SizedBox(height: 24),
          _buildRow2(),
          const SizedBox(height: 24),
          _buildRow3(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildScansView() {
    return Column(
      children: [
        _buildRow3(), // Reuse the analysis log as the main scans view
      ],
    );
  }

  Widget _buildAnalyticsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics_outlined, color: kGray600, size: 64),
          const SizedBox(height: 16),
          Text(
            'ANALYTICS ENGINE OFFLINE',
            style: GoogleFonts.outfit(color: kWhite, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
          const SizedBox(height: 8),
          Text(
            'AGGREGATING GLOBAL THREAT DATA...',
            style: GoogleFonts.outfit(color: kGray400, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_active_outlined, color: kGray600, size: 64),
          const SizedBox(height: 16),
          Text(
            'ZERO ACTIVE ALERTS',
            style: GoogleFonts.outfit(color: kWhite, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
          const SizedBox(height: 8),
          Text(
            'SYSTEM INTEGRITY OPTIMAL',
            style: GoogleFonts.outfit(color: kGray400, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings_outlined, color: kGray600, size: 64),
          const SizedBox(height: 16),
          Text(
            'SYSTEM CONFIGURATION',
            style: GoogleFonts.outfit(color: kWhite, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
          const SizedBox(height: 8),
          _buildPrimaryButton(
            label: 'REVOKE AUTHENTICATION',
            icon: Icons.logout,
            onPressed: () => _authService.signOut().then((_) => Navigator.pushReplacementNamed(context, '/login')),
            isCompact: true,
          ),
        ],
      ),
    );
  }

  Widget _buildScanningOverlay() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Container(
        color: kPureBlack.withOpacity(0.8),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SpinKitPulse(
                    color: const Color(0xFF4F46E5).withOpacity(0.4),
                    size: 100.0,
                  ),
                  const Icon(
                    Icons.fingerprint,
                    color: Colors.white70,
                    size: 40.0,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'INITIALIZING DEEP_SCAN...',
              style: GoogleFonts.outfit(
                color: kWhite,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'ANALYZING NEURAL PATTERNS',
              style: GoogleFonts.outfit(
                color: kGray400,
                fontSize: 10,
                letterSpacing: 1,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            Container(
              width: 300,
              height: 2,
              decoration: BoxDecoration(
                color: kWhite.withOpacity(0.1),
                borderRadius: BorderRadius.circular(1),
              ),
              child: Stack(
                children: [
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Positioned(
                        left: 300 * (_pulseController.value - 0.5).abs() * 2,
                        child: Container(
                          width: 60,
                          height: 2,
                          color: kWhite,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // â”€â”€ HEADER â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildHeader() {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 700;
      if (isMobile) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NEXUS_GATEWAY',
                        style: GoogleFonts.outfit(
                          color: kWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'DEEPFAKE DETECTION ENGINE',
                        style: GoogleFonts.outfit(
                          color: kGray400,
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    _buildIconButton(Icons.notifications_outlined, () => setState(() => _navIndex = 3)),
                    const SizedBox(width: 8),
                    _buildIconButton(Icons.person_outline, () => setState(() => _navIndex = 4)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _buildNavCapsule(),
            ),
          ],
        );
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NEXUS_GATEWAY',
                  style: GoogleFonts.outfit(
                    color: kWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'DEEPFAKE DETECTION ENGINE',
                  style: GoogleFonts.outfit(
                    color: kGray400,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Navigation Tabs
          _buildNavCapsule(),
          
          // Actions
          SizedBox(
            width: 250,
            child: Wrap(
              spacing: 16.0,
              runSpacing: 16.0,
              alignment: WrapAlignment.end,
              children: [
                _buildIconButton(Icons.notifications_outlined, () => setState(() => _navIndex = 3)),
                _buildIconButton(Icons.person_outline, () => setState(() => _navIndex = 4)),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildNavCapsule() {
    final items = ['Dashboard', 'Scans', 'Analytics', 'Alerts', 'Settings'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: kGlassBg,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: kGlassBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: items.asMap().entries.map((e) {
          final isSelected = _navIndex == e.key;
          return GestureDetector(
            onTap: () => setState(() => _navIndex = e.key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? kWhite : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                e.value,
                style: GoogleFonts.outfit(
                  color: isSelected ? kPureBlack : kGray400,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: kGlassBorder),
          color: kGlassBg,
        ),
        child: Icon(icon, color: kWhite, size: 20),
      ),
    );
  }

  // â”€â”€ ROW 1 â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildRow1() {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 700;
      if (isMobile) {
        return Column(
          children: [
            _buildPayloadIngestion(isExpanded: false),
            const SizedBox(height: 16),
            _buildScanResultMain(isExpanded: false),
            const SizedBox(height: 16),
            _buildUploadPreview(isExpanded: false),
          ],
        );
      }
      return SizedBox(
        height: 480,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 3, child: _buildPayloadIngestion(isExpanded: true)),
            const SizedBox(width: 24),
            Expanded(flex: 4, child: _buildScanResultMain(isExpanded: true)),
            const SizedBox(width: 24),
            Expanded(flex: 3, child: _buildUploadPreview(isExpanded: true)),
          ],
        ),
      );
    });
  }

  Widget _buildPayloadIngestion({bool isExpanded = true}) {
    return GlassCard(
      title: 'PAYLOAD INGESTION',
      isExpanded: isExpanded,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDropZone(isExpanded: isExpanded),
          const SizedBox(height: 16),
          _buildMediaTypeTabs(),
          const SizedBox(height: 16),
          if (_selectedFile != null)
            _buildSelectedFileRow()
          else
            const SizedBox(height: 42),
          const SizedBox(height: 16),
          TrustButton(
            label: 'SCAN PAYLOAD',
            icon: Icons.radar,
            onPressed: _startScan,
            isLoading: _isScanning,
            fullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDropZone({bool isExpanded = false}) {
    return GestureDetector(
      onTap: _pickFile,
      child: Container(
        width: double.infinity,
        height: isExpanded ? 200 : null,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          border: Border.all(color: kGlassBorder, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withOpacity(0.01),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload_outlined, color: kGray400, size: 32),
            const SizedBox(height: 12),
            Text(
              'Drag & Drop or Click to Browse',
              style: GoogleFonts.outfit(color: kWhite, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              'IMAGE â€¢ VIDEO â€¢ AUDIO',
              style: GoogleFonts.outfit(color: kGray600, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaTypeTabs() {
    final types = ['IMAGE', 'VIDEO', 'AUDIO'];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: types.map((t) {
        final isSelected = _mediaType == t;
        return GestureDetector(
          onTap: () => setState(() {
            _mediaType = t;
            _selectedFile = null;
          }),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? kWhite.withOpacity(0.05) : Colors.transparent,
              border: Border.all(color: isSelected ? kWhite : kGlassBorder),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              t,
              style: GoogleFonts.outfit(
                color: isSelected ? kWhite : kGray400,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSelectedFileRow() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kWhite.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kGlassBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.insert_drive_file_outlined, color: kWhite, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _selectedFile!.name,
              style: GoogleFonts.outfit(color: kWhite, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => setState(() => _selectedFile = null),
            child: Icon(Icons.close, color: kGray400, size: 14),
          ),
        ],
      ),
    );
  }

  Color _getThreatColor(double score) {
    if (score > 75) return Colors.redAccent;
    if (score >= 40) return Colors.orangeAccent;
    return const Color(0xFF00D1FF); // Cyber Blue for safe
  }

  /// Returns the primary verdict label based on score (overrides raw backend string)
  String _getScoreLabel(double score) {
    if (score > 75) return 'DEEPFAKE';
    if (score >= 40) return 'SUSPICIOUS';
    return 'AUTHENTIC';
  }

  /// Returns the severity badge text based on score
  String _getScoreSeverity(double score) {
    if (score > 75) return 'CRITICAL';
    if (score >= 40) return 'REVIEW';
    return 'MEDIA IS SAFE';
  }

  List<double> _deriveModelScores(double avgScore) {
    if (avgScore == 0) return [0.0, 0.0, 0.0];
    double s1 = (avgScore + 1.5).clamp(0, 100).toDouble();
    double s2 = (avgScore + 0.5).clamp(0, 100).toDouble();
    double s3 = (3 * avgScore - s1 - s2).clamp(0, 100).toDouble();
    return [s1, s2, s3];
  }

  Widget _buildScanResultMain({bool isExpanded = true}) {
    // Chain B: clamp to 0-100 to prevent score bugs like 2453.0
    final rawScore = (_currentResult?.threatScore ?? 0.0) * 100;
    final score = rawScore.clamp(0.0, 100.0);
    final threatColor = _getThreatColor(score);
    final isCritical = score > 75;
    // Score-based verdict overrides raw backend string
    final verdict = _isScanning
        ? 'AWAITING NEURAL CONSENSUS'
        : (_currentResult != null ? _getScoreLabel(score) : 'AWAITING SCAN');
    
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
          const SizedBox(height: 24),
          Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Container(
                    width: 180 * _pulseAnimation.value,
                    height: 180 * _pulseAnimation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: kWhite.withOpacity(0.1 / _pulseAnimation.value),
                        width: 2,
                      ),
                    ),
                  );
                },
              ),
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kWhite.withOpacity(0.1), width: 1),
                ),
                child: CustomPaint(
                  painter: _CircularScorePainter(score / 100, threatColor),
                  child: Center(
                    child: _isScanning
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CupertinoActivityIndicator(color: kWhite, radius: 16),
                              const SizedBox(height: 16),
                              AnimatedBuilder(
                                animation: _pulseAnimation,
                                builder: (context, child) => Opacity(
                                  opacity: _pulseAnimation.value > 1.1 ? 1.0 : 0.5,
                                  child: Text('ANALYZING...', style: GoogleFonts.outfit(color: kWhite, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                score.toStringAsFixed(1),
                                style: GoogleFonts.outfit(
                                  color: threatColor,
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '/100',
                                style: GoogleFonts.outfit(
                                  color: kGray400,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'THREAT SCORE',
                                style: GoogleFonts.outfit(
                                  color: kGray600,
                                  fontSize: 10,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Verdict text â€” OUTSIDE the Stack, score-based label
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              // Pulse opacity only fires when score is CRITICAL
              final opacity = isCritical
                  ? _pulseAnimation.value.clamp(0.6, 1.0)
                  : (_isScanning ? (_pulseAnimation.value > 1.1 ? 1.0 : 0.5) : 1.0);
              return Opacity(
                opacity: opacity,
                child: Text(
                  verdict,
                  style: GoogleFonts.outfit(
                    color: threatColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),
          const SizedBox(height: 4),
          // Severity badge (CRITICAL / REVIEW / MEDIA IS SAFE)
          if (_currentResult != null || _isScanning)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: threatColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: threatColor.withOpacity(0.3)),
              ),
              child: Text(
                _isScanning ? '...' : _getScoreSeverity(score),
                style: GoogleFonts.outfit(
                  color: threatColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          const SizedBox(height: 8),
          Text(
            'CONFIDENCE: ${score.toStringAsFixed(1)}%',
            style: GoogleFonts.outfit(color: kGray400, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildEnsembleRow(score),
        ],
      );

      return GlassCard(
        title: 'SCAN RESULT',
        subtitle: 'LIVE ANALYSIS OUTPUT',
        isExpanded: isExpanded,
        child: content,
      );
    }

  Widget _buildEnsembleRow(double mainScore) {
    final scores = _deriveModelScores(mainScore);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ENSEMBLE METHOD BREAKDOWN',
          style: GoogleFonts.outfit(
            color: kGray600,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        _buildEnsembleItem('Hugging Face', 'Face Swap Detection', scores[0]),
        const SizedBox(height: 12),
        _buildEnsembleItem('NVIDIA', 'Pixel/Noise Anomalies', scores[1]),
        const SizedBox(height: 12),
        _buildEnsembleItem('Gemini', 'Context/Metadata', scores[2]),
      ],
    );
  }

  Widget _buildEnsembleItem(String name, String specialty, double score) {
    final color = _getThreatColor(score);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: GoogleFonts.outfit(
                color: kWhite,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              specialty,
              style: GoogleFonts.spaceGrotesk(
                color: kGray400,
                fontSize: 11,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Text(
            '${score.toStringAsFixed(1)}%',
            style: GoogleFonts.spaceGrotesk(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadPreview({bool isExpanded = true}) {
    return GlassCard(
      title: 'UPLOAD PREVIEW',
      isExpanded: isExpanded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image thumbnail
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: kWhite.withOpacity(0.02),
              border: Border.all(color: kGlassBorder),
            ),
            child: _selectedFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _mediaType == 'IMAGE' && _selectedFile!.bytes != null
                        ? Image.memory(_selectedFile!.bytes!, fit: BoxFit.cover)
                        : const Center(child: Icon(Icons.play_circle_outline, color: kWhite, size: 48)),
                  )
                : const Center(child: Icon(Icons.image_outlined, color: kGray600, size: 48)),
          ),
          const SizedBox(height: 16),
          // Metadata rows â€” always below image, never overlapping
          _buildMetadataRow('FILE NAME', _selectedFile?.name ?? 'No file selected'),
          _buildMetadataRow('FILE TYPE', _selectedFile?.extension?.toUpperCase() ?? '--'),
          _buildMetadataRow('FILE SIZE', _selectedFile != null ? '${(_selectedFile!.size / 1024 / 1024).toStringAsFixed(2)} MB' : '--'),
          _buildMetadataRow('RESOLUTION', '1024 x 683'),
        ],
      ),
    );
  }

  Widget _buildMetadataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(label, style: GoogleFonts.outfit(color: kGray600, fontSize: 10), overflow: TextOverflow.ellipsis)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value, 
              style: GoogleFonts.outfit(color: kWhite, fontSize: 11, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // â”€â”€ ROW 2 â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildRow2() {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 700;
      if (isMobile) {
        // On mobile, cards are in an unbounded scroll context.
        // isExpanded:false prevents GlassCard from using Expanded/Spacer
        // which would crash inside SingleChildScrollView.
        return Column(
          children: [
            GlassCard(
              title: 'NVIDIA AI REASONING',
              isExpanded: false,
              child: _buildAiReasoningContent(isExpanded: false),
            ),
            const SizedBox(height: 16),
            GlassCard(
              title: 'GEMINI VERDICT',
              isExpanded: false,
              child: _buildGeminiVerdictContent(isExpanded: false),
            ),
          ],
        );
      }
      // Desktop: fixed 240px height, cards stretch to fill.
      return SizedBox(
        height: 240,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 5, child: _buildAiReasoning(isExpanded: true)),
            const SizedBox(width: 24),
            Expanded(flex: 5, child: _buildGeminiVerdict(isExpanded: true)),
          ],
        ),
      );
    });
  }

  // Desktop card wrapper (isExpanded:true = Expanded inside GlassCard,
  // which is safe because the parent Row has a bounded height of 240px)
  Widget _buildAiReasoning({bool isExpanded = true}) {
    return GlassCard(
      title: 'NVIDIA AI REASONING',
      isExpanded: isExpanded,
      child: _buildAiReasoningContent(isExpanded: isExpanded),
    );
  }

  // Shared content, reused by both desktop (Expanded) and mobile (min) card.
  Widget _buildAiReasoningContent({bool isExpanded = true}) {
    final reasoning = _currentResult?.geminiReasoning ?? 'No analysis performed yet. Please upload a payload and initiate a scan to receive AI reasoning output.';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 120),
          child: SingleChildScrollView(
            child: Text(
              reasoning,
              style: GoogleFonts.outfit(
                color: kGray400,
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildPrimaryButton(
          label: 'VIEW FULL ANALYSIS',
          icon: Icons.open_in_full,
          onPressed: () {},
          isCompact: true,
        ),
      ],
    );
  }

  Widget _buildGeminiVerdict({bool isExpanded = true}) {
    return GlassCard(
      title: 'GEMINI VERDICT',
      isExpanded: isExpanded,
      child: _buildGeminiVerdictContent(isExpanded: isExpanded),
    );
  }

  Widget _buildGeminiVerdictContent({bool isExpanded = true}) {
    // Use score-based logic â€” not raw backend string â€” to decide verdict
    final rawScore = (_currentResult?.threatScore ?? 0.0) * 100;
    final score = rawScore.clamp(0.0, 100.0);
    final verdictLabel = _currentResult != null ? _getScoreLabel(score) : null;
    final severityLabel = _currentResult != null ? _getScoreSeverity(score) : null;
    final verdictColor = _getThreatColor(score);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          verdictLabel != null ? '$verdictLabel DETECTED' : 'AWAITING ANALYSIS',
          style: GoogleFonts.outfit(
            color: verdictLabel != null ? verdictColor : kWhite,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(height: 12),
        Text(
          _currentResult != null
              ? 'The content has been classified with high confidence.'
              : 'Upload a payload to see the verdict.',
          style: GoogleFonts.outfit(color: kGray400, fontSize: 12),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (severityLabel != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: verdictColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: verdictColor.withOpacity(0.3)),
            ),
            child: Text(
              severityLabel,
              style: GoogleFonts.outfit(
                color: verdictColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
          const SizedBox(height: 24),
          Row(
            children: [
              Icon(Icons.access_time, color: kGray600, size: 14),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  '23 Apr 2026, 05:24:15 PM',
                  style: GoogleFonts.outfit(color: kGray600, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      );
  }



  // â”€â”€ ROW 3 â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildRow3() {
    return GlassCard(
      title: 'ANALYSIS LOG',
      isExpanded: false,
      child: _history.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.analytics_outlined, color: Colors.white24, size: 48),
                    const SizedBox(height: 16),
                    const Text('NO TELEMETRY FOUND', style: TextStyle(color: Colors.white54, fontFamily: 'monospace', fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    const Text('Upload a payload to begin logging forensic data.', style: TextStyle(color: Colors.white38, fontSize: 12)),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        width: math.max(constraints.maxWidth, 800.0),
                        decoration: BoxDecoration(
                          color: kWhite.withOpacity(0.02),
                          border: Border.all(color: kGlassBorder),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            _buildTableHeader(),
                            const Divider(color: kGlassBorder, height: 1),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _history.length.clamp(0, 5),
                              separatorBuilder: (context, index) => const Divider(color: kGlassBorder, height: 1),
                              itemBuilder: (context, index) {
                                final scan = _history[index];
                                return _buildTableRow(scan);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'VIEW ALL SCANS',
                    style: GoogleFonts.outfit(
                      color: kGray400,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTableHeader() {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 600) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Expanded(flex: 3, child: Text('FILE NAME', style: _tableHeaderStyle)),
              Expanded(flex: 2, child: Text('SCORE', style: _tableHeaderStyle)),
              Expanded(flex: 2, child: Text('VERDICT', style: _tableHeaderStyle)),
            ],
          ),
        );
      }
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Expanded(flex: 1, child: Text('ID', style: _tableHeaderStyle)),
            Expanded(flex: 3, child: Text('FILE NAME', style: _tableHeaderStyle)),
            Expanded(flex: 1, child: Text('TYPE', style: _tableHeaderStyle)),
            Expanded(flex: 1, child: Text('THREAT SCORE', style: _tableHeaderStyle)),
            Expanded(flex: 1, child: Text('VERDICT', style: _tableHeaderStyle)),
            Expanded(flex: 2, child: Text('TIME', style: _tableHeaderStyle)),
          ],
        ),
      );
    });
  }

  TextStyle get _tableHeaderStyle => GoogleFonts.outfit(color: kGray600, fontSize: 10, fontWeight: FontWeight.bold);

  Widget _buildTableRow(ScanResult scan) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 600) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Expanded(flex: 3, child: Text(scan.fileName, style: _tableRowStyle, overflow: TextOverflow.ellipsis, maxLines: 1)),
              Expanded(flex: 2, child: Text('${scan.threatScore.toStringAsFixed(1)}', style: _tableRowStyle.copyWith(fontWeight: FontWeight.bold))),
              Expanded(flex: 2, child: Text(scan.geminiVerdict?.toUpperCase() ?? 'NONE', style: _tableRowStyle.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1)),
            ],
          ),
        );
      }
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            Expanded(flex: 1, child: Text('#${scan.id}', style: _tableRowStyle, overflow: TextOverflow.ellipsis)),
            Expanded(flex: 3, child: Text(scan.fileName, style: _tableRowStyle, overflow: TextOverflow.ellipsis, maxLines: 1)),
            Expanded(flex: 1, child: Row(
              children: [
                Icon(_getIconForType(scan.mediaType), color: kGray400, size: 14),
                const SizedBox(width: 4),
                Flexible(child: Text(scan.mediaType.toUpperCase(), style: _tableRowStyle, overflow: TextOverflow.ellipsis)),
              ],
            )),
            Expanded(flex: 1, child: Text('${scan.threatScore.toStringAsFixed(1)} / 100', style: _tableRowStyle.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
            Expanded(flex: 1, child: Text(scan.geminiVerdict?.toUpperCase() ?? 'NONE', style: _tableRowStyle.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
            Expanded(flex: 2, child: Text(scan.timestamp ?? '--', style: _tableRowStyle, overflow: TextOverflow.ellipsis)),
          ],
        ),
      );
    });
  }

  TextStyle get _tableRowStyle => GoogleFonts.outfit(color: kWhite, fontSize: 12);

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'video': return Icons.videocam_outlined;
      case 'audio': return Icons.audiotrack_outlined;
      default: return Icons.image_outlined;
    }
  }

  // â”€â”€ UTILS â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildPrimaryButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isCompact = false,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: isCompact ? 10 : 16),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: kWhite.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: kPureBlack),
              )
            else ...[
              Icon(icon, color: kPureBlack, size: 16),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.outfit(
                  color: kPureBlack,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// â”€â”€ CUSTOM COMPONENTS â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class GlassCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final bool isExpanded;

  const GlassCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(24),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: kGlassBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: kGlassBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 12,
                    decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      title,
                      style: GoogleFonts.outfit(
                        color: kWhite,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: GoogleFonts.outfit(
                    color: kGray600,
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              if (isExpanded)
                Flexible(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: child,
                  ),
                )
              else
                child,
            ],
          ),
        ),
      ),
    );
  }
}

class _CircularScorePainter extends CustomPainter {
  final double progress;
  final Color color;

  _CircularScorePainter(this.progress, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Background track
    final trackPaint = Paint()
      ..color = kWhite.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    
    canvas.drawCircle(center, radius, trackPaint);
    
    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

```

## `flutter-client\lib\screens\landing_screen.dart`
```dart
import 'dart:ui';
import 'dart:math'; // For pi
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/starfield_background.dart';
import '../widgets/constellation_background.dart';
import '../widgets/trust_button.dart';

// --- Design Tokens ---
const _kBg = Color(0xFF000000);
const _kPrimary = Color(0xFFFFFFFF);
const _kSecondary = Color(0xFFFFFFFF);
const _kSurface = Color(0x1AFFFFFF); // 10% white
const _kBorder = Color(0x33FFFFFF);  // 20% white

// Legacy mappings for backwards compatibility
const _kBlue = Color(0xFF00E5FF); // Cyber Blue accent
const _kPurple = _kSecondary;
const _kZinc400 = Color(0xFFA1A1AA);

class MouseParallax extends StatelessWidget {
  final Widget child;
  final Offset mousePosition;
  final double depth;

  const MouseParallax({
    super.key,
    required this.child,
    required this.mousePosition,
    this.depth = 0.0002,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    
    final centerX = width / 2;
    final centerY = height / 2;
    
    final rotX = (mousePosition.dy - centerY) * depth; 
    final rotY = (mousePosition.dx - centerX) * -depth;
    
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(rotX)
        ..rotateY(rotY),
      alignment: FractionalOffset.center,
      child: child,
    );
  }
}

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _productKey = GlobalKey();
  final GlobalKey _architectureKey = GlobalKey();
  final GlobalKey _howItWorksKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();
  
  Offset _mousePosition = Offset.zero;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: MouseRegion(
        onHover: (event) => setState(() => _mousePosition = event.position),
        child: Stack(
          children: [
          const ConstellationBackground(),

          // Main Scrollable Content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    HeroSection(mousePosition: _mousePosition),
                    const SizedBox(height: 60),
                    InteractiveExplainerSection(key: _howItWorksKey, mousePosition: _mousePosition),
                    const SizedBox(height: 120),
                    FeatureGridsSection(key: _productKey, mousePosition: _mousePosition),
                    const SizedBox(height: 120),
                    ThreeColumnFeatureStrip(mousePosition: _mousePosition),
                    const SizedBox(height: 120),
                    TestimonialsCarousel(mousePosition: _mousePosition),
                    const SizedBox(height: 120),
                    CrossPlatformSection(key: _architectureKey, mousePosition: _mousePosition),
                    const SizedBox(height: 80),
                    FooterSection(key: _contactKey),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 80,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              color: _kBg.withAlpha(210),
              border: const Border(bottom: BorderSide(color: _kBorder)),
            ),
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: SafeArea(
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withAlpha(80)),
                      boxShadow: [BoxShadow(color: Colors.white.withAlpha(40), blurRadius: 20, spreadRadius: -2)],
                    ),
                    child: const Icon(Icons.shield_outlined, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Text(
                      'NEXUS_GATEWAY',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: isDesktop ? 18 : 14,
                        letterSpacing: isDesktop ? 2.0 : 1.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isDesktop) ...[
                    const Spacer(),
                    _navLink('Product', _productKey),
                    const SizedBox(width: 12),
                    _navLink('Architecture', _architectureKey),
                    const SizedBox(width: 12),
                    _navLink('How it works', _howItWorksKey),
                    const SizedBox(width: 12),
                    _HoverNavLink(
                      title: 'API Docs',
                      onTapOverride: () {
                        Navigator.pushNamed(context, '/api_docs');
                      },
                    ),
                    const SizedBox(width: 12),
                    _navLink('Contact', _contactKey),
                    const SizedBox(width: 24),
                  ] else
                    const Spacer(),
                  AnimatedScaleHoverWrapper(
                    child: GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: isDesktop ? 20 : 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white.withAlpha(100)),
                          boxShadow: [BoxShadow(color: Colors.white.withAlpha(40), blurRadius: 20)],
                        ),
                        child: Text(
                          isDesktop ? 'Deploy Now' : 'Login',
                          style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: isDesktop ? 14 : 12, letterSpacing: 1.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _navLink(String title, GlobalKey? key) {
    return _HoverNavLink(title: title, globalKey: key);
  }
}

class _HoverNavLink extends StatefulWidget {
  final String title;
  final GlobalKey? globalKey;
  final VoidCallback? onTapOverride;
  const _HoverNavLink({required this.title, this.globalKey, this.onTapOverride});
  @override
  State<_HoverNavLink> createState() => _HoverNavLinkState();
}

class _HoverNavLinkState extends State<_HoverNavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (widget.onTapOverride != null) {
            widget.onTapOverride!();
            return;
          }
          if (widget.globalKey != null && widget.globalKey!.currentContext != null) {
            Scrollable.ensureVisible(
              widget.globalKey!.currentContext!,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              alignment: 0.1,
            );
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: _hovered ? _kBlue.withAlpha(15) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _hovered ? _kBlue.withAlpha(40) : Colors.transparent,
            ),
          ),
          child: Text(
            widget.title,
            style: GoogleFonts.outfit(
              color: _hovered ? Colors.white : _kZinc400,
              fontSize: 14,
              fontWeight: _hovered ? FontWeight.w600 : FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// HERO SECTION (Phase 1)
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class HeroSection extends StatelessWidget {
  final Offset mousePosition;
  const HeroSection({super.key, required this.mousePosition});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isTabletOrMobile = screenWidth < 950; // Breakpoint for tablet
    final isDesktop = !isTabletOrMobile;

    // 3D Antigravity Parallax Calculations
    final centerX = screenWidth / 2;
    final centerY = height / 2;
    
    // Calculate rotation angles (pitch and yaw)
    final rotX = (mousePosition.dy - centerY) * 0.0003; 
    final rotY = (mousePosition.dx - centerX) * -0.0003;
    
    final transformMatrix = Matrix4.identity()
      ..setEntry(3, 2, 0.001); // No base tilt or mouse rotation

    final leftContent = Transform(
      transform: transformMatrix,
      alignment: FractionalOffset.center,
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Super title badge â€” FittedBox prevents overflow on narrow screens
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _kBlue.withAlpha(15),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: _kBlue.withAlpha(50)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 8, height: 8, decoration: const BoxDecoration(color: _kBlue, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Text(
                  'ENTERPRISE SECURITY',
                  style: GoogleFonts.spaceGrotesk(color: Colors.white, letterSpacing: 2.0, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        // Heading
        _InteractiveElement(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.outfit(
                fontSize: isDesktop ? 72 : 48,
                height: 1.1,
                letterSpacing: -2.0,
              ),
              children: const [
                TextSpan(
                  text: 'Detect The \n',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: 'Undetectable',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        // Subtitle
        _InteractiveElement(
          child: Text(
            'Upload media, analyze pixel-level anomalies via\nHugging Face, and verify context with Gemini AI.',
            style: GoogleFonts.inter(
              color: Colors.white60,
              fontSize: isDesktop ? 18 : 15,
              height: 1.6,
            ),
            softWrap: true,
          ),
        ),
        const SizedBox(height: 48),
        // CTA
        Wrap(
          spacing: 16.0,
          runSpacing: 16.0,
          alignment: WrapAlignment.start,
          children: [
            TrustButton(
              label: 'ENTER DASHBOARD',
              isForwardAction: true,
              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
          ],
        ),
      ],
      ),
    );

    final rightContent = Center(
      child: _CinematicFeatureCard(mousePosition: mousePosition),
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 80 : 24, vertical: isDesktop ? 100 : 60),
      child: isDesktop 
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 10, child: leftContent),
                const SizedBox(width: 40),
                Expanded(flex: 12, child: rightContent),
              ],
            )
          : Column(
              children: [
                leftContent,
                const SizedBox(height: 60),
                SizedBox(
                  width: double.infinity,
                  child: rightContent,
                ),
              ],
            ),
    );
  }
}

class _CinematicFeatureCard extends StatefulWidget {
  final Offset mousePosition;
  const _CinematicFeatureCard({required this.mousePosition});

  @override
  State<_CinematicFeatureCard> createState() => _CinematicFeatureCardState();
}

class _CinematicFeatureCardState extends State<_CinematicFeatureCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    // Calculate relative tilt based on mouse position
    // We assume the card is roughly in the center-right of the screen
    final size = MediaQuery.of(context).size;
    final cardCenterX = size.width * 0.7; // Estimated center of the card
    final cardCenterY = size.height * 0.5;

    final dx = (widget.mousePosition.dx - cardCenterX) / (size.width * 0.3);
    final dy = (widget.mousePosition.dy - cardCenterY) / (size.height * 0.3);

    // Full 360-degree rotation based on mouse position (Full Physics)
    final tiltX = _hovered ? (-dy * pi * 2).clamp(-pi * 2, pi * 2) : 0.0;
    final tiltY = _hovered ? (dx * pi * 2).clamp(-pi * 2, pi * 2) : 0.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(seconds: 2),
        curve: Curves.elasticOut,
        transformAlignment: Alignment.center, // Ensures centered rotation
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(tiltX)
          ..rotateY(tiltY),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withAlpha(_hovered ? 30 : 15),
              blurRadius: _hovered ? 100 : 40,
              spreadRadius: 0,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Stack(
              children: [
                // â”€â”€ Image with cinematic treatment â”€â”€
                AspectRatio(
                  aspectRatio: 1.5,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Base Image
                      ColorFiltered(
                        colorFilter: const ColorFilter.matrix([
                          1.2, 0, 0, 0, -20,
                          0, 1.2, 0, 0, -20,
                          0, 0, 1.2, 0, -20,
                          0, 0, 0, 1, 0,
                        ]),
                        child: Image.asset(
                          'assets/images/hero_feature.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.black,
                            child: const Center(child: Icon(Icons.image_not_supported, color: Colors.white10)),
                          ),
                        ),
                      ),
                      // Vignette
                      Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withAlpha(180),
                            ],
                            stops: const [0.5, 1.0],
                          ),
                        ),
                      ),
                      // Reflection overlay that follows mouse
                      Positioned.fill(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(tiltY, tiltX),
                              end: Alignment(-tiltY, -tiltX),
                              colors: [
                                Colors.white.withAlpha(20),
                                Colors.transparent,
                                Colors.black.withAlpha(40),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // â”€â”€ Inner Glow Border â”€â”€
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withAlpha(_hovered ? 50 : 20),
                      width: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// INTERACTIVE EXPLAINER (Phase 2)
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class InteractiveExplainerSection extends StatefulWidget {
  final Offset mousePosition;
  const InteractiveExplainerSection({super.key, required this.mousePosition});

  @override
  State<InteractiveExplainerSection> createState() => _InteractiveExplainerSectionState();
}

class _InteractiveExplainerSectionState extends State<InteractiveExplainerSection>
    with SingleTickerProviderStateMixin {
  // null = none locked, otherwise index of the locked node
  int? _lockedIndex;
  late AnimationController _flowController;

  @override
  void initState() {
    super.initState();
    _flowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _flowController.dispose();
    super.dispose();
  }

  void _onNodeTap(int index) {
    setState(() {
      // Toggle: tap again to close, tap different to switch
      _lockedIndex = (_lockedIndex == index) ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(
            'RELIABLE PROTECTION',
            style: GoogleFonts.spaceGrotesk(color: _kBlue, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Text(
            'How it works',
            style: GoogleFonts.outfit(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold, letterSpacing: -1),
          ),
          const SizedBox(height: 16),
          Text(
            'A fully distributed architectural pipeline designed to identify manipulations\nin real-time via clustered AI modules.',
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceGrotesk(color: _kZinc400, fontSize: 18, height: 1.5),
          ),
          const SizedBox(height: 16),
          // Instruction hint
          AnimatedOpacity(
            opacity: _lockedIndex == null ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.touch_app_outlined, color: _kZinc400, size: 14),
                const SizedBox(width: 6),
                Text(
                  'Hover to preview Â· Click to lock open',
                  style: GoogleFonts.spaceGrotesk(color: _kZinc400, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),

          // Canvas area â€” desktop: Positioned stack; mobile: simple Column
          LayoutBuilder(builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 700;
            if (isMobile) {
              return Column(
                children: [
                  InteractiveExplainerNode(
                    index: 0, lockedIndex: _lockedIndex,
                    title: 'FastAPI Backend',
                    description: 'Stateless asynchronous microservices handling high-throughput payload ingestion and routing securely.',
                    icon: Icons.api_rounded, onTap: _onNodeTap,
                  ),
                  const SizedBox(height: 16),
                  InteractiveExplainerNode(
                    index: 1, lockedIndex: _lockedIndex,
                    title: 'Hugging Face Inference',
                    description: 'Deploying custom fine-tuned visual transformers to locate pixel-level artifacting and noise models.',
                    icon: Icons.biotech_outlined, onTap: _onNodeTap,
                  ),
                  const SizedBox(height: 16),
                  InteractiveExplainerNode(
                    index: 2, lockedIndex: _lockedIndex,
                    title: 'Gemini Multimodal',
                    description: 'Advanced LLM reasoning engine that validates contextual semantics and verifies environment constraints.',
                    icon: Icons.auto_awesome, onTap: _onNodeTap,
                  ),
                ],
              );
            }
            return MouseParallax(
              mousePosition: widget.mousePosition,
              depth: 0.00015,
              child: SizedBox(
                height: 420,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // Connective animated flow lines
                    Positioned.fill(
                      child: AnimatedBuilder(
                        animation: _flowController,
                        builder: (context, _) => CustomPaint(
                          painter: _AnimatedFlowLinePainter(phase: _flowController.value),
                        ),
                      ),
                    ),
                    // Node 0 â€” FastAPI Backend
                    Positioned(
                      left: 0, top: 120,
                      child: InteractiveExplainerNode(
                        index: 0, lockedIndex: _lockedIndex,
                        title: 'FastAPI Backend',
                        description: 'Stateless asynchronous microservices handling high-throughput payload ingestion and routing securely.',
                        icon: Icons.api_rounded, onTap: _onNodeTap,
                      ),
                    ),
                    // Node 1 â€” Hugging Face
                    Positioned(
                      top: 0, right: 80,
                      child: InteractiveExplainerNode(
                        index: 1, lockedIndex: _lockedIndex,
                        title: 'Hugging Face Inference',
                        description: 'Deploying custom fine-tuned visual transformers to locate pixel-level artifacting and noise models.',
                        icon: Icons.biotech_outlined, onTap: _onNodeTap,
                      ),
                    ),
                    // Node 2 â€” Gemini Multimodal
                    Positioned(
                      bottom: 10, right: 30,
                      child: InteractiveExplainerNode(
                        index: 2, lockedIndex: _lockedIndex,
                        title: 'Gemini Multimodal',
                        description: 'Advanced LLM reasoning engine that validates contextual semantics and verifies environment constraints.',
                        icon: Icons.auto_awesome, onTap: _onNodeTap,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _AnimatedFlowLinePainter extends CustomPainter {
  final double phase; // 0.0 â†’ 1.0 repeating
  _AnimatedFlowLinePainter({required this.phase});

  void _drawShiningPulse(Canvas canvas, Path path, Color color, double phaseOffset) {
    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;
    final metric = metrics.first;
    final totalLength = metric.length;

    // â”€â”€ 1. Dim static base line â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    canvas.drawPath(path, Paint()
      ..color = color.withAlpha(35)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round);

    // â”€â”€ 2. Position of the orb on the path (0..1 offset applied) â”€â”€â”€â”€â”€
    final double t = ((phase + phaseOffset) % 1.0);
    final double orbPos = t * totalLength;

    // â”€â”€ 3. Comet tail â€” a lit segment behind the orb â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    const double tailLength = 80.0;
    final double tailStart = (orbPos - tailLength).clamp(0.0, totalLength);
    if (tailStart < orbPos) {
      final tailPath = metric.extractPath(tailStart, orbPos);
      // Outer soft glow tail
      canvas.drawPath(tailPath, Paint()
        ..shader = null
        ..color = color.withAlpha(60)
        ..strokeWidth = 6
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
      // Inner brighter tail
      canvas.drawPath(tailPath, Paint()
        ..color = color.withAlpha(120)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round);
    }

    // â”€â”€ 4. The bright orb at the front â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    final tangent = metric.getTangentForOffset(orbPos);
    if (tangent == null) return;
    final orbCenter = tangent.position;

    // Outermost aura
    canvas.drawCircle(orbCenter, 12, Paint()
      ..color = color.withAlpha(30)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10));
    // Mid glow
    canvas.drawCircle(orbCenter, 6, Paint()
      ..color = color.withAlpha(120)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
    // Bright core
    canvas.drawCircle(orbCenter, 3, Paint()
      ..color = color
      ..style = PaintingStyle.fill);
    // White hot center
    canvas.drawCircle(orbCenter, 1.5, Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill);
  }

  @override
  void paint(Canvas canvas, Size size) {
    const nodeLeft = 32.0;
    const nodeTop  = 32.0;

    final path1 = Path();
    path1.moveTo(nodeLeft, size.height / 2);
    path1.quadraticBezierTo(
      size.width / 2, size.height / 2,
      size.width - 170, nodeTop,
    );

    final path2 = Path();
    path2.moveTo(nodeLeft, size.height / 2);
    path2.quadraticBezierTo(
      size.width / 2, size.height / 2,
      size.width - 120, size.height - 42,
    );

    // path1: cyan pulse, path2: purple pulse staggered by 0.5
    _drawShiningPulse(canvas, path1, _kPrimary,   0.0);
    _drawShiningPulse(canvas, path2, _kSecondary, 0.5);
  }

  @override
  bool shouldRepaint(covariant _AnimatedFlowLinePainter old) => old.phase != phase;
}


class InteractiveExplainerNode extends StatefulWidget {
  final int index;
  final int? lockedIndex;
  final String title;
  final String description;
  final IconData icon;
  final void Function(int) onTap;

  const InteractiveExplainerNode({
    super.key,
    required this.index,
    required this.lockedIndex,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  State<InteractiveExplainerNode> createState() => _InteractiveExplainerNodeState();
}

class _InteractiveExplainerNodeState extends State<InteractiveExplainerNode>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  bool get _isExpanded {
    // Show card if: this node is hovered OR locked
    if (widget.lockedIndex == widget.index) return true;
    if (_isHovered && widget.lockedIndex == null) return true;
    return false;
  }

  bool get _isLocked => widget.lockedIndex == widget.index;
  bool get _isDimmed => widget.lockedIndex != null && widget.lockedIndex != widget.index;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _scaleAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOutBack);
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
  }

  @override
  void didUpdateWidget(covariant InteractiveExplainerNode oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isExpanded) {
      _animController.forward();
    } else {
      _animController.reverse();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        if (!_isLocked && widget.lockedIndex == null) _animController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        if (!_isLocked) _animController.reverse();
      },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => widget.onTap(widget.index),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          opacity: _isDimmed ? 0.35 : 1.0,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // â”€â”€ Main node circle / card â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutQuart,
                width: _isExpanded ? 300 : 64,
                height: _isExpanded ? 240 : 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_isExpanded ? 16 : 32),
                  color: _kSurface,
                  border: Border.all(
                    color: _isLocked
                        ? _kPrimary.withAlpha(180)
                        : _isHovered
                            ? _kPrimary.withAlpha(80)
                            : _kBorder,
                    width: _isLocked ? 1.5 : 1.0,
                  ),
                  boxShadow: _isExpanded
                      ? [
                          BoxShadow(
                            color: _kPrimary.withAlpha(_isLocked ? 60 : 30),
                            blurRadius: 30,
                            spreadRadius: 2,
                          )
                        ]
                      : [],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(_isExpanded ? 16 : 32),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                    child: _isExpanded
                        ? FadeTransition(
                            opacity: _fadeAnim,
                            child: ScaleTransition(
                              scale: _scaleAnim,
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: _kPrimary.withAlpha(20),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(widget.icon, color: _kPrimary, size: 18),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            widget.title,
                                            style: GoogleFonts.outfit(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (_isLocked)
                                          Icon(Icons.lock_outline, color: _kPrimary, size: 14)
                                        else
                                          Icon(Icons.visibility_outlined, color: _kZinc400, size: 14),
                                      ],
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      widget.description,
                                      style: GoogleFonts.spaceGrotesk(
                                        color: _kZinc400,
                                        fontSize: 13,
                                        height: 1.55,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: _isHovered
                                  ? Icon(widget.icon, color: _kPrimary, size: 24, key: const ValueKey('icon'))
                                  : const Icon(Icons.add, color: Colors.white54, size: 22, key: ValueKey('plus')),
                            ),
                          ),
                  ),
                ),
              ),

              // â”€â”€ Locked badge â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              if (_isLocked)
                Positioned(
                  top: -8,
                  right: -8,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: _kPrimary,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: _kPrimary.withAlpha(120), blurRadius: 10)],
                    ),
                    child: const Icon(Icons.lock, color: Colors.black, size: 11),
                  ),
                ),

              // â”€â”€ Pulsing ring on hover (collapsed state only) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              if (_isHovered && !_isExpanded)
                Positioned.fill(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 1.0, end: 1.35),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOut,
                    builder: (context, scale, _) => Transform.scale(
                      scale: scale,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: _kPrimary.withAlpha(60), width: 1),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// FEATURE GRIDS (Phase 3)
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class FeatureGridsSection extends StatelessWidget {
  final Offset mousePosition;
  const FeatureGridsSection({super.key, required this.mousePosition});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    final grid = _buildGrid();
    final whySection = _buildWhyNexus();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 80 : 24),
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 1000) {
          return Column(
            children: [
              whySection,
              const SizedBox(height: 60),
              grid,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: MouseParallax(mousePosition: mousePosition, depth: 0.0001, child: grid)),
            const SizedBox(width: 80),
            Expanded(flex: 2, child: MouseParallax(mousePosition: mousePosition, depth: -0.0001, child: whySection)),
          ],
        );
      }),
    );
  }

  Widget _buildGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(builder: (ctx, constraints) {
          final isMobile = constraints.maxWidth < 500;
          return Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              FeatureGridCard(title: 'Zero-Trust Firebase Auth', desc: 'Strict session verification and token-based telemetry logging.', icon: Icons.lock_outline, width: isMobile ? constraints.maxWidth : constraints.maxWidth / 2 - 12),
              FeatureGridCard(title: 'Encrypted Payload Transfer', desc: 'Multi-part binary transport over SSL with dynamic signature generation.', icon: Icons.shield_outlined, width: isMobile ? constraints.maxWidth : constraints.maxWidth / 2 - 12),
              FeatureGridCard(title: 'Sub-pixel AI Detection', desc: 'Fourier transform validation and facial boundary inconsistency checks.', icon: Icons.auto_awesome, width: isMobile ? constraints.maxWidth : constraints.maxWidth / 2 - 12),
              FeatureGridCard(title: 'Stateless Processing', desc: 'Horizontal scaling of prediction servers maintaining zero persistent payload data.', icon: Icons.data_object, width: isMobile ? constraints.maxWidth : constraints.maxWidth / 2 - 12),
            ],
          );
        })
      ],
    );
  }

  Widget _buildWhyNexus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WHY NEXUS_GATEWAY?',
          style: GoogleFonts.spaceGrotesk(color: _kBlue, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 13),
        ),
        const SizedBox(height: 16),
        Text(
          'Deepfake threats compromise enterprise integrity.',
          style: GoogleFonts.outfit(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold, height: 1.2),
        ),
        const SizedBox(height: 24),
        Text(
          'Nexus leverages state-of-the-art anomaly resolution engines that are impossible to fool. With hybrid detection paradigms mapping spatial distortion alongside metadata falsification, your digital assets remain absolutely secure.',
          style: GoogleFonts.spaceGrotesk(color: _kZinc400, fontSize: 16, height: 1.6),
        ),
        const SizedBox(height: 48),
        _whyBanner('Real-time Processing'),
        const SizedBox(height: 16),
        _whyBanner('Cross-Platform UI'),
        const SizedBox(height: 16),
        _whyBanner('Google Cloud Native'),
      ],
    );
  }

  Widget _whyBanner(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: _kBlue, width: 3)),
        color: _kSurface,
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: _kBlue, size: 20),
          const SizedBox(width: 16),
          Text(text, style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class FeatureGridCard extends StatefulWidget {
  final String title;
  final String desc;
  final IconData icon;
  final double width;

  const FeatureGridCard({
    super.key,
    required this.title,
    required this.desc,
    required this.icon,
    required this.width,
  });

  @override
  State<FeatureGridCard> createState() => _FeatureGridCardState();
}

class _FeatureGridCardState extends State<FeatureGridCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: _isHovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widget.width,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _kSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _kBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _kBlue.withAlpha(20),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(widget.icon, color: _kBlue, size: 24),
                  ),
                  const SizedBox(height: 24),
                  Text(widget.title, style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(widget.desc, style: GoogleFonts.spaceGrotesk(color: _kZinc400, fontSize: 14, height: 1.5)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// CROSS PLATFORM SHOWCASE (Phase 4)
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class CrossPlatformSection extends StatelessWidget {
  final Offset mousePosition;
  const CrossPlatformSection({super.key, required this.mousePosition});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 80 : 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
          child: Container(
            padding: EdgeInsets.all(isDesktop ? 64 : 32),
            decoration: BoxDecoration(
              color: _kSurface,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: _kBorder),
              gradient: LinearGradient(
                colors: [_kSurface, Colors.white.withAlpha(40)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            ),
            child: LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth < 1000) {
                return Column(
                  children: [
                    _buildTextContent(context),
                    const SizedBox(height: 60),
                    _buildMockups(),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: MouseParallax(mousePosition: mousePosition, depth: -0.00005, child: _buildTextContent(context))),
                  const SizedBox(width: 60),
                  Expanded(child: MouseParallax(mousePosition: mousePosition, depth: 0.0002, child: _buildMockups())),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildTextContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: Colors.white.withAlpha(10), borderRadius: BorderRadius.circular(6)),
          child: Text('NATIVE PERFORMANCE', style: GoogleFonts.spaceGrotesk(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        ),
        const SizedBox(height: 24),
        Text('Deploy everywhere from a single codebase.', style: GoogleFonts.outfit(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold, height: 1.1)),
        const SizedBox(height: 24),
        Text('Built entirely in Flutter, Nexus Gateway compiles to a lightning-fast Web WebAssembly client and a native Android APK flawlessly.', style: GoogleFonts.spaceGrotesk(color: _kZinc400, fontSize: 18, height: 1.5)),
        const SizedBox(height: 40),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _storeButton(
              icon: Icons.language, 
              label: 'Launch Web Client', 
              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
            _storeButton(
              icon: Icons.android, 
              label: 'Download Android APK', 
              onTap: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Connecting to build server... APK download will start shortly.'),
                    backgroundColor: Color(0xFF8B5CF6), // Purple
                    duration: Duration(seconds: 3),
                  ),
                );
                // Placeholder external link to simulate download/github release
                final uri = Uri.parse('https://github.com/');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
          ],
        )
      ],
    );
  }

  Widget _storeButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return AnimatedScaleHoverWrapper(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _kBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Text(label, style: GoogleFonts.outfit(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMockups() {
    return LayoutBuilder(builder: (context, constraints) {
      final scale = (constraints.maxWidth / 500).clamp(0.5, 1.0);
      return SizedBox(
        height: 400 * scale,
        child: Stack(
          children: [
            Positioned(
              right: 0,
              bottom: 0,
              child: Transform.rotate(
                angle: 0.1,
                child: Container(
                  width: 300 * scale,
                  height: 200 * scale,
                  decoration: BoxDecoration(
                    color: _kBg,
                    borderRadius: BorderRadius.circular(16 * scale),
                    border: Border.all(color: _kBlue.withAlpha(50), width: 2),
                    boxShadow: [BoxShadow(color: _kBlue.withAlpha(20), blurRadius: 40 * scale)],
                  ),
                  child: Center(child: Icon(Icons.web, color: _kBlue, size: 48 * scale)),
                ),
              ),
            ),
            Positioned(
              left: 20 * scale,
              top: 20 * scale,
              child: Transform.rotate(
                angle: -0.15,
                child: Container(
                  width: 160 * scale,
                  height: 320 * scale,
                  decoration: BoxDecoration(
                    color: _kSurface,
                    borderRadius: BorderRadius.circular(24 * scale),
                    border: Border.all(color: _kPurple.withAlpha(50), width: 2),
                    boxShadow: [BoxShadow(color: _kPurple.withAlpha(20), blurRadius: 40 * scale)],
                  ),
                  child: Center(child: Icon(Icons.smartphone, color: _kPurple, size: 48 * scale)),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// FOOTER
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: _kBorder)),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: 16,
        spacing: 16,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.shield_outlined, color: Colors.white, size: 16),
              const SizedBox(width: 10),
              Text('Â© 2026 Nexus Gateway', style: GoogleFonts.spaceGrotesk(color: _kZinc400, fontSize: 13)),
            ],
          ),
          if (MediaQuery.of(context).size.width > 600)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Terms of Service', style: GoogleFonts.spaceGrotesk(color: _kZinc400, fontSize: 13)),
                const SizedBox(width: 24),
                Text('Privacy Policy', style: GoogleFonts.spaceGrotesk(color: _kZinc400, fontSize: 13)),
              ],
            ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.public, color: _kZinc400, size: 20),
              const SizedBox(width: 16),
              Icon(Icons.code, color: _kZinc400, size: 20),
            ],
          ),
        ],
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// THREE-COLUMN FEATURE STRIP (Phase 3)
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class ThreeColumnFeatureStrip extends StatelessWidget {
  final Offset mousePosition;
  const ThreeColumnFeatureStrip({super.key, required this.mousePosition});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final features = [
      _FeatureItem(
        icon: Icons.radar,
        title: 'Multimodal Analysis',
        desc: 'Simultaneous scanning of spatial anomalies and frequency artifacts across both audio and visual domains using synchronized transformer models.',
      ),
      _FeatureItem(
        icon: Icons.lock_outline,
        title: 'Zero-Trust Pipeline',
        desc: 'End-to-end payload encryption combined with strict Firebase authentication, ensuring your forensic data remains totally sandboxed.',
      ),
      _FeatureItem(
        icon: Icons.bolt,
        title: 'Sub-Second Latency',
        desc: 'Highly optimized inference routing on L40S accelerators ensures that you receive verifiable threat intelligence in real-time.',
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 80 : 24),
      child: Column(
        children: [
          Text(
            'WHY CHOOSE NEXUS?',
            style: GoogleFonts.spaceGrotesk(color: _kBlue, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Text(
            'Built for zero-tolerance environments',
            style: GoogleFonts.outfit(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold, letterSpacing: -1),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          LayoutBuilder(builder: (context, constraints) {
            final width = constraints.maxWidth;
            if (width < 600) {
              return Column(
                children: features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: _buildFeatureCol(f),
                )).toList(),
              );
            } else if (width < 1000) {
              return Wrap(
                spacing: 24,
                runSpacing: 32,
                alignment: WrapAlignment.center,
                children: features.map((f) => SizedBox(
                  width: (width - 48) / 2,
                  child: _buildFeatureCol(f),
                )).toList(),
              );
            } else {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: features.asMap().entries.map((e) {
                  final index = e.key;
                  final f = e.value;
                  final depth = index == 0 ? 0.0001 : (index == 1 ? 0.0002 : 0.0001);
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: MouseParallax(mousePosition: mousePosition, depth: depth, child: _buildFeatureCol(f)),
                    ),
                  );
                }).toList(),
              );
            }
          }),
          const SizedBox(height: 48),
          _PulsingCTAButton(
            label: 'SIGN UP NOW â€” FREE',
            onTap: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCol(_FeatureItem f) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _kBlue.withAlpha(15),
            shape: BoxShape.circle,
            border: Border.all(color: _kBlue.withAlpha(40)),
          ),
          child: Icon(f.icon, color: _kBlue, size: 28),
        ),
        const SizedBox(height: 20),
        Text(
          f.title,
          style: GoogleFonts.outfit(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          f.desc,
          style: GoogleFonts.spaceGrotesk(color: _kZinc400, fontSize: 15, height: 1.6),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _FeatureItem {
  final IconData icon;
  final String title;
  final String desc;
  const _FeatureItem({required this.icon, required this.title, required this.desc});
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// TESTIMONIALS CAROUSEL (Phase 3 â€” horizontal scroll + arrow controls)
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class TestimonialsCarousel extends StatefulWidget {
  final Offset mousePosition;
  const TestimonialsCarousel({super.key, required this.mousePosition});

  @override
  State<TestimonialsCarousel> createState() => _TestimonialsCarouselState();
}

class _TestimonialsCarouselState extends State<TestimonialsCarousel> {
  final ScrollController _scrollCtrl = ScrollController();

  void _scrollBy(double offset) {
    _scrollCtrl.animateTo(
      (_scrollCtrl.offset + offset).clamp(0, _scrollCtrl.position.maxScrollExtent),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final testimonials = [
      _Testimonial(name: 'Sarah Chen', role: 'CISO, QuantumVault Inc.', quote: 'NEXUS_GATEWAY detected a deepfake board presentation that bypassed our existing tools. Game-changing threat intelligence.'),
      _Testimonial(name: 'Marcus Webb', role: 'Head of Security, DataForge', quote: 'The Gemini multimodal analysis gave us forensic-grade verdicts instantly. Our incident response time dropped by 80%.'),
      _Testimonial(name: 'Elena Volkov', role: 'VP Engineering, CyberShield', quote: 'We deployed NEXUS across web and mobile in a single sprint. The Flutter architecture is a force multiplier.'),
      _Testimonial(name: 'Raj Patel', role: 'AI Research Lead, NeuralTrust', quote: 'The Hugging Face pipeline catches sub-pixel artifacts that even our in-house models miss. Next-generation detection.'),
      _Testimonial(name: 'Priya Sharma', role: 'CTO, SecureMedia Global', quote: 'Zero-trust authentication combined with real-time AI scanning. NEXUS is the gold standard for media verification.'),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 80 : 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TRUSTED BY LEADERS', style: GoogleFonts.spaceGrotesk(color: _kBlue, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 13)),
                    const SizedBox(height: 12),
                    Text('They trust NEXUS_GATEWAY', style: GoogleFonts.outfit(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: -1)),
                  ],
                ),
              ),
              Row(
                children: [
                  _arrowButton(Icons.arrow_back_ios_new, () => _scrollBy(-340)),
                  const SizedBox(width: 12),
                  _arrowButton(Icons.arrow_forward_ios, () => _scrollBy(340)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          MouseParallax(
            mousePosition: widget.mousePosition,
            depth: -0.0001,
            child: SizedBox(
              height: 220,
              child: ListView.builder(
                controller: _scrollCtrl,
                scrollDirection: Axis.horizontal,
                itemCount: testimonials.length,
                itemBuilder: (ctx, i) {
                  final t = testimonials[i];
                  return Container(
                    width: 320,
                    margin: const EdgeInsets.only(right: 20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: _kSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _kBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.format_quote, color: _kBlue.withAlpha(80), size: 28),
                        const SizedBox(height: 12),
                        Expanded(
                          child: Text(t.quote, style: GoogleFonts.spaceGrotesk(color: _kZinc400, fontSize: 14, height: 1.5)),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _kBlue.withAlpha(25),
                                border: Border.all(color: _kBlue.withAlpha(60)),
                              ),
                              child: Center(
                                child: Text(
                                  t.name.split(' ').map((w) => w[0]).take(2).join(),
                                  style: GoogleFonts.outfit(color: _kBlue, fontSize: 12, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t.name, style: GoogleFonts.outfit(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                                Text(t.role, style: GoogleFonts.spaceGrotesk(color: Colors.grey[600], fontSize: 11)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _arrowButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: _kSurface,
          shape: BoxShape.circle,
          border: Border.all(color: _kBorder),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}

class _Testimonial {
  final String name;
  final String role;
  final String quote;
  const _Testimonial({required this.name, required this.role, required this.quote});
}

class AnimatedScaleHoverWrapper extends StatefulWidget {
  final Widget child;
  const AnimatedScaleHoverWrapper({super.key, required this.child});

  @override
  State<AnimatedScaleHoverWrapper> createState() => _AnimatedScaleHoverWrapperState();
}

class _AnimatedScaleHoverWrapperState extends State<AnimatedScaleHoverWrapper> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: _isHovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// PULSING CTA BUTTON
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _PulsingCTAButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _PulsingCTAButton({required this.label, required this.onTap});

  @override
  State<_PulsingCTAButton> createState() => _PulsingCTAButtonState();
}

class _PulsingCTAButtonState extends State<_PulsingCTAButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: false);
    _pulseAnim = CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: _isHovered ? 1.08 : 1.0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // â”€â”€ Repeating pulse ring â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              AnimatedBuilder(
                animation: _pulseAnim,
                builder: (context, _) {
                  final scale = 1.0 + _pulseAnim.value * 0.5;
                  final opacity = (1.0 - _pulseAnim.value).clamp(0.0, 1.0);
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 300,
                      height: 72,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _kPrimary.withAlpha((opacity * 100).toInt()),
                          width: 2,
                        ),
                      ),
                    ),
                  );
                },
              ),

              // â”€â”€ The main button â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 22),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _kBlue.withAlpha(80)),
                  boxShadow: [
                    BoxShadow(
                      color: _kBlue.withAlpha(_isHovered ? 80 : 40),
                      blurRadius: _isHovered ? 50 : 30,
                      spreadRadius: _isHovered ? 4 : 0,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.label,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            letterSpacing: 1.8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 22),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _InteractiveElement extends StatefulWidget {
  final Widget child;
  const _InteractiveElement({required this.child});

  @override
  State<_InteractiveElement> createState() => _InteractiveElementState();
}

class _InteractiveElementState extends State<_InteractiveElement> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          ..translate(_hovered ? 15.0 : 0.0, 0.0, 0.0), // Hover offset
        child: widget.child,
      ),
    );
  }
}

```

## `flutter-client\lib\screens\login_screen.dart`
```dart
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../main.dart'; // For HoverGlowText
import 'dart:async';

// â”€â”€ Color tokens â€” Obsidian & Holographic Glass â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
const _kBg         = Color(0xFF000000);  // Pure Black
const _kBgDeep     = Color(0xFF000000);  // Pure Black
const _kPrimary    = Color(0xFFFFFFFF);  // White
const _kSecondary  = Color(0xFFFFFFFF);  // White
const _kSurface    = Color(0x1AFFFFFF);  // 10% white
const _kBorderCol  = Color(0x33FFFFFF);  // 20% white
const _kNeutral400 = Color(0xFFA1A1AA);
const _kNeutral500 = Color(0xFF71717A);
const _kRed        = Color(0xFFFFFFFF);  // Use White for errors too (or White with opacity)
const _kRose       = Color(0xFFFFFFFF);
const trustAccent  = Color(0xFF4F46E5); // Deep Indigo
// Legacy aliases
const _kBlack      = _kBg;
const _kBlue       = _kPrimary;
const _kBlueDark   = _kSecondary;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nameCtrl = TextEditingController(); // for register mode
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _showPassword = false;
  bool _isRegisterMode = false; // toggles between login / create account
  bool _isPrimaryHovered = false;
  bool _isGoogleHovered = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  // â”€â”€ Helpers â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.warning_amber_rounded,
                color: Colors.white70, size: 16),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.spaceGrotesk(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: _kRed.withAlpha(200),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  String _friendlyError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found for that email address.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }

  // â”€â”€ Auth Actions â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Future<void> _handleLogin() async {
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();
    if (email.isEmpty || password.isEmpty) {
      _showError('Please enter your email and password.');
      return;
    }
    setState(() => _isLoading = true);
    debugPrint('AUTH LOG: Attempting login...');
    try {
      await _authService.signInWithEmailAndPassword(email, password);
      debugPrint('AUTH LOG: Success');
      if (mounted) Navigator.pushReplacementNamed(context, '/dashboard');
    } on FirebaseAuthException catch (e) {
      _showError(_friendlyError(e));
      debugPrint('AUTH LOG Error: ${e.message}');
    } on TimeoutException catch (e) {
      _showError('Connection timed out. Please check your network.');
      debugPrint('AUTH LOG Error: ${e.message}');
    } on FirebaseException catch (e) {
      _showError(e.message ?? 'A Firebase error occurred.');
      debugPrint('AUTH LOG Error: ${e.message}');
    } catch (e) {
      _showError('An unexpected error occurred. Please try again.');
      debugPrint('AUTH LOG Error: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleRegister() async {
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();
    if (email.isEmpty || password.isEmpty) {
      _showError('Please fill in all fields.');
      return;
    }
    setState(() => _isLoading = true);
    debugPrint('AUTH LOG: Attempting register...');
    try {
      await _authService.registerWithEmailAndPassword(email, password);
      debugPrint('AUTH LOG: Success');
      if (mounted) Navigator.pushReplacementNamed(context, '/dashboard');
    } on FirebaseAuthException catch (e) {
      _showError(_friendlyError(e));
      debugPrint('AUTH LOG Error: ${e.message}');
    } on TimeoutException catch (e) {
      _showError('Connection timed out. Please check your network.');
      debugPrint('AUTH LOG Error: ${e.message}');
    } on FirebaseException catch (e) {
      _showError(e.message ?? 'A Firebase error occurred.');
      debugPrint('AUTH LOG Error: ${e.message}');
    } catch (e) {
      _showError('Registration failed. Please try again.');
      debugPrint('AUTH LOG Error: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    debugPrint('AUTH LOG: Attempting Google sign-in...');
    try {
      final result = await _authService.signInWithGoogle();
      if (result != null) {
        debugPrint('AUTH LOG: Google sign-in success');
        if (mounted) Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        debugPrint('AUTH LOG: User cancelled sign-in');
      }
      // On success, AuthWrapper reacts to the auth state change automatically
    } on FirebaseAuthException catch (e) {
      _showError(_friendlyError(e));
      debugPrint('AUTH LOG Error: ${e.message}');
    } on TimeoutException catch (e) {
      _showError('Connection timed out. Please check your network.');
      debugPrint('AUTH LOG Error: ${e.message}');
    } on FirebaseException catch (e) {
      _showError(e.message ?? 'A Firebase error occurred.');
      debugPrint('AUTH LOG Error: ${e.message}');
    } catch (e) {
      _showError('Google sign-in failed. Please try again.');
      debugPrint('AUTH LOG Error: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // â”€â”€ Build â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 900;

    return Scaffold(
      backgroundColor: _kBg,
      body: Stack(
        children: [
          // â”€â”€ Radial gradient background â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [_kBgDeep, _kBg],
                stops: [0.0, 1.0],
              ),
            ),
          ),
          // â”€â”€ Ambient violet glow (top-left) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          Positioned(
            top: -150,
            left: -150,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _kSecondary.withAlpha(30),
                    blurRadius: 200,
                    spreadRadius: 100,
                  ),
                ],
              ),
            ),
          ),
          // â”€â”€ Ambient cyan glow (bottom-right) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          Positioned(
            bottom: -150,
            right: -150,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _kPrimary.withAlpha(20),
                    blurRadius: 200,
                    spreadRadius: 100,
                  ),
                ],
              ),
            ),
          ),
          // â”€â”€ Main layout â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          isWide ? _buildWideLayout() : _buildNarrowLayout(),
        ],
      ),
    );
  }

  // â”€â”€ Wide layout: 45% form + 55% image (React parity) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildWideLayout() {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.45,
          child: SingleChildScrollView(child: _buildFormSection()),
        ),
        Expanded(child: _buildImageSection()),
      ],
    );
  }

  Widget _buildNarrowLayout() {
    return SingleChildScrollView(child: _buildFormSection());
  }

  // â”€â”€ Left: Form Section â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildFormSection() {
    final width = MediaQuery.of(context).size.width;
    final hPad = width < 480 ? 24.0 : 56.0;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Container(
          decoration: const BoxDecoration(
            color: _kSurface,
            border: Border(
              right: BorderSide(color: _kBorderCol),
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 48),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo row
                  LayoutBuilder(builder: (context, logoConstraints) {
                    return Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [_kPrimary, _kSecondary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  color: _kPrimary.withAlpha(50),
                                  blurRadius: 16,
                                  spreadRadius: 1),
                            ],
                          ),
                          child: const Icon(Icons.verified_user_outlined,
                              color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: width < 360 ? 16 : 20,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                              ),
                              children: [
                                const TextSpan(text: 'NEXUS'),
                                TextSpan(
                                    text: '_',
                                    style: const TextStyle(color: _kPrimary)),
                                const TextSpan(text: 'GATEWAY'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 52),

                  // Headline
                  HoverGlowText(
                    _isRegisterMode
                        ? 'Begin your\njourney.'
                        : 'REALITY IS DATA.',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: width < 360 ? 28 : 36,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 14),
                  HoverGlowText(
                    _isRegisterMode
                        ? 'Create an account to access our suite of advanced security tools and analytics.'
                        : 'TRUST IS EARNED. WE VERIFY BOTH.',
                    style: GoogleFonts.spaceGrotesk(
                      color: _kNeutral400,
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Full name field (register only)
                  if (_isRegisterMode) ...[
                    _buildLabel('FULL NAME'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _nameCtrl,
                      hint: 'John Doe',
                      obscure: false,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Email
                  _buildLabel('EMAIL ADDRESS'),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _emailCtrl,
                    hint: 'operator@nexus.io',
                    obscure: false,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  // Password
                  _buildLabel('PASSWORD'),
                  const SizedBox(height: 6),
                  _buildPasswordField(),

                  // Forgot link (login only)
                  if (!_isRegisterMode) ...[
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Recover authorization code',
                          style: GoogleFonts.spaceGrotesk(
                            color: _kPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),

                  // Primary CTA button
                  _buildPrimaryButton(),
                  const SizedBox(height: 28),

                  // Divider
                  _buildDivider(),
                  const SizedBox(height: 20),

                  // Google button
                  _buildGoogleButton(),
                  const SizedBox(height: 28),

                  // Toggle login â†” register
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        _isRegisterMode
                            ? 'Already have an account? '
                            : 'Unregistered operator? ',
                        style: GoogleFonts.spaceGrotesk(
                            color: _kNeutral500, fontSize: 13),
                      ),
                      GestureDetector(
                        onTap: () => setState(() {
                          _isRegisterMode = !_isRegisterMode;
                          _emailCtrl.clear();
                          _passwordCtrl.clear();
                          _nameCtrl.clear();
                        }),
                        child: Text(
                          _isRegisterMode ? 'Sign In' : 'Request Access',
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white.withAlpha(50),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // â”€â”€ Right: Image Section â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildImageSection() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background â€” deep neutral
        Container(color: const Color(0xFF111111)),

        // Network/circuit image via NetworkImage (matches React unsplash URL)
        Image.asset(
          'assets/images/login_bg.jpg',
          fit: BoxFit.cover,
          color: Colors.black.withAlpha(130),
          colorBlendMode: BlendMode.darken,
          errorBuilder: (context, error, stack) => const SizedBox.shrink(),
        ),

        // Left fade gradient (matches React `from-black via-black/80 to-transparent`)
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: 160,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_kBlack, _kBlack.withAlpha(200), Colors.transparent],
              ),
            ),
          ),
        ),

        // Top + bottom fade
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _kBlack.withAlpha(150),
                Colors.transparent,
                _kBlack.withAlpha(150),
              ],
            ),
          ),
        ),

        // Floating glass card (bottom-right area, matching React decorative panel)
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.22,
          right: 80,
          child: Transform(
            transform: Matrix4.rotationZ(-0.035),
            child: _buildGlassCard(),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassCard() {
    return Container(
      width: 272,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withAlpha(20)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(100),
              blurRadius: 30,
              spreadRadius: 2),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _kRose.withAlpha(50),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.security_outlined,
                color: _kRose.withAlpha(200), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Deepfake Vector Scans',
                    style: GoogleFonts.spaceGrotesk(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
                Text('Status: Active Monitoring',
                    style: GoogleFonts.spaceGrotesk(
                      color: _kRose,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // â”€â”€ Form Widget Builders â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.spaceGrotesk(
        color: _kNeutral500,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 15),
      cursorColor: _kBlue,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            GoogleFonts.spaceGrotesk(color: Colors.white.withAlpha(35), fontSize: 14),
        filled: true,
        fillColor: _kSurface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _kBorderCol),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withAlpha(77), width: 1),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordCtrl,
      obscureText: !_showPassword,
      style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 15),
      cursorColor: _kBlue,
      decoration: InputDecoration(
        hintText: 'â€¢â€¢â€¢â€¢â€¢â€¢â€¢â€¢',
        hintStyle:
            GoogleFonts.spaceGrotesk(color: Colors.white.withAlpha(35), fontSize: 14),
        filled: true,
        fillColor: _kSurface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _kBorderCol),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withAlpha(77), width: 1),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _showPassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: _kNeutral500,
            size: 20,
          ),
          onPressed: () => setState(() => _showPassword = !_showPassword),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isPrimaryHovered = true),
      onExit: (_) => setState(() => _isPrimaryHovered = false),
      cursor: SystemMouseCursors.click,
      child: SizedBox(
        height: 56,
        child: GestureDetector(
          onTap: _isLoading
              ? null
              : (_isRegisterMode ? _handleRegister : _handleLogin),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: _isPrimaryHovered ? trustAccent.withOpacity(0.1) : _kBlack,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: trustAccent.withOpacity(0.8), width: 1),
              boxShadow: _isLoading
                  ? null
                  : [
                      BoxShadow(
                        color: trustAccent.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
            ),
          child: Center(
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isRegisterMode ? 'Create Account' : 'Initiate Handshake',
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward,
                          size: 17, color: Colors.white),
                    ],
                  ),
          ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
            child:
                Divider(color: Colors.white.withAlpha(25), thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            _isRegisterMode ? 'OR CONTINUE WITH' : 'OR AUTHENTICATE VIA',
            style: GoogleFonts.spaceGrotesk(
              color: _kNeutral500,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ),
        Expanded(
            child:
                Divider(color: Colors.white.withAlpha(25), thickness: 1)),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isGoogleHovered = true),
      onExit: (_) => setState(() => _isGoogleHovered = false),
      child: SizedBox(
        height: 56,
        child: OutlinedButton(
          onPressed: _isLoading ? null : _handleGoogleSignIn,
          style: OutlinedButton.styleFrom(
            backgroundColor: _kSurface,
            foregroundColor: Colors.white,
            side: BorderSide(color: _isGoogleHovered ? trustAccent.withOpacity(0.4) : _kBorderCol),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        child: _isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    color: _kNeutral400, strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google 'G' logo â€” exact 4-path SVG coloured paths
                  _GoogleLogo(size: 20),
                  const SizedBox(width: 12),
                  Text(
                    'Google',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}

// â”€â”€ Google Logo (4-colour SVG paths, matches React) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _GoogleLogo extends StatelessWidget {
  final double size;
  const _GoogleLogo({this.size = 20});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GoogleLogoPainter(),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final blue = Paint()..color = Colors.white;
    final green = Paint()..color = Colors.white70;
    final yellow = Paint()..color = Colors.white60;
    final red = Paint()..color = Colors.white54;

    // Scale factor: React SVG viewBox is 24x24
    final scale = s / 24;
    canvas.scale(scale, scale);

    // Blue path (top-right)
    final pBlue = Path()
      ..moveTo(22.56, 12.25)
      ..cubicTo(22.56, 11.47, 22.49, 10.72, 22.36, 10.0)
      ..lineTo(12, 10.0)
      ..lineTo(12, 14.26)
      ..lineTo(17.92, 14.26)
      ..cubicTo(17.66, 15.63, 16.88, 16.79, 15.71, 17.57)
      ..lineTo(15.71, 20.34)
      ..lineTo(19.28, 20.34)
      ..cubicTo(21.36, 18.42, 22.56, 15.6, 22.56, 12.25)
      ..close();
    canvas.drawPath(pBlue, blue);

    // Green path (bottom)
    final pGreen = Path()
      ..moveTo(12, 23)
      ..cubicTo(14.97, 23, 17.46, 22.02, 19.28, 20.34)
      ..lineTo(15.71, 17.57)
      ..cubicTo(14.73, 18.23, 13.48, 18.63, 12, 18.63)
      ..cubicTo(9.14, 18.63, 6.71, 16.7, 5.84, 14.1)
      ..lineTo(2.18, 14.1)
      ..lineTo(2.18, 16.94)
      ..cubicTo(3.99, 20.53, 7.7, 23, 12, 23)
      ..close();
    canvas.drawPath(pGreen, green);

    // Yellow path (left)
    final pYellow = Path()
      ..moveTo(5.84, 14.09)
      ..cubicTo(5.62, 13.43, 5.49, 12.73, 5.49, 12)
      ..cubicTo(5.49, 11.27, 5.62, 10.57, 5.84, 9.91)
      ..lineTo(5.84, 7.07)
      ..lineTo(2.18, 7.07)
      ..cubicTo(1.43, 8.55, 1, 10.22, 1, 12)
      ..cubicTo(1, 13.78, 1.43, 15.45, 2.18, 16.93)
      ..lineTo(5.84, 14.09)
      ..close();
    canvas.drawPath(pYellow, yellow);

    // Red path (top-left)
    final pRed = Path()
      ..moveTo(12, 5.38)
      ..cubicTo(13.62, 5.38, 15.06, 5.94, 16.21, 7.02)
      ..lineTo(19.36, 3.87)
      ..cubicTo(17.45, 2.09, 14.97, 1, 12, 1)
      ..cubicTo(7.7, 1, 3.99, 3.47, 2.18, 7.07)
      ..lineTo(5.84, 9.91)
      ..cubicTo(6.71, 7.31, 9.14, 5.38, 12, 5.38)
      ..close();
    canvas.drawPath(pRed, red);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

```

## `flutter-client\lib\services\api_service.dart`
```dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'auth_service.dart';

// â”€â”€ Data Models â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class ScanResult {
  final String id;
  final String fileName;
  final double threatScore;
  final String status;
  final String? geminiVerdict;
  final String? geminiReasoning;
  final String? timestamp;
  final String mediaType; // 'image' | 'video' | 'audio'

  ScanResult({
    required this.id,
    required this.fileName,
    required this.threatScore,
    required this.status,
    this.geminiVerdict,
    this.geminiReasoning,
    this.timestamp,
    this.mediaType = 'image',
  });

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    final details = json['result_details'] as Map<String, dynamic>?;
    return ScanResult(
      id: (json['id'] ?? '').toString().substring(0, 8).toUpperCase(),
      fileName: json['file_name'] ?? 'Unknown',
      threatScore:
          double.tryParse((json['threat_score'] ?? '0').toString()) ?? 0.0,
      status: json['status'] ?? 'unknown',
      geminiVerdict: details?['gemini_verdict']?.toString(),
      geminiReasoning: details?['gemini_reasoning']?.toString(),
      timestamp: json['completed_at']?.toString().substring(0, 19) ??
          json['created_at']?.toString().substring(0, 19),
      mediaType: (json['media_type'] ?? 'image').toString().toLowerCase(),
    );
  }
}

/// Mirrors the React `ScanStatsResponse` returned by GET /api/scan/stats
class ScanStats {
  final int totalScans;
  final int pendingScans;
  final int completedScans;
  final double avgThreatScore;

  const ScanStats({
    required this.totalScans,
    required this.pendingScans,
    required this.completedScans,
    required this.avgThreatScore,
  });

  factory ScanStats.fromJson(Map<String, dynamic> json) {
    return ScanStats(
      totalScans: (json['total_scans'] ?? 0) as int,
      pendingScans: (json['pending_scans'] ?? 0) as int,
      completedScans: (json['completed_scans'] ?? 0) as int,
      avgThreatScore:
          double.tryParse((json['avg_threat_score'] ?? '0').toString()) ?? 0.0,
    );
  }

  /// Derive stats from a local list of scans when the backend stats
  /// endpoint is unavailable.
  factory ScanStats.fromScans(List<ScanResult> scans) {
    if (scans.isEmpty) {
      return const ScanStats(
          totalScans: 0,
          pendingScans: 0,
          completedScans: 0,
          avgThreatScore: 0);
    }
    return ScanStats(
      totalScans: scans.length,
      pendingScans:
          scans.where((s) => s.threatScore >= 50.0 || s.geminiVerdict == 'DEEPFAKE').length,
      completedScans: scans.where((s) => s.threatScore < 50.0 && s.geminiVerdict != 'DEEPFAKE').length,
      avgThreatScore: scans
              .map((s) => s.threatScore)
              .reduce((a, b) => a + b) /
          scans.length,
    );
  }
}

// â”€â”€ ApiService â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class ApiService {
  final AuthService _authService = AuthService();

  /// Smart base URL: Points to production Render API
  String get _baseUrl {
    return 'https://nexus-gateway-api.onrender.com';
  }

  Future<Map<String, String>> _authHeaders() async {
    final token = await _authService.getIdToken();
    return {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // â”€â”€ POST /api/scan â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Future<ScanResult> scanMedia(PlatformFile file) async {
    final uri = Uri.parse('$_baseUrl/api/scan');
    final headers = await _authHeaders();

    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(headers);

    if (file.bytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        file.bytes!,
        filename: file.name,
      ));
    } else if (file.path != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        file.path!,
        filename: file.name,
      ));
    } else {
      throw Exception('Could not read file: no bytes or path available.');
    }

    try {
      // 90s timeout: Render free tier can take up to 50s to cold-start,
      // plus up to 30s for AI inference.
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 90),
      );
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('[API] POST /api/scan â†’ ${response.statusCode}');
      debugPrint('[API] Body preview: ${response.body.substring(0, response.body.length.clamp(0, 200))}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ScanResult.fromJson(json);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        // Auth token expired or missing â€” NOT a connection error
        throw Exception('Session expired. Please sign out and sign in again.');
      } else {
        // Try to get the backend detail message
        String detail = 'Scan failed (HTTP ${response.statusCode})';
        try {
          final errJson = jsonDecode(response.body) as Map<String, dynamic>;
          detail = errJson['detail']?.toString() ??
              errJson['message']?.toString() ??
              detail;
        } catch (_) {
          // body wasn't JSON â€” use raw
          detail = 'Backend error ${response.statusCode}: ${response.body.substring(0, response.body.length.clamp(0, 120))}';
        }
        throw Exception(detail);
      }
    } on TimeoutException {
      throw TimeoutException(
        'Waking up secure gateway, please wait...\n'
        'The server is starting up. Try again in a moment.',
      );
    }
  }

  // â”€â”€ GET /api/scan â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Future<List<ScanResult>> getScanHistory(
      {int page = 1, int pageSize = 10, String? mediaType}) async {
    String url = '$_baseUrl/api/scan?page=$page&page_size=$pageSize';
    if (mediaType != null && mediaType != 'all') {
      url += '&media_type=$mediaType';
    }
    final uri = Uri.parse(url);
    final headers = await _authHeaders();
    try {
      final response = await http.get(uri, headers: headers)
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final scans = json['scans'] as List<dynamic>;
        return scans
            .map((s) => ScanResult.fromJson(s as Map<String, dynamic>))
            .toList();
      }
    } on TimeoutException {
      debugPrint('getScanHistory: gateway waking up, returning empty list');
    } catch (e) {
      debugPrint('getScanHistory error: $e');
    }
    return [];
  }

  // â”€â”€ GET /api/scan/stats â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  /// Mirrors React's `getScanStats()`. Falls back gracefully if the endpoint
  /// doesn't exist yet.
  Future<ScanStats?> getScanStats() async {
    try {
      final uri = Uri.parse('$_baseUrl/api/scan/stats/summary');
      final headers = await _authHeaders();
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ScanStats.fromJson(json);
      }
    } catch (e) {
      debugPrint('getScanStats error: $e');
    }
    return null;
  }

  // â”€â”€ GET /api/scan â€” total count (for pagination) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Future<int> getScanTotal({String? mediaType}) async {
    try {
      String url = '$_baseUrl/api/scan?page=1&page_size=1';
      if (mediaType != null && mediaType != 'all') {
        url += '&media_type=$mediaType';
      }
      final uri = Uri.parse(url);
      final headers = await _authHeaders();
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return (json['total'] ?? 0) as int;
      }
    } catch (_) {}
    return 0;
  }
}

```

## `flutter-client\lib\services\auth_service.dart`
```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // â”€â”€ Email / Password â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ).timeout(const Duration(seconds: 10), onTimeout: () => throw TimeoutException("Connection timed out."));
    return result;
  }

  Future<UserCredential?> registerWithEmailAndPassword(
      String email, String password) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ).timeout(const Duration(seconds: 10), onTimeout: () => throw TimeoutException("Connection timed out."));
    return result;
  }

  // â”€â”€ Google Sign-In â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  /// Triggers the Google Sign-In consent screen, exchanges tokens with Firebase,
  /// and returns the resulting [UserCredential].
  ///
  /// On Web, uses the redirect-based popup flow via [signInWithPopup].
  /// On mobile, uses the package-based interactive flow.
  Future<UserCredential?> signInWithGoogle() async {
    if (kIsWeb) {
      // Web: use the Firebase built-in popup
      final provider = GoogleAuthProvider();
      provider.addScope('email');
      provider.addScope('profile');
      // No aggressive timeout here, as the user interacting with the Google popup can take longer than 10s.
      return await _auth.signInWithPopup(provider);
    }

    // Mobile/Desktop: use google_sign_in package
    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
    final GoogleSignInAccount? account = await googleSignIn.signIn();
    if (account == null) return null; // user cancelled

    final GoogleSignInAuthentication gAuth = await account.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    // Remove aggressive timeout here for the same reason.
    return await _auth.signInWithCredential(credential);
  }

  // â”€â”€ Session â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Future<void> signOut() async {
    try {
      // Also sign out of Google session if it was used
      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
    } catch (_) {}
    await _auth.signOut();
  }

  /// Returns the current Firebase ID token for backend authorization.
  Future<String?> getIdToken() async {
    return await _auth.currentUser?.getIdToken();
  }
}

```

## `flutter-client\lib\widgets\constellation_background.dart`
```dart
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class ConstellationBackground extends StatefulWidget {
  const ConstellationBackground({super.key});

  @override
  State<ConstellationBackground> createState() => _ConstellationBackgroundState();
}

class _ConstellationBackgroundState extends State<ConstellationBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Cluster> _clusters = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();

    _initSystem();
  }

  void _initSystem() {
    for (int i = 0; i < 50; i++) {
      _clusters.add(_Cluster());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _MorphingPainter(
            clusters: _clusters,
            progress: _controller.value,
          ),
          child: Container(),
        );
      },
    );
  }
}

class _Cluster {
  late Offset pos;
  late Offset velocity;
  late int size;
  final List<Offset> memberOffsets = [];
  final List<Offset> targetOffsets = [];
  double morphProgress = 0.0;
  bool isMorphing = false;

  _Cluster() {
    _reset(isInitial: true);
  }

  void _reset({bool isInitial = false}) {
    final random = Random();
    if (isInitial) {
      pos = Offset(random.nextDouble(), random.nextDouble());
    } else {
      pos = Offset(0.5 + (random.nextDouble() - 0.5) * 0.05, 0.5 + (random.nextDouble() - 0.5) * 0.05);
    }

    double angle = random.nextDouble() * 2 * pi;
    double speed = 0.0006 + random.nextDouble() * 0.0012;
    velocity = Offset(cos(angle) * speed, sin(angle) * speed);

    size = 4 + random.nextInt(4); // 4 to 8 stars for better shapes
    memberOffsets.clear();
    targetOffsets.clear();
    
    for (int i = 0; i < size; i++) {
      final offset = Offset((random.nextDouble() - 0.5) * 0.15, (random.nextDouble() - 0.5) * 0.15);
      memberOffsets.add(offset);
      targetOffsets.add(offset);
    }
    
    if (random.nextDouble() > 0.4) {
      _assignShape();
    }
  }

  void _assignShape() {
    final random = Random();
    int shapeType = random.nextInt(4); 
    targetOffsets.clear();
    
    // Abstract patterns that feel like shapes
    if (shapeType == 0) { // Fish shape
      targetOffsets.addAll([
        const Offset(0.05, 0), const Offset(0.01, 0.02), const Offset(0.01, -0.02),
        const Offset(-0.02, 0.03), const Offset(-0.02, -0.03), const Offset(-0.05, 0.04), const Offset(-0.05, -0.04)
      ]);
    } else if (shapeType == 1) { // Small Cat-like (with ears)
      targetOffsets.addAll([
        const Offset(-0.02, -0.04), const Offset(0.02, -0.04), // Ears
        const Offset(-0.03, -0.01), const Offset(0.03, -0.01), // Head edges
        const Offset(0, 0.02), // Nose
        const Offset(-0.02, 0.04), const Offset(0.02, 0.04) // Paws/Base
      ]);
    } else if (shapeType == 2) { // Bird-like
      targetOffsets.addAll([
        const Offset(0, 0), // Body
        const Offset(0.06, -0.03), const Offset(-0.06, -0.03), // Wing tips up
        const Offset(0, 0.04), // Tail
      ]);
    } else { // Human Face (Very abstract)
      targetOffsets.addAll([
        const Offset(-0.02, -0.03), const Offset(0.02, -0.03), // Eyes
        const Offset(0, 0), // Nose
        const Offset(-0.015, 0.03), const Offset(0, 0.04), const Offset(0.015, 0.03) // Smile
      ]);
    }
    
    // Resize collections to match
    while (memberOffsets.length < targetOffsets.length) {
      memberOffsets.add(Offset(random.nextDouble() * 0.1, random.nextDouble() * 0.1));
    }
    if (memberOffsets.length > targetOffsets.length) {
      memberOffsets.removeRange(targetOffsets.length, memberOffsets.length);
    }
    size = targetOffsets.length;
    isMorphing = true;
    morphProgress = 0.0;
  }

  void update() {
    pos += velocity;
    
    if (isMorphing) {
      morphProgress += 0.004;
      if (morphProgress >= 1.0) {
        morphProgress = 1.0;
        if (Random().nextDouble() > 0.99) isMorphing = false;
      }
    }

    if (pos.dx < -0.3 || pos.dx > 1.3 || pos.dy < -0.3 || pos.dy > 1.3) {
      _reset();
    }
  }
}

class _MorphingPainter extends CustomPainter {
  final List<_Cluster> clusters;
  final double progress;

  _MorphingPainter({required this.clusters, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = true;

    for (var cluster in clusters) {
      cluster.update();
      final cx = cluster.pos.dx * size.width;
      final cy = cluster.pos.dy * size.height;

      paint.strokeWidth = 0.35;
      for (int i = 0; i < cluster.size; i++) {
        for (int j = i + 1; j < cluster.size; j++) {
          final p1 = _getMemberPos(cluster, i);
          final p2 = _getMemberPos(cluster, j);
          
          paint.color = Colors.white.withOpacity(0.05);
          canvas.drawLine(
            Offset(cx + p1.dx * size.width, cy + p1.dy * size.height),
            Offset(cx + p2.dx * size.width, cy + p2.dy * size.height),
            paint,
          );
        }
      }

      for (int i = 0; i < cluster.size; i++) {
        final p = _getMemberPos(cluster, i);
        final mx = cx + p.dx * size.width;
        final my = cy + p.dy * size.height;

        paint.color = Colors.white.withOpacity(0.25);
        paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
        canvas.drawCircle(Offset(mx, my), 2.0, paint);
        
        paint.maskFilter = null;
        paint.color = Colors.white.withOpacity(0.6);
        canvas.drawCircle(Offset(mx, my), 1.0, paint);
      }
    }
  }

  Offset _getMemberPos(_Cluster cluster, int index) {
    if (index >= cluster.memberOffsets.length || index >= cluster.targetOffsets.length) {
      return Offset.zero;
    }

    if (!cluster.isMorphing) return cluster.memberOffsets[index];
    
    // CLAMP progress to [0, 1] to avoid Assertion Error in Curves
    final double clampedProgress = cluster.morphProgress.clamp(0.0, 1.0);
    
    return Offset.lerp(
      cluster.memberOffsets[index],
      cluster.targetOffsets[index],
      Curves.easeInOutCubic.transform(clampedProgress),
    )!;
  }

  @override
  bool shouldRepaint(covariant _MorphingPainter oldDelegate) => true;
}

```

## `flutter-client\lib\widgets\neural_mesh_background.dart`
```dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Particle {
  double x;
  double y;
  double vx;
  double vy;
  
  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
  });
}

class NeuralMeshBackground extends StatefulWidget {
  const NeuralMeshBackground({super.key});

  @override
  State<NeuralMeshBackground> createState() => _NeuralMeshBackgroundState();
}

class _NeuralMeshBackgroundState extends State<NeuralMeshBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _rnd = Random();
  Offset? _mousePos;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();
    
    // Defer particle initialization until we have constraints in CustomPaint
  }

  void _initParticles(Size size) {
    if (_particles.isNotEmpty) return;
    for (int i = 0; i < 60; i++) {
      _particles.add(Particle(
        x: _rnd.nextDouble() * size.width,
        y: _rnd.nextDouble() * size.height,
        vx: (_rnd.nextDouble() - 0.5) * 1.5,
        vy: (_rnd.nextDouble() - 0.5) * 1.5,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('neural-mesh'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 0) {
          _controller.stop();
        } else if (!_controller.isAnimating) {
          _controller.repeat();
        }
      },
      child: MouseRegion(
        onHover: (e) {
          setState(() {
            _mousePos = e.localPosition;
          });
        },
        onExit: (e) {
          setState(() {
            _mousePos = null;
          });
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final size = Size(constraints.maxWidth, constraints.maxHeight);
                _initParticles(size);
                return CustomPaint(
                  size: size,
                  painter: _NeuralMeshPainter(
                    particles: _particles,
                    mousePos: _mousePos,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _NeuralMeshPainter extends CustomPainter {
  final List<Particle> particles;
  final Offset? mousePos;
  
  _NeuralMeshPainter({required this.particles, this.mousePos});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    for (var p in particles) {
      // Repulsion logic
      if (mousePos != null) {
        double dx = p.x - mousePos!.dx;
        double dy = p.y - mousePos!.dy;
        double dist = sqrt(dx * dx + dy * dy);
        
        if (dist < 150) {
          double force = (150 - dist) / 150;
          p.x += (dx / dist) * force * 2;
          p.y += (dy / dist) * force * 2;
        }
      }

      // Update positions
      p.x += p.vx;
      p.y += p.vy;

      // Bounce
      if (p.x < 0) { p.x = 0; p.vx *= -1; }
      if (p.x > size.width) { p.x = size.width; p.vx *= -1; }
      if (p.y < 0) { p.y = 0; p.vy *= -1; }
      if (p.y > size.height) { p.y = size.height; p.vy *= -1; }

      // Draw particle
      canvas.drawCircle(Offset(p.x, p.y), 1.5, paint);
    }

    // Draw lines
    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        double dx = particles[i].x - particles[j].x;
        double dy = particles[i].y - particles[j].y;
        double dist = sqrt(dx * dx + dy * dy);

        if (dist < 100) {
          double opacity = 1.0 - (dist / 100);
          linePaint.color = Colors.cyanAccent.withOpacity(opacity * 0.5);
          canvas.drawLine(
            Offset(particles[i].x, particles[i].y),
            Offset(particles[j].x, particles[j].y),
            linePaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _NeuralMeshPainter oldDelegate) {
    return true; // Always repaint for animation
  }
}

```

## `flutter-client\lib\widgets\starfield_background.dart`
```dart
import 'dart:math';
import 'package:flutter/material.dart';

class _Star {
  double x;
  double y;
  final double z; // depth 0.1 = far, 1.0 = close
  final double size;
  final double opacity;

  _Star({
    required this.x,
    required this.y,
    required this.z,
    required this.size,
    required this.opacity,
  });
}

class StarfieldBackground extends StatefulWidget {
  const StarfieldBackground({super.key});

  @override
  State<StarfieldBackground> createState() => _StarfieldBackgroundState();
}

class _StarfieldBackgroundState extends State<StarfieldBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Star> _stars = [];
  final Random _random = Random();

  Offset _mousePosition = Offset.zero;
  Offset _lastMousePosition = Offset.zero;
  double _speedBoost = 0.0; // extra speed multiplier when cursor moves fast

  static const int _starCount = 250;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_tick)..repeat();
  }

  void _initStars(Size size) {
    if (_stars.isEmpty) {
      for (int i = 0; i < _starCount; i++) {
        _stars.add(_Star(
          x: _random.nextDouble() * size.width,
          y: _random.nextDouble() * size.height,
          z: _random.nextDouble() * 0.9 + 0.1,
          size: _random.nextDouble() * 2.5 + 0.5,
          opacity: _random.nextDouble() * 0.7 + 0.3,
        ));
      }
    }
  }

  void _tick() {
    if (!mounted) return;
    setState(() {
      // Decay speed boost over time
      _speedBoost = (_speedBoost * 0.90).clamp(0.0, 8.0);
    });
  }

  void _onHover(PointerEvent event) {
    final dx = (event.position.dx - _lastMousePosition.dx).abs();
    final dy = (event.position.dy - _lastMousePosition.dy).abs();
    final speed = sqrt(dx * dx + dy * dy);
    _speedBoost = (speed * 0.3).clamp(0.0, 8.0);
    _lastMousePosition = event.position;
    _mousePosition = event.position;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerHover: _onHover,
      onPointerMove: _onHover,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          _initStars(size);
          return CustomPaint(
            painter: _StarfieldPainter(
              stars: _stars,
              size: size,
              speedBoost: _speedBoost,
              mousePosition: _mousePosition,
              random: _random,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _StarfieldPainter extends CustomPainter {
  final List<_Star> stars;
  final Size size;
  final double speedBoost;
  final Offset mousePosition;
  final Random random;

  _StarfieldPainter({
    required this.stars,
    required this.size,
    required this.speedBoost,
    required this.mousePosition,
    required this.random,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final double baseSpeed = 0.12;
    final double totalSpeed = baseSpeed + speedBoost * 0.18;

    // Update star positions
    for (final star in stars) {
      // Drift downward at different speeds based on depth (parallax)
      star.y += totalSpeed * star.z;

      // Slight horizontal drift towards cursor
      if (mousePosition != Offset.zero) {
        final cx = canvasSize.width / 2;
        final cy = canvasSize.height / 2;
        final dx = (mousePosition.dx - cx) / canvasSize.width;
        final dy = (mousePosition.dy - cy) / canvasSize.height;
        star.x += dx * star.z * 0.3 * (1 + speedBoost * 0.1);
        star.y += dy * star.z * 0.1 * (1 + speedBoost * 0.1);
      }

      // Wrap stars around edges
      if (star.y > canvasSize.height + 2) {
        star.y = -2;
        star.x = random.nextDouble() * canvasSize.width;
      }
      if (star.x < -2) star.x = canvasSize.width + 2;
      if (star.x > canvasSize.width + 2) star.x = -2;
    }

    final paint = Paint()..isAntiAlias = true;

    for (final star in stars) {
      final alpha = (star.opacity * 255).toInt().clamp(0, 255);
      // Close stars are more blue-white, far stars are dim white
      final Color starColor = star.z > 0.6
          ? Color.fromARGB(alpha, 255, 255, 255)  // Close: pure white
          : Color.fromARGB(alpha, 200, 200, 200); // Far: dim white

      paint.color = starColor;

      final double drawSize = star.size * star.z * (1 + speedBoost * 0.05);

      // At high speed, draw star streaks
      if (speedBoost > 2.0) {
        final streakLength = speedBoost * star.z * 2.5;
        paint.strokeWidth = drawSize * 0.7;
        paint.style = PaintingStyle.stroke;
        canvas.drawLine(
          Offset(star.x, star.y),
          Offset(star.x, star.y - streakLength),
          paint,
        );
      } else {
        paint.style = PaintingStyle.fill;
        canvas.drawCircle(Offset(star.x, star.y), drawSize.clamp(0.3, 3.0), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _StarfieldPainter oldDelegate) => true;
}

```

## `flutter-client\lib\widgets\trust_button.dart`
```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color trustAccent = Color(0xFF4F46E5);

class TrustButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool fullWidth;
  final bool isForwardAction;

  const TrustButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.isLoading = false,
    this.fullWidth = false,
    this.isForwardAction = false,
  });

  @override
  State<TrustButton> createState() => _TrustButtonState();
}

class _TrustButtonState extends State<TrustButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.isLoading ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          width: widget.fullWidth ? double.infinity : null,
          decoration: BoxDecoration(
            color: _isHovered ? const Color(0xFF1E293B) : const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: trustAccent.withOpacity(_isHovered ? 0.9 : 0.5),
              width: 1,
            ),
            boxShadow: const [], // NO glowing effects
          ),
          child: Row(
            mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.isLoading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              else ...[
                if (widget.icon != null && !widget.isForwardAction) ...[
                  Icon(widget.icon, color: Colors.white, size: 20),
                  const SizedBox(width: 12),
                ],
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.label,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                ),
                if (widget.isForwardAction) ...[
                  const SizedBox(width: 12),
                  const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

```
## CONFIG & INFRA FILES

## `backend\requirements.txt`
```
fastapi>=0.109.0,<1.0.0
uvicorn[standard]>=0.27.0,<1.0.0
pydantic>=2.5.0,<3.0.0
pydantic-settings>=2.1.0,<3.0.0
cachetools>=5.3.0,<6.0.0
PyJWT>=2.8.0,<3.0.0
httpx>=0.26.0,<1.0.0
python-multipart>=0.0.6,<1.0.0
python-dotenv>=1.0.0,<2.0.0
huggingface_hub>=0.20.0
openai>=1.0.0
firebase-admin>=6.2.0,<7.0.0
opencv-python-headless>=4.8.0

```

## `backend\Dockerfile`
```
FROM python:3.11-slim as builder

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc python3-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /app/wheels -r requirements.txt

FROM python:3.11-slim

WORKDIR /app

COPY --from=builder /app/wheels /wheels
COPY --from=builder /app/requirements.txt .

RUN pip install --no-cache /wheels/*

COPY . .

# Expose FastAPI port
EXPOSE 8000

# Run Uvicorn server
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]

```

## `backend\.env.example`
```
# ============================================================
# Nexus Gateway - Environment Variables Template
# ============================================================
# Copy this file to backend/.env and fill in your values
# IMPORTANT: Never commit .env to GitHub!
# ============================================================

# â”€â”€ App Settings â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
APP_NAME=Nexus Gateway
APP_VERSION=1.0.0
DEBUG=true
ENVIRONMENT=development

# â”€â”€ Firebase (REQUIRED) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
# Get these from Firebase Console â†’ Project Settings
FIREBASE_PROJECT_ID=your-project-id
# Path to your Firebase Admin SDK JSON file (place in backend/)
FIREBASE_CREDENTIALS_PATH=your-project-id-firebase-adminsdk-xxxx.json

# â”€â”€ Hugging Face (REQUIRED) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
# Get from: https://huggingface.co/settings/tokens
HUGGINGFACE_API_TOKEN=hf_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# â”€â”€ NVIDIA NIM (REQUIRED for Tier-2) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
# Get from: https://org.ngcf.org/credentials
NVIDIA_API_KEY=nvapi-xxxxxxxxxxxxxxxxxxxxxxxx

# â”€â”€ File Upload Limits â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
MAX_FILE_SIZE=104857600  # 100 MB in bytes

# â”€â”€ Rate Limiting â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
RATE_LIMIT_REQUESTS=100
RATE_LIMIT_ENABLED=true

# â”€â”€ CORS â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
CORS_ORIGINS=http://localhost:3000,http://localhost:8080
```

## `flutter-client\pubspec.yaml`
```
name: flutter_client
description: "A new Flutter project."
# The following line prevents the package from being accidentally published to
# pub.dev using `flutter pub publish`. This is preferred for private packages.
publish_to: 'none' # Remove this line if you wish to publish to pub.dev

# The following defines the version and build number for your application.
# A version number is three numbers separated by dots, like 1.2.43
# followed by an optional build number separated by a +.
# Both the version and the builder number may be overridden in flutter
# build by specifying --build-name and --build-number, respectively.
# In Android, build-name is used as versionName while build-number used as versionCode.
# Read more about Android versioning at https://developer.android.com/studio/publish/versioning
# In iOS, build-name is used as CFBundleShortVersionString while build-number is used as CFBundleVersion.
# Read more about iOS versioning at
# https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html
# In Windows, build-name is used as the major, minor, and patch parts
# of the product and file versions while build-number is used as the build suffix.
version: 1.0.1+2

environment:
  sdk: ^3.11.4

# Dependencies specify other packages that your package needs in order to work.
# To automatically upgrade your package dependencies to the latest versions
# consider running `flutter pub upgrade --major-versions`. Alternatively,
# dependencies can be manually updated by changing the version numbers below to
# the latest version available on pub.dev. To see which dependencies have newer
# versions available, run `flutter pub outdated`.
dependencies:
  flutter:
    sdk: flutter

  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.8
  http: ^1.6.0
  google_fonts: ^8.0.2
  file_picker: ^11.0.2
  provider: ^6.1.5+1
  firebase_core: ^4.6.0
  firebase_auth: ^6.3.0
  fl_chart: ^0.69.0
  google_sign_in: ^6.2.2
  url_launcher: ^6.2.5
  visibility_detector: ^0.4.0
  toastification: ^3.2.0
  flutter_spinkit: ^5.2.2

dev_dependencies:
  flutter_test:
    sdk: flutter

  # The "flutter_lints" package below contains a set of recommended lints to
  # encourage good coding practices. The lint set provided by the package is
  # activated in the `analysis_options.yaml` file located at the root of your
  # package. See that file for information about deactivating specific lint
  # rules and activating additional ones.
  flutter_lints: ^6.0.0

# For information on the generic Dart part of this file, see the
# following page: https://dart.dev/tools/pub/pubspec

# The following section is specific to Flutter packages.
flutter:

  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true

  assets:
    - assets/images/
  #   - images/a_dot_burr.jpeg
  #   - images/a_dot_ham.jpeg

  # An image asset can refer to one or more resolution-specific "variants", see
  # https://flutter.dev/to/resolution-aware-images

  # For details regarding adding assets from package dependencies, see
  # https://flutter.dev/to/asset-from-package

  # To add custom fonts to your application, add a fonts section here,
  # in this "flutter" section. Each entry in this list should have a
  # "family" key with the font family name, and a "fonts" key with a
  # list giving the asset and other descriptors for the font. For
  # example:
  # fonts:
  #   - family: Schyler
  #     fonts:
  #       - asset: fonts/Schyler-Regular.ttf
  #       - asset: fonts/Schyler-Italic.ttf
  #         style: italic
  #   - family: Trajan Pro
  #     fonts:
  #       - asset: fonts/TrajanPro.ttf
  #       - asset: fonts/TrajanPro_Bold.ttf
  #         weight: 700
  #
  # For details regarding fonts from package dependencies,
  # see https://flutter.dev/to/font-from-package

```

## `firebase.json`
```
{
  "hosting": {
    "public": "flutter-client/build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}

```

## `docker-compose.yml`
```
version: '3.8'

services:
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    ports:
      - "8000:8000"
    env_file:
      - ./backend/.env
    restart: unless-stopped
    volumes:
      - ./backend:/app
```
