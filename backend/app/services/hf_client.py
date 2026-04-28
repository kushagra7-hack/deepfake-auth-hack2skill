"""
HuggingFace ensemble client — Tier-1 pre-screen.
Runs top-N image models in parallel with weighted voting.
Video: extracts frames via PyAV, runs image ensemble on each.
Audio: single specialist model.
"""

import asyncio
import base64
import io
import logging
import time
from dataclasses import dataclass, field
from typing import Any, Optional

import httpx

from app.core.config import settings
from app.core.security import FileInfo

logger = logging.getLogger(__name__)


# ---------------------------------------------------------------------------
# Model registry
# ---------------------------------------------------------------------------

@dataclass
class ModelSpec:
    model_id:          str
    weight:            float
    direct_fake_score: bool = True
    label_map:         dict = field(default_factory=dict)
    supports:          tuple = ("image",)


IMAGE_MODEL_SPECS: list[ModelSpec] = [
    ModelSpec("haywoodsloan/ai-image-detector-deepfake", 1.4,
              label_map={"ai_generated": "fake", "artificial": "fake", "real": "real", "human": "real"}),
    ModelSpec("umm-maybe/AI-image-detector", 1.3,
              label_map={"artificial": "fake", "ai": "fake", "human": "real", "real": "real"}),
    ModelSpec("Organika/sdxl-detector", 1.1,
              label_map={"artificial": "fake", "sdxl": "fake", "ai-generated": "fake",
                         "human": "real", "real": "real", "not sdxl": "real"}),
    ModelSpec("dima806/deepfake_vs_real_image_detection", 1.0,
              label_map={"fake": "fake", "real": "real"}),
    ModelSpec("prithivMLmods/Deep-Fake-Detector-Model", 0.9,
              label_map={"fake": "fake", "deepfake": "fake", "real": "real", "authentic": "real"}),
    ModelSpec("Heem2/AI-Image-Detector", 0.7,
              label_map={"ai generated": "fake", "real": "real"}),
]

AUDIO_MODEL_SPEC = ModelSpec(
    "MelodyMachine/Deepfake-audio-detection-V2", 1.0,
    label_map={"fake": "fake", "spoof": "fake", "real": "real", "bonafide": "real"},
    supports=("audio",),
)

ENSEMBLE_TOP_N    = 4
HF_TIMEOUT        = 120
HF_RETRIES        = 3
HF_RETRY_DELAY    = 2
COLD_START_CAP    = 60

FAKE_KEYWORDS = frozenset(["fake","deepfake","ai","generated","artificial","synthetic",
    "sdxl","diffusion","midjourney","stable","gan","manipulated","spoof"])
REAL_KEYWORDS = frozenset(["real","authentic","genuine","human","natural","bonafide"])


# ---------------------------------------------------------------------------
# Exceptions & result types
# ---------------------------------------------------------------------------

class HFModelError(Exception):
    def __init__(self, msg, code=None): self.message = msg; self.status_code = code; super().__init__(msg)

class HFAPIConnectionError(HFModelError): pass
class HFAPIResponseError(HFModelError):   pass
class HFTimeoutError(HFModelError):       pass


@dataclass
class SingleModelResult:
    model_id: str; probability_score: float; weight: float; raw_response: Any


@dataclass
class DeepfakeAnalysisResult:
    probability_score:  float
    is_deepfake:        bool
    confidence_level:   str
    model_used:         str
    processing_time_ms: float
    raw_response:       dict
    ensemble_scores:    list = field(default_factory=list)


# ---------------------------------------------------------------------------
# Video frame extraction
# ---------------------------------------------------------------------------

def extract_video_frames_as_jpeg(video_bytes: bytes, n: int = 4) -> list[bytes]:
    try:
        import av
        from PIL import Image
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
                logger.debug(f"[HF-Video] seek {pct:.0%}: {e}")
        container.close()
        if frames:
            logger.info(f"[HF-Video] {len(frames)} frames extracted")
            return frames
    except ImportError:
        logger.warning("[HF-Video] PyAV not installed")
    except Exception as e:
        logger.warning(f"[HF-Video] {e}")
    return [video_bytes[:2 * 1024 * 1024]]


# ---------------------------------------------------------------------------
# Client
# ---------------------------------------------------------------------------

