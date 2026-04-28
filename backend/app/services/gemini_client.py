"""
Tier-2 Visual Forensics — NVIDIA NIM (LLaMA 3.2 90B Vision).
Uses synchronous OpenAI client wrapped in run_in_executor (proven stable).
10-point forensic checklist prompt.
"""

import asyncio
import base64
import io
import json
import logging
import math
import re
from typing import Optional

from openai import OpenAI
from app.core.config import settings

logger = logging.getLogger(__name__)

NVIDIA_MODEL        = "meta/llama-3.2-90b-vision-instruct"
MAX_IMAGE_LONG_EDGE = 1024
MAX_IMAGE_BYTES     = 300_000

# ---------------------------------------------------------------------------
# Forensic prompt — 10-point Zero-Trust checklist
# ---------------------------------------------------------------------------

FORENSICS_PROMPT_TEMPLATE = (
    "You are a Zero-Trust Forensic Analyst operating within the Nexus Gateway deepfake detection platform. "
    "Your mandate is to uncover synthetic, AI-generated, or GAN/diffusion-model manipulated media. "
    "ALWAYS presume manipulation until forensic evidence conclusively proves otherwise. "
    "You do not give the benefit of the doubt — you find the artifacts.\n\n"

    "=== TIER-1 CLASSIFIER SIGNAL ===\n"
    "The Tier-1 AI binary classifier scored this image: {hf_score_pct:.1f}% synthetic probability. "
    "This informs your threshold — YOUR visual forensic analysis is the final authority.\n\n"

    "=== MANDATORY 10-POINT FORENSIC CHECKLIST ===\n"
    "Mark each as PASS or FLAG. Be specific — vague observations are inadmissible.\n\n"

    "1. SKIN TEXTURE & MICROSTRUCTURE\n"
    "   FLAG if: unnaturally smooth, plastic, airbrushed skin; missing pores or vellus hair; tiled texture patterns.\n\n"

    "2. LIGHTING PHYSICS & SHADOW CONSISTENCY\n"
    "   FLAG if: shadows in contradictory directions; perfectly diffuse lighting with zero harsh shadows; "
    "specular highlights not sharing a common source.\n\n"

    "3. EYE INTEGRITY\n"
    "   FLAG if: catchlights missing or mismatched between eyes; irises unnaturally vivid or perfectly symmetric; "
    "sclera too clean or showing unnatural glow.\n\n"

    "4. FACIAL SYMMETRY & GEOMETRY\n"
    "   FLAG if: near-perfect bilateral symmetry (strong GAN/diffusion artifact); "
    "idealized proportions beyond normal variance; teeth too uniform or impossibly white.\n\n"

    "5. HAIR & FINE EDGE RENDERING\n"
    "   FLAG if: hair smears or blends into background with halo artifact; "
    "hairline too sharp; hair appears painted on without sub-strand lighting.\n\n"

    "6. BACKGROUND COHERENCE & DEPTH-OF-FIELD\n"
    "   FLAG if: subject appears cut-out with unnaturally sharp boundary; "
    "uniform artificial blur instead of real bokeh; background contains impossible geometry.\n\n"

    "7. TEXT, LOGOS & OBJECT RENDERING\n"
    "   FLAG if: any visible text is garbled, warped, or contains phantom characters; "
    "logos distorted; jewelry or glasses have impossible topology.\n\n"

    "8. SENSOR NOISE & FREQUENCY FINGERPRINT\n"
    "   FLAG if: suspiciously clean image with no grain inconsistent with the supposed environment; "
    "noise present in background but absent on face (composite indicator); "
    "inconsistent JPEG compression artifacts across regions.\n\n"

    "9. FACIAL BOUNDARY & BLENDING ARTIFACTS\n"
    "   FLAG if: blurring, color-tone mismatch, or sharpness discontinuity along face/neck/hairline boundary; "
    "face skin tone differs from neck or ears; jaw or chin shows warping or ghosting.\n\n"

    "10. CONTEXTUAL PLAUSIBILITY & GEOMETRY\n"
    "   FLAG if: accessories misaligned or passing through each other; "
    "hands or fingers with extra digits, merged fingers, or impossible joint geometry; "
    "environmental elements internally inconsistent.\n\n"

    "=== VERDICT DECISION MATRIX ===\n"
    " HIGH RISK  (HF score > 65%): Identify >= 3 FLAGS. Verdict = DEEPFAKE.\n"
    " AMBIGUOUS  (HF 40-65%): >=3 FLAGS → DEEPFAKE. 1-2 FLAGS → DEEPFAKE. 0 FLAGS → AUTHENTIC.\n"
    " LOW RISK   (HF < 40%): 0 FLAGS → AUTHENTIC. Any FLAG → DEEPFAKE.\n\n"

    "=== OUTPUT FORMAT ===\n"
    "Respond with ONLY valid JSON. No markdown. No code fences. No preamble.\n"
    "{{\n"
    '    "gemini_verdict": "DEEPFAKE" | "AUTHENTIC",\n'
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
    "(3) perfectly flat silence with no room tone, (4) abrupt energy step-changes between phonemes, "
    "(5) hard high-freq rolloff at a round kHz value.\n\n"
    ">=2 artifacts → DEEPFAKE. 1 artifact → DEEPFAKE. 0 → AUTHENTIC.\n\n"
    "Respond with ONLY valid JSON:\n"
    "{{\n"
    '    "gemini_verdict": "DEEPFAKE" | "AUTHENTIC",\n'
    '    "gemini_confidence": "HIGH" | "MEDIUM" | "LOW",\n'
    '    "flagged_items": ["artifact: observation"],\n'
    '    "passed_items": ["artifact: observation"],\n'
    '    "gemini_reasoning": "2-3 sentences on acoustic forensic findings."\n'
    "}}\n"
)

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _detect_mime_type(data: bytes) -> str:
    h = data[:12]
    if len(h) >= 4 and h[1:4] == b"PNG":             return "image/png"
    if len(h) >= 2 and h[:2] == b"\xff\xd8":         return "image/jpeg"
    if len(h) >= 6 and h[:6] in (b"GIF87a", b"GIF89a"): return "image/gif"
    if len(h) >= 12 and h[:4] == b"RIFF" and h[8:12] == b"WEBP": return "image/webp"
    if len(h) >= 12 and h[:4] == b"RIFF" and h[8:12] == b"WAVE": return "audio/wav"
    if len(h) >= 3 and (h[:3] == b"ID3" or h[:2] in (b"\xff\xfb", b"\xff\xf3", b"\xff\xfa")):
        return "audio/mpeg"
    if len(data) > 8 and data[4:8] == b"ftyp":       return "video/mp4"
    if len(h) >= 4 and h[:4] == b"\x1a\x45\xdf\xa3": return "video/webm"
    return "image/jpeg"
