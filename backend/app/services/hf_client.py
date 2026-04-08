"""
Hugging Face API client for deepfake detection.
Uses the official huggingface_hub InferenceClient for reliable API access.
"""

import asyncio
import base64
import hashlib
import logging
import time
from dataclasses import dataclass
from enum import Enum
from typing import Any, Optional

import httpx
from huggingface_hub import InferenceClient
from huggingface_hub.errors import HfHubHTTPError

from app.core.config import settings
from app.core.security import FileInfo

logger = logging.getLogger(__name__)


# Model Constants
IMAGE_MODEL = "prithivMLmods/Deepfake-Detection-Real-vs-Fake"
AUDIO_MODEL = "MelodyMachine/Deepfake-audio-detection-V2"

# Working deepfake detection models (image-classification pipeline)
DEEPFAKE_MODELS = [
    IMAGE_MODEL,
    "Organika/sdxl-detector",
    "Falconsai/nsfw_image_detection",   # Fallback: reliable warm model on HF
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
            models_to_try = [IMAGE_MODEL] + [m for m in DEEPFAKE_MODELS if m != IMAGE_MODEL]
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
                        logger.warning(f"[HF] Model cold-starting, sleeping {wait_s:.0f}s…")
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
                            "HuggingFace 403: Token needs 'inference.serverless.write' permission.",
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
            "dima806/deepfake_vs_real_image_detection": {"fake": "fake", "real": "real"},
            "Organika/sdxl-detector": {"artificial": "fake", "human": "real", "sdxl": "fake", "not sdxl": "real"},
            "Falconsai/nsfw_image_detection": {"nsfw": "fake", "normal": "real"},
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
        _hf_client = HuggingFaceClient(settings.HUGGINGFACE_API_KEY)
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