class HuggingFaceClient:
    def __init__(self, api_key: str):
        self.api_key = api_key
        self._client: Optional[httpx.AsyncClient] = None

    async def __aenter__(self):
        await self._ensure(); return self

    async def __aexit__(self, *_): await self.close()

    async def _ensure(self):
        if not self._client or self._client.is_closed:
            self._client = httpx.AsyncClient(
                timeout=httpx.Timeout(HF_TIMEOUT),
                headers={"Authorization": f"Bearer {self.api_key}",
                         "User-Agent": f"{settings.APP_NAME}/{settings.APP_VERSION}"},
            )

    async def close(self):
        if self._client and not self._client.is_closed:
            await self._client.aclose(); self._client = None

    async def analyze_media(self, file_bytes: bytes, file_info: FileInfo,
                            model_type: Optional[str] = None) -> DeepfakeAnalysisResult:
        t0   = time.monotonic()
        await self._ensure()
        mime = file_info.mime_type.lower()
        if mime.startswith("image/"): return await self._analyze_image(file_bytes, t0)
        if mime.startswith("audio/"): return await self._analyze_audio(file_bytes, t0)
        if mime.startswith("video/"): return await self._analyze_video(file_bytes, t0)
        raise HFModelError(f"Unsupported MIME: {mime}")

    async def _analyze_image(self, data: bytes, t0: float) -> DeepfakeAnalysisResult:
        specs = IMAGE_MODEL_SPECS[:ENSEMBLE_TOP_N]
        raw   = await asyncio.gather(*[self._query(data, s) for s in specs], return_exceptions=True)
        ok    = [r for r in raw if isinstance(r, SingleModelResult)]
        for i, r in enumerate(raw):
            if isinstance(r, BaseException):
                logger.warning(f"[HF] {specs[i].model_id} failed: {r}")
        if not ok:
            for s in IMAGE_MODEL_SPECS[ENSEMBLE_TOP_N:]:
                try: ok.append(await self._query(data, s)); break
                except Exception as e: logger.warning(f"[HF] fallback {s.model_id}: {e}")
        if not ok: raise HFModelError("All models failed")
        return self._aggregate(ok, t0)

    async def _analyze_audio(self, data: bytes, t0: float) -> DeepfakeAnalysisResult:
        r = await self._query(data, AUDIO_MODEL_SPEC)
        return self._single(r, (time.monotonic() - t0) * 1000)

    async def _analyze_video(self, data: bytes, t0: float) -> DeepfakeAnalysisResult:
        frames  = extract_video_frames_as_jpeg(data)
        results = []
        for i, fb in enumerate(frames):
            try:
                results.append(await self._analyze_image(fb, time.monotonic()))
            except Exception as e:
                logger.warning(f"[HF-Video] frame {i+1}: {e}")
        if not results:
            return DeepfakeAnalysisResult(0.0, False, "low", "none",
                                         (time.monotonic()-t0)*1000,
                                         {"error": "No frames analysed"})
        worst = max(results, key=lambda r: r.probability_score)
        worst.processing_time_ms = (time.monotonic() - t0) * 1000
        return worst

    async def _query(self, data: bytes, spec: ModelSpec) -> SingleModelResult:
        assert self._client
        url       = f"https://router.huggingface.co/hf-inference/models/{spec.model_id}"
        last_err: Optional[Exception] = None
        for attempt in range(1, HF_RETRIES + 1):
            try:
                logger.info(f"[HF] model={spec.model_id} attempt={attempt}")
                resp = await self._client.post(
                    url, content=data,
                    headers={"Authorization": f"Bearer {self.api_key}",
                             "Content-Type": "application/octet-stream",
                             "Accept": "application/json"},
                )
                if resp.status_code == 503:
                    w = min(float(resp.json().get("estimated_time", 20) or 20), COLD_START_CAP)
                    logger.warning(f"[HF] {spec.model_id} cold-starting {w:.0f}s")
                    await asyncio.sleep(w); continue
                if resp.status_code == 429:
                    await asyncio.sleep(HF_RETRY_DELAY * attempt); continue
                if resp.status_code == 403:
                    raise HFAPIResponseError(f"403 on {spec.model_id}", 403)
                if resp.status_code == 401:
                    raise HFAPIResponseError("Invalid HF API key", 401)
                resp.raise_for_status()
                raw   = resp.json()
                score = self._parse(raw, spec)
                logger.info(f"[HF] {spec.model_id} score={score:.2f}%")
                return SingleModelResult(spec.model_id, score, spec.weight, raw)
            except (HFAPIResponseError, HFModelError): raise
            except httpx.TimeoutException as e:
                last_err = HFTimeoutError(f"Timeout {spec.model_id}", 408)
                if attempt < HF_RETRIES: await asyncio.sleep(HF_RETRY_DELAY * attempt)
            except httpx.HTTPStatusError as e:
                if e.response.status_code >= 500:
                    last_err = HFAPIResponseError(f"5xx {spec.model_id}", e.response.status_code)
                    if attempt < HF_RETRIES: await asyncio.sleep(HF_RETRY_DELAY * attempt)
                else: raise HFAPIResponseError(f"{e.response.status_code} {spec.model_id}", e.response.status_code)
            except httpx.RequestError as e:
                last_err = HFAPIConnectionError(f"Conn error {spec.model_id}: {e}")
                if attempt < HF_RETRIES: await asyncio.sleep(HF_RETRY_DELAY * attempt)
        raise last_err or HFModelError(f"{spec.model_id} failed after {HF_RETRIES} attempts")

    def _parse(self, data: Any, spec: ModelSpec) -> float:
        if isinstance(data, list) and data and isinstance(data[0], list):
            data = data[0]
        fake_s = real_s = 0.0; found = False

        def _canon(lbl: str) -> Optional[str]:
            l = lbl.lower().strip()
            if l in spec.label_map: return spec.label_map[l]
            if any(k in l for k in FAKE_KEYWORDS): return "fake"
            if any(k in l for k in REAL_KEYWORDS):  return "real"
            return None

        if isinstance(data, list):
            for item in data:
                if not isinstance(item, dict): continue
                c = _canon(str(item.get("label", ""))); s = float(item.get("score", 0))
                found = True
                if c == "fake": fake_s = max(fake_s, s)
                elif c == "real": real_s = max(real_s, s)
        elif isinstance(data, dict):
            c = _canon(str(data.get("label", ""))); s = float(data.get("score", 0))
            found = True
            if c == "fake": fake_s = s
            else: real_s = s

        if not found: return 50.0
        if fake_s > 0: return round(fake_s * 100, 4)
        if real_s > 0: return round((1 - real_s) * 100, 4)
        return 50.0

    def _aggregate(self, results: list[SingleModelResult], t0: float) -> DeepfakeAnalysisResult:
        tw = sum(r.weight for r in results)
        ws = sum(r.probability_score * r.weight for r in results) / tw
        if ws > 45:
            ws = ws * 0.80 + max(r.probability_score for r in results) * 0.20
        ws = round(min(ws, 100.0), 2)

        hi = getattr(settings, "THREAT_THRESHOLD_HIGH", 70)
        lo = getattr(settings, "THREAT_THRESHOLD_LOW",  45)
        if ws >= hi:   conf, df = "high",   True
        elif ws >= lo: conf, df = "medium",  ws > 50
        else:          conf, df = "low",    False

        logger.info(f"[HF-Ensemble] score={ws:.1f}% deepfake={df} conf={conf}")
        return DeepfakeAnalysisResult(
            probability_score  = ws,
            is_deepfake        = df,
            confidence_level   = conf,
            model_used         = f"ensemble:{len(results)}-models" if len(results) > 1 else results[0].model_id,
            processing_time_ms = (time.monotonic() - t0) * 1000,
            raw_response       = {"ensemble_scores": [{"model": r.model_id, "score": round(r.probability_score, 2)} for r in results]},
            ensemble_scores    = [{"model": r.model_id, "score": round(r.probability_score, 2), "weight": r.weight} for r in results],
        )

    def _single(self, r: SingleModelResult, ms: float) -> DeepfakeAnalysisResult:
        hi = getattr(settings, "THREAT_THRESHOLD_HIGH", 70)
        lo = getattr(settings, "THREAT_THRESHOLD_LOW",  45)
        s  = r.probability_score
        if s >= hi:   conf, df = "high",   True
        elif s >= lo: conf, df = "medium",  s > 50
        else:         conf, df = "low",    False
        return DeepfakeAnalysisResult(s, df, conf, r.model_id, ms,
                                      {"classifications": r.raw_response})


# ---------------------------------------------------------------------------
# Module-level singleton
# ---------------------------------------------------------------------------

_hf_client: Optional[HuggingFaceClient] = None


async def get_hf_client() -> HuggingFaceClient:
    global _hf_client
    if not _hf_client:
        _hf_client = HuggingFaceClient(settings.HUGGINGFACE_API_TOKEN)
    await _hf_client._ensure()
    return _hf_client


async def analyze_deepfake(file_bytes: bytes, file_info: FileInfo,
                           model_type: Optional[str] = None) -> DeepfakeAnalysisResult:
    return await (await get_hf_client()).analyze_media(file_bytes, file_info, model_type)
