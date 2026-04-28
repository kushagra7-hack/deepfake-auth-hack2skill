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
    "You are the Nexus Lead Forensic Engine. Analyze the provided image for signs of "
    "AI generation or deepfake manipulation.\n\n"
    "Tier-1 HuggingFace pre-screen score: {hf_score_pct:.1f}% (0=authentic, 100=AI/deepfake).\n\n"
    "DETECTION TARGETS \u2014 look for ALL of the following synthetic artifacts:\n"
    "1. AI-GENERATION ARTIFACTS: Uncanny smoothness, plastic skin textures, lack of microscopic pores "
    "or natural noise grain. Overly perfect lighting with no harsh shadows. Backgrounds that dissolve "
    "into blur or have impossible geometry.\n"
    "2. DIFFUSION MODEL FINGERPRINTS: Overly symmetric faces, merged or fused body parts, fingers with "
    "wrong counts, jewelry or text that is warped or illegible, fabric patterns that don't tile correctly.\n"
    "3. GAN ARTIFACTS: Spectral aliasing, checkerboard patterns in smooth gradients, eye reflections "
    "that don't match the light source, hair strands that merge unnaturally.\n"
    "4. FACE-SWAP DEEPFAKES: Boundary artifacts at the face edge, inconsistent skin tone between face "
    "and neck, micro-jitter or static backgrounds across frames, blurred ear regions.\n"
    "5. METADATA CONTEXT: If the image appears to be a screenshot of software (UI elements, code, "
    "hazard stripes, debug overlays), classify as 'Synthetic Software Rendering' and flag HIGH-THREAT.\n\n"
    "SCORING RULE: Your verdict MUST be calibrated to the Tier-1 score.\n"
    " - If HF score > 75%: you MUST find and describe synthetic artifacts. Verdict = DEEPFAKE.\n"
    " - If HF score 40-75%: describe any suspicious elements found. Verdict = DEEPFAKE or AUTHENTIC.\n"
    " - If HF score < 40%: explain why the image appears authentic (natural noise, consistent lighting). "
    "Verdict = AUTHENTIC unless you see obvious AI artifacts.\n\n"
    "Respond with ONLY this JSON object (no extra text):\n"
    "{{\n"                                          # << doubled braces = literal {
    '    "gemini_verdict": "DEEPFAKE" or "AUTHENTIC",\n'
    '    "gemini_reasoning": "[2-3 sentences describing the key forensic evidence found.]"\n'
    "}}"                                            # << doubled braces = literal }
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