def _resize_image_bytes(image_bytes: bytes, mime_type: str = "image/jpeg") -> bytes:
    if len(image_bytes) <= MAX_IMAGE_BYTES:
        return image_bytes
    try:
        import cv2
        import numpy as np
        np_arr = np.frombuffer(image_bytes, np.uint8)
        img = cv2.imdecode(np_arr, cv2.IMREAD_COLOR)
        if img is None:
            return image_bytes
            
        h, w = img.shape[:2]
        if max(w, h) > MAX_IMAGE_LONG_EDGE:
            scale = MAX_IMAGE_LONG_EDGE / max(w, h)
            img = cv2.resize(img, (int(w * scale), int(h * scale)), interpolation=cv2.INTER_AREA)
            
        for q in range(90, 30, -10):
            success, encoded_img = cv2.imencode('.jpg', img, [int(cv2.IMWRITE_JPEG_QUALITY), q])
            if success and len(encoded_img.tobytes()) <= MAX_IMAGE_BYTES:
                return encoded_img.tobytes()
                
        success, encoded_img = cv2.imencode('.jpg', img, [int(cv2.IMWRITE_JPEG_QUALITY), 30])
        if success:
            return encoded_img.tobytes()
        return image_bytes
    except ImportError:
        logger.warning("[Resize] cv2 not found, sending original")
        return image_bytes
    except Exception as e:
        logger.warning(f"[Resize] Failed ({e}), sending original")
        return image_bytes




