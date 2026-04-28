"""
Firebase Admin SDK — Singleton Initializer.
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
        logger.info("[Firebase] Already initialized — skipping.")
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
            f"[Firebase] Admin SDK initialized via JSON string — project: {settings.FIREBASE_PROJECT_ID}"
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
            f"[Firebase] Admin SDK initialized via file — project: {settings.FIREBASE_PROJECT_ID}"
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
