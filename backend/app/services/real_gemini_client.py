"""
Real Google Gemini Flash client for deepfake/AI-image detection.
Uses the Gemini REST API directly via httpx (already in requirements).
Model: gemini-2.0-flash  — fast, multimodal, free tier available.
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
        logger.warning("[GEMINI] GEMINI_API_KEY not set — skipping Gemini analysis.")
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
        with httpx.Client(timeout=15.0) as client:
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
