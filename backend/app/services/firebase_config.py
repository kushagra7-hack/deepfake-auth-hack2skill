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
    os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = settings.FIREBASE_CREDENTIALS_PATH
    cred = credentials.Certificate(settings.FIREBASE_CREDENTIALS_PATH)
    _firebase_app = firebase_admin.initialize_app(cred, {
        "projectId": settings.FIREBASE_PROJECT_ID,
    })
    logger.info(
        f"[Firebase] Admin SDK initialized — project: {settings.FIREBASE_PROJECT_ID}"
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
