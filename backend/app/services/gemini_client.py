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
    "=== OUTPUT FORMAT ===\n"
    "Respond with ONLY valid JSON. No markdown. No code fences. No extra text.\n"
    "{{\n"
    '    "gemini_verdict": "DEEPFAKE" | "AUTHENTIC",\n'
    '    "gemini_confidence": "HIGH" | "MEDIUM" | "LOW",\n'
    '    "flagged_items": ["List the specific checklist items that failed here"],\n'
    '    "passed_items": ["List checklist items that passed"],\n'
    '    "gemini_reasoning": "[2-3 sentences citing the specific artifacts found from the checklist, or why all 8 items passed.]"\n'
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
    """Convert audio to a visualized waveform image using numpy+cv2 (no librosa needed)."""
    try:
        # Try librosa first (best quality)
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
        logger.info("[Audio] librosa mel-spectrogram generated successfully")
        return buf.getvalue()
    except Exception:
        pass  # Fall through to cv2 fallback

    try:
        # Fallback: use wave module + numpy + cv2 to draw a waveform image
        import wave, struct, numpy as np, cv2
        buf_wav = io.BytesIO(audio_bytes)
        try:
            with wave.open(buf_wav) as wf:
                n_frames = wf.getnframes()
                n_channels = wf.getnchannels()
                raw = wf.readframes(n_frames)
                samples = np.frombuffer(raw, dtype=np.int16).astype(np.float32)
                if n_channels > 1:
                    samples = samples[::n_channels]  # take left channel only
        except Exception:
            # For MP3/other formats, just use raw bytes as pseudo-signal
            samples = np.frombuffer(audio_bytes[:44100*2], dtype=np.int16).astype(np.float32)

        # Normalize
        if samples.max() != 0:
            samples = samples / np.abs(samples).max()

        # Downsample to 800 points for visualization
        step = max(1, len(samples) // 800)
        samples = samples[::step][:800]

        # Create image (height=400, width=800)
        H, W = 400, 800
        img = np.zeros((H, W, 3), dtype=np.uint8)
        img[:] = (10, 10, 20)  # dark background

        # Draw waveform
        mid = H // 2
        for i in range(len(samples) - 1):
            y1 = int(mid - samples[i] * (H // 2 - 10))
            y2 = int(mid - samples[i+1] * (H // 2 - 10))
            cv2.line(img, (i, y1), (i+1, y2), (0, 200, 255), 1)

        # Draw center line
        cv2.line(img, (0, mid), (W, mid), (50, 50, 50), 1)

        # Add text label
        cv2.putText(img, "Audio Waveform - Forensic Analysis", (10, 30),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 255, 255), 1)
        cv2.putText(img, f"Samples: {len(samples)} | AI Audio Forensics", (10, 370),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.5, (150, 150, 150), 1)

        success, encoded = cv2.imencode('.jpg', img, [int(cv2.IMWRITE_JPEG_QUALITY), 90])
        if success:
            logger.info("[Audio] cv2 waveform image generated (librosa not available)")
            return encoded.tobytes()
    except Exception as e:
        logger.warning(f"[Audio] cv2 waveform fallback failed: {e}")

    logger.error("[Audio] All spectrogram methods failed")
    return None


def _extract_video_frame_jpegs(video_bytes: bytes, n: int = 4) -> list[bytes]:
    import tempfile
    import os
    try:
        import cv2
        # Write bytes to a temporary file because OpenCV cannot read videos directly from memory
        with tempfile.NamedTemporaryFile(delete=False, suffix=".mp4") as tmp:
            tmp.write(video_bytes)
            tmp_path = tmp.name

        try:
            cap = cv2.VideoCapture(tmp_path)
            if not cap.isOpened():
                logger.warning("[Video] OpenCV could not open video container")
                return [video_bytes[:2 * 1024 * 1024]]

            total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
            if total_frames <= 0:
                total_frames = 100 # Fallback estimate

            frames: list[bytes] = []
            for pct in [0.05, 0.25, 0.50, 0.75][:n]:
                frame_idx = int(pct * total_frames)
                cap.set(cv2.CAP_PROP_POS_FRAMES, frame_idx)
                ret, frame = cap.read()
                if ret:
                    # Compress the extracted frame as a JPEG
                    success, encoded_img = cv2.imencode('.jpg', frame, [int(cv2.IMWRITE_JPEG_QUALITY), 90])
                    if success:
                        frames.append(encoded_img.tobytes())
                else:
                    logger.debug(f"[Video] Frame read at index {frame_idx} failed")
            
            cap.release()
            
            if frames:
                logger.info(f"[Video] Extracted {len(frames)} frames using OpenCV")
                return frames
        finally:
            # Always clean up the temp file
            if os.path.exists(tmp_path):
                os.remove(tmp_path)
                
    except ImportError:
        logger.warning("[Video] cv2 not installed — pip install opencv-python-headless")
    except Exception as e:
        logger.warning(f"[Video] Frame extraction failed: {e}")
        
    # Hard fallback if extraction completely fails
    return [video_bytes[:2 * 1024 * 1024]]


def _get_nvidia_client() -> OpenAI:
    api_key = getattr(settings, "NVIDIA_API_KEY", None)
    if not api_key:
        raise RuntimeError("NVIDIA_API_KEY not configured.")
    return OpenAI(base_url="https://integrate.api.nvidia.com/v1", api_key=api_key, timeout=15.0)


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