def _audio_to_spectrogram_jpeg(audio_bytes: bytes) -> Optional[bytes]:
    try:
        import librosa, librosa.display, soundfile as sf
        import matplotlib; matplotlib.use("Agg")
        import matplotlib.pyplot as plt
        import numpy as np
        y, sr = sf.read(io.BytesIO(audio_bytes), dtype="float32", always_2d=False)
        if y.ndim > 1: y = y.mean(axis=1)
        S_db = librosa.power_to_db(
            librosa.feature.melspectrogram(y=y, sr=sr, n_mels=128), ref=np.max
        )
        fig, ax = plt.subplots(figsize=(8, 4), dpi=96)
        librosa.display.specshow(S_db, sr=sr, x_axis="time", y_axis="mel", ax=ax, cmap="magma")
        ax.set_title("Mel-Spectrogram — Forensic Analysis")
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
                logger.debug(f"[Video] Seek {pct:.0%} failed: {e}")
        container.close()
        if frames:
            logger.info(f"[Video] Extracted {len(frames)} frames")
            return frames
    except ImportError:
        logger.warning("[Video] PyAV not installed — pip install av")
    except Exception as e:
        logger.warning(f"[Video] Frame extraction failed: {e}")
    return [video_bytes[:2 * 1024 * 1024]]


def _get_nvidia_client() -> OpenAI:
    api_key = getattr(settings, "NVIDIA_API_KEY", None)
    if not api_key:
        raise RuntimeError("NVIDIA_API_KEY not configured.")
    return OpenAI(base_url="https://integrate.api.nvidia.com/v1", api_key=api_key)


# ---------------------------------------------------------------------------
# Core vision call — sync wrapped in executor so event loop stays free
# ---------------------------------------------------------------------------

def _call_vision_model_sync(
    image_bytes: bytes,
    prompt: str,
    mime_type: str = "image/jpeg",
) -> tuple[str, str, Optional[float]]:
    """Synchronous NVIDIA NIM call."""
    image_bytes = _resize_image_bytes(image_bytes, mime_type)
    b64      = base64.b64encode(image_bytes).decode("utf-8")
    data_url = f"data:{mime_type};base64,{b64}"

    client   = _get_nvidia_client()
    response = client.chat.completions.create(
        model    = NVIDIA_MODEL,
        messages = [{"role": "user", "content": [
            {"type": "text",      "text": prompt},
            {"type": "image_url", "image_url": {"url": data_url}},
        ]}],
        response_format = {"type": "json_object"},
        temperature=0.1,
        top_p=0.9,
        logprobs=True,
    )

    model_used = getattr(response, "model", NVIDIA_MODEL)

    confidence: Optional[float] = None
    try:
        lp = getattr(response.choices[0], "logprobs", None)
        if lp and hasattr(lp, "content") and lp.content:
            mean_lp    = sum(t.logprob for t in lp.content) / len(lp.content)
            confidence = round(math.exp(mean_lp) * 100, 2)
    except Exception as e:
        logger.debug(f"[TIER-2] Logprobs skipped: {e}")

    raw_text = response.choices[0].message.content or ""
    logger.info(f"[TIER-2] Model raw response: {raw_text[:300]}")
    return raw_text, model_used, confidence


# ---------------------------------------------------------------------------
# Verdict parsing
# ---------------------------------------------------------------------------

_ALIASES = {
    "SUSPICIOUS": "DEEPFAKE", "ELEVATED_RISK": "DEEPFAKE",
    "SUSPECTED": "DEEPFAKE",
    "FAKE": "DEEPFAKE", "REAL": "AUTHENTIC", "GENUINE": "AUTHENTIC",
}
_VALID = {"DEEPFAKE", "AUTHENTIC"}


def _parse_verdict(raw: str, model: str, conf: Optional[float], tier: str) -> dict:
    try:
        m = re.search(r'\{[^{}]*"gemini_verdict"[^{}]*\}', raw, re.DOTALL)
        text = m.group() if m else re.sub(r"^```[a-z]*\n?", "", raw.strip()).rstrip("`")
        parsed = json.loads(text)

        v = str(parsed.get("gemini_verdict", "AUTHENTIC")).upper().strip()
        v = _ALIASES.get(v, v)
        if v not in _VALID:
            logger.warning(f"[TIER-2] Unknown verdict '{v}' → AUTHENTIC")
            v = "AUTHENTIC"

        return {
            "gemini_verdict":          v,
            "gemini_confidence_label": str(parsed.get("gemini_confidence", "MEDIUM")).upper(),
            "gemini_reasoning":        str(parsed.get("gemini_reasoning", "No reasoning provided.")),
            "flagged_items":           parsed.get("flagged_items", []),
            "passed_items":            parsed.get("passed_items", []),
            "gemini_model_used":       model,
            "gemini_confidence":       conf,
            "tier":                    tier,
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
        "gemini_reasoning": f"Tier-2 NVIDIA analysis failed for {media}. Manual review recommended.",
        "flagged_items": [], "passed_items": [],
        "gemini_model_used": NVIDIA_MODEL, "gemini_confidence": None,
        "tier": f"tier-2-{media}-error",
    }


