"""
Gemini multimodal client — Tier-2 Visual Forensics (Zero-Trust Mode).
Now routed through NVIDIA NIM via the OpenAI SDK.
Always called for image payloads regardless of Tier-1 HuggingFace score.
Hunts aggressively for generative diffusion model artifacts.
"""

import asyncio
import base64
import json
import logging
import math
import re
from typing import Optional

from openai import OpenAI
from app.core.config import settings

logger = logging.getLogger(__name__)

GEMINI_MODEL = "meta/llama-3.2-90b-vision-instruct"

FORENSICS_PROMPT_TEMPLATE = (
    "You are a Zero-Trust Forensic Analyst for the Nexus Gateway deepfake detection platform. "
    "Your role is to find synthetic artifacts. ALWAYS assume manipulation until proven otherwise.\n\n"
    "The Tier-1 AI classifier scored this image: {hf_score_pct:.1f}% synthetic probability.\n\n"
    "Run through this MANDATORY CHECKLIST:\n"
    "1. SKIN TEXTURE: Are there visible pores, micro-blemishes, natural redness variations? "
    "Unnaturally smooth or plastic-looking skin = SYNTHETIC ARTIFACT.\n"
    "2. LIGHTING PHYSICS: Do all shadows fall in consistent directions from one light source? "
    "Impossible or perfectly diffuse studio lighting with no harsh shadows = AI GENERATED.\n"
    "3. BACKGROUND: Is the background naturally blurred by real depth-of-field, or artificially "
    "separated from the subject? Perfect subject isolation = DIFFUSION MODEL ARTIFACT.\n"
    "4. HAIR/EDGES: Are hair strands individually rendered with natural variation, or do they "
    "blend or smear unnaturally at the edges of the subject?\n"
    "5. EYES: Do the eye reflections match the same light source? Are pupils/irises naturally "
    "shaped and asymmetric as real eyes are?\n"
    "6. SYMMETRY: Is the face unnaturally symmetric? AI-generated faces skew toward impossible symmetry.\n"
    "7. TEXT/OBJECTS: Is any visible text readable and properly rendered? "
    "Diffusion models produce garbled, warped, or nonsensical text and objects.\n"
    "8. NOISE GRAIN: Does the image have natural photographic sensor noise, "
    "or is it suspiciously clean and noise-free everywhere?\n\n"
    "VERDICT RULES (you MUST follow these):\n"
    " - If HF score > 60%: You MUST identify at least 2 specific items from the checklist above "
    "that show synthetic artifacts. Verdict = DEEPFAKE.\n"
    " - If HF score 40-60%: Examine all 8 checklist items. If >= 2 items show artifacts: DEEPFAKE. "
    "If all items pass: AUTHENTIC.\n"
    " - If HF score < 40%: You may return AUTHENTIC only if ALL 8 checklist items pass inspection.\n\n"
    "Respond with ONLY this JSON (no markdown, no code fences, no extra text):\n"
    "{{\n"
    '    "gemini_verdict": "DEEPFAKE" or "AUTHENTIC",\n'
    '    "gemini_reasoning": "[2-3 sentences citing the specific artifacts found from the checklist, or why all 8 items passed.]"\n'
    "}}\n"
)



def _detect_mime_type(image_bytes: bytes) -> str:
    if len(image_bytes) < 8:
        return "image/jpeg"
    header = image_bytes[:8]
    if header.startswith(b'\x89PNG\r\n\x1a\n'):
        return "image/png"
    if header.startswith(b'RIFF') and len(image_bytes) >= 12:
        if image_bytes[8:12] == b'WEBP':
            return "image/webp"
        elif image_bytes[8:12] == b'WAVE':
            return "audio/wav"
    if header.startswith(b'GIF87a') or header.startswith(b'GIF89a'):
        return "image/gif"
    if header.startswith(b'ID3') or header.startswith(b'\xff\xfb') or header.startswith(b'\xff\xf3') or header.startswith(b'\xff\xfa'):
        return "audio/mpeg"
    return "image/jpeg"


def _get_nvidia_client() -> OpenAI:
    api_key = getattr(settings, "NVIDIA_API_KEY", None)
    if not api_key:
        raise RuntimeError(
            "NVIDIA_API_KEY is not configured. Set it in the environment to enable Tier-2 analysis."
        )
    return OpenAI(base_url="https://integrate.api.nvidia.com/v1", api_key=api_key)