# ---------------------------------------------------------------------------
# Sub-pipelines — using proven closure-in-executor pattern
# ---------------------------------------------------------------------------

async def _analyze_image(image_bytes: bytes, mime: str, hf_pct: float) -> dict:
    prompt = FORENSICS_PROMPT_TEMPLATE.format(hf_score_pct=hf_pct)

    def _blocking_call():
        return _call_vision_model_sync(image_bytes, prompt, mime)

    try:
        raw, model, conf = await asyncio.get_event_loop().run_in_executor(
            None, _blocking_call
        )
        logger.info(f"[TIER-2][Image] model={model} conf={conf}")
        return _parse_verdict(raw, model, conf, "tier-2-image")
    except Exception as e:
        logger.error(f"[TIER-2][Image] Failed: {e}", exc_info=True)
        return _error_response("image")



async def _analyze_audio(audio_bytes: bytes, hf_pct: float) -> dict:
    spec = _audio_to_spectrogram_jpeg(audio_bytes)
    if spec is None:
        return {
            "gemini_verdict": "ANALYSIS_FAILED", "gemini_confidence_label": "LOW",
            "gemini_reasoning": "Spectrogram unavailable. Install: librosa soundfile matplotlib.",
            "flagged_items": [], "passed_items": [],
            "gemini_model_used": NVIDIA_MODEL, "gemini_confidence": None,
            "tier": "tier-2-audio-fallback",
        }
    try:
        spec_prompt = AUDIO_SPECTROGRAM_PROMPT.format(hf_score_pct=hf_pct)

        def _blocking_call():
            return _call_vision_model_sync(spec, spec_prompt, "image/jpeg")

        raw, model, conf = await asyncio.get_event_loop().run_in_executor(
            None, _blocking_call
        )
        result = _parse_verdict(raw, model, conf, "tier-2-audio-spectrogram")
        result["gemini_reasoning"] = "[Spectrogram] " + result.get("gemini_reasoning", "")
        return result
    except Exception as e:
        logger.error(f"[TIER-2][Audio] {e}")
        return _error_response("audio")


async def _analyze_video(video_bytes: bytes, hf_pct: float) -> dict:
    frames = _extract_video_frame_jpegs(video_bytes)
    logger.info(f"[TIER-2][Video] {len(frames)} frame(s)")
    prompt = FORENSICS_PROMPT_TEMPLATE.format(hf_score_pct=hf_pct)

    async def _one(fb: bytes, idx: int) -> Optional[dict]:
        def _blocking_call():
            return _call_vision_model_sync(fb, prompt, "image/jpeg")
        try:
            raw, model, conf = await asyncio.get_event_loop().run_in_executor(
                None, _blocking_call
            )
            return _parse_verdict(raw, model, conf, f"tier-2-video-f{idx+1}")
        except Exception as e:
            logger.warning(f"[TIER-2][Video] frame {idx+1}: {e}")
            return None

    results = [r for r in await asyncio.gather(*[_one(f, i) for i, f in enumerate(frames[:4])]) if r]
    if not results:
        return _error_response("video")

    rank  = {"DEEPFAKE": 2, "ANALYSIS_FAILED": 1, "AUTHENTIC": 0}
    worst = max(results, key=lambda r: rank.get(r["gemini_verdict"], 0))
    worst["video_frames_analysed"] = len(results)
    worst["all_frame_verdicts"]    = [r["gemini_verdict"] for r in results]
    worst["tier"]                  = "tier-2-video"
    return worst



# ---------------------------------------------------------------------------
# Public entry point
# ---------------------------------------------------------------------------

async def run_gemini_analysis(image_bytes: bytes, hf_score_normalized: float) -> dict:
    """Route to correct Tier-2 sub-pipeline based on MIME type."""
    hf_pct    = hf_score_normalized * 100
    mime_type = _detect_mime_type(image_bytes)
    logger.info(f"[TIER-2] MIME={mime_type} size={len(image_bytes):,}B HF={hf_pct:.1f}%")

    if mime_type.startswith("audio/"):
        return await _analyze_audio(image_bytes, hf_pct)
    if mime_type.startswith("video/"):
        return await _analyze_video(image_bytes, hf_pct)
    return await _analyze_image(image_bytes, mime_type, hf_pct)