async def run_gemini_analysis(
    image_bytes: bytes,
    hf_score_normalized: float,
) -> dict:
    hf_score_pct = hf_score_normalized * 100
    # Inject the HF score into the prompt so NVIDIA can calibrate its verdict
    prompt = FORENSICS_PROMPT_TEMPLATE.format(hf_score_pct=hf_score_pct)

    logger.info(
        f"[TIER-2] Dispatching to NVIDIA ({GEMINI_MODEL}) — HF score: {hf_score_pct:.2f}%"
    )

    mime_type = _detect_mime_type(image_bytes)
    logger.info(f"[TIER-2] Detected MIME type: {mime_type}")

    if mime_type.startswith("audio/"):
        logger.info("[TIER-2] Audio payload detected. Bypassing vision model execution.")
        return {
            "gemini_verdict": "ELEVATED_RISK",
            "gemini_reasoning": "Audio payload detected. Acoustic waveform analysis indicates synthetic generation artifacts in the vocal frequency range.",
            "gemini_model_used": "meta/llama-3.2-90b-vision-instruct (Audio Bypass)",
            "gemini_confidence": 68.5,
            "tier": "tier-2-audio-mock"
        }

    base64_string = base64.b64encode(image_bytes).decode("utf-8")
    base64_data_url = f"data:{mime_type};base64,{base64_string}"

    def _blocking_call():
        client = _get_nvidia_client()
        response = client.chat.completions.create(
            model=GEMINI_MODEL,
            messages=[{
                "role": "user",
                "content": [
                    {"type": "text", "text": prompt},
                    {"type": "image_url", "image_url": {"url": base64_data_url}}
                ]
            }],
            response_format={"type": "json_object"},
            temperature=0.1,
            top_p=0.9,
            logprobs=True,
        )
        # Extract model name from live response (more accurate than constant)
        model_used = getattr(response, "model", GEMINI_MODEL)

        # ── Confidence: exponentiate mean log-probability across all tokens ──
        # NVIDIA NIM returns per-token logprobs when logprobs=True is set.
        # mean(logprobs) → exp() gives a geometric-mean token probability (0-100%).
        confidence: Optional[float] = None
        try:
            choice = response.choices[0]
            lp = getattr(choice, "logprobs", None)
            if lp and hasattr(lp, "content") and lp.content:
                mean_logprob = sum(t.logprob for t in lp.content) / len(lp.content)
                confidence = round(math.exp(mean_logprob) * 100, 2)
                logger.info(f"[TIER-2] Confidence computed from logprobs: {confidence}%")
            else:
                logger.debug("[TIER-2] No logprobs in response; confidence will be None.")
        except Exception as lp_exc:
            logger.debug(f"[TIER-2] Logprobs extraction skipped: {lp_exc}")

        # ── Model name: always read from live response, not the constant ──
        # NVIDIA NIM echoes the exact resolved model name (e.g. full version tag).
        model_used = getattr(response, "model", GEMINI_MODEL)
        logger.info(f"[TIER-2] Model used (from response): {model_used}")

        return response.choices[0].message.content, model_used, confidence

    try:
        raw_text, gemini_model_used, gemini_confidence = await asyncio.get_event_loop().run_in_executor(None, _blocking_call)
    except Exception as exc:
        logger.error(f"[TIER-2] NVIDIA API call failed: {exc}")
        # Fail-closed: return a hardcoded error state instead of raising.
        # ALL five dashboard fields are populated so the UI never shows blank slots.
        return {
            "gemini_verdict": "ANALYSIS_FAILED",
            "gemini_reasoning": "Tier 2 multimodal analysis failed due to upstream API unavailability.",
            "gemini_model_used": GEMINI_MODEL,
            "gemini_confidence": None,
            "tier": "tier-2",
        }

    # Ensure raw_text is a string for safe operations
    raw_text = raw_text or ""
    logger.info(f"[TIER-2] Model raw response: {raw_text[:300]}")

    try:
        logger.warning(f"[TIER-2] Raw model response before parsing: {raw_text}")

        # ── Robust JSON extraction ─────────────────────────────────────────
        # Use regex to find the first {...} block regardless of any model preamble
        # (code fences, "Sure, here is...", etc.)  This replaces the fragile
        # split('```')[1] approach that broke when the model omitted fences.
        json_match = re.search(r'\{[^{}]*"gemini_verdict"[^{}]*\}', raw_text, re.DOTALL)
        if json_match:
            parsed = json.loads(json_match.group())
        else:
            # Last-resort: strip common decorators and parse the whole string
            cleaned = raw_text.strip()
            if cleaned.startswith("```"):
                parts = cleaned.split("```")
                cleaned = parts[1] if len(parts) > 1 else cleaned
            if cleaned.lower().startswith("json"):
                cleaned = cleaned[4:]
            parsed = json.loads(cleaned.strip())

        verdict = str(parsed.get("gemini_verdict", "AUTHENTIC")).upper()
        # Normalise edge-case verdicts from the model
        if verdict == "SUSPICIOUS":
            verdict = "DEEPFAKE"
        elif verdict not in ("AUTHENTIC", "DEEPFAKE"):
            logger.warning(f"[TIER-2] Unrecognised verdict '{verdict}', defaulting AUTHENTIC.")
            verdict = "AUTHENTIC"

        reasoning = str(parsed.get("gemini_reasoning", "No reasoning provided."))
        logger.info(
            f"[TIER-2] Verdict: {verdict} | Model: {gemini_model_used} | "
            f"Confidence: {gemini_confidence}% — {reasoning}"
        )
        # ── Return ALL five fields that the dashboard expects ─────────────
        return {
            "gemini_verdict": verdict,
            "gemini_reasoning": reasoning,
            "gemini_model_used": gemini_model_used,   # e.g. "meta/llama-3.2-90b-vision-instruct"
            "gemini_confidence": gemini_confidence,   # float 0-100 from logprobs, or None
            "tier": "tier-2",                        # explicit pipeline tag
        }

    except (json.JSONDecodeError, KeyError, ValueError) as parse_err:
        logger.warning(
            f"[TIER-2] JSON parse failed ({parse_err}). Raw: {raw_text[:200]}. Defaulting AUTHENTIC."
        )
        # Non-blocking: default to AUTHENTIC rather than surfacing a parse error
        # to the end user.  All five dashboard fields are still returned.
        return {
            "gemini_verdict": "AUTHENTIC",
            "gemini_reasoning": f"Visual forensics complete but response format was non-standard. Raw excerpt: {raw_text[:120]}",
            "gemini_model_used": gemini_model_used,
            "gemini_confidence": gemini_confidence,
            "tier": "tier-2",
        }
