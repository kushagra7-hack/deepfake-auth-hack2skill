"""
Hugging Face API client for deepfake detection.
Provides async integration with ML models for media analysis.
"""

import asyncio
import base64
import hashlib
import logging
from dataclasses import dataclass
from enum import Enum
from typing import Any, Optional

import httpx

from app.core.config import settings
from app.core.security import FileInfo

logger = logging.getLogger(__name__)


class HFModelType(str, Enum):
    DEEPFAKE_IMAGE = "microsoft/resnet-50-deepfake"
    DEEPFAKE_VIDEO = "facebook/wav2vec2-base-960h"
    DEEPFAKE_GENERAL = "dima806/deepfake_detection"


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


HUGGINGFACE_INFERENCE_URL = "https://api-inference.huggingface.co/models/{model}"
HF_TIMEOUT_SECONDS = 120
HF_RETRY_ATTEMPTS = 3
HF_RETRY_DELAY_SECONDS = 2


class HuggingFaceClient:
    """
    Async client for Hugging Face Inference API.
    
    Handles communication with ML models for deepfake detection
    with proper error handling and retry logic.
    """
    
    def __init__(self, api_key: str):
        self.api_key = api_key
        self._client: Optional[httpx.AsyncClient] = None
        self._timeout = httpx.Timeout(HF_TIMEOUT_SECONDS)
    
    async def __aenter__(self) -> "HuggingFaceClient":
        await self._ensure_client()
        return self
    
    async def __aexit__(self, exc_type, exc_val, exc_tb) -> None:
        await self.close()
    
    async def _ensure_client(self) -> None:
        if self._client is None or self._client.is_closed:
            self._client = httpx.AsyncClient(
                timeout=self._timeout,
                headers={
                    "Authorization": f"Bearer {self.api_key}",
                    "Content-Type": "application/json",
                    "User-Agent": f"{settings.APP_NAME}/{settings.APP_VERSION}"
                }
            )
    
    async def close(self) -> None:
        if self._client and not self._client.is_closed:
            await self._client.aclose()
            self._client = None
    
    async def analyze_media(
        self,
        file_bytes: bytes,
        file_info: FileInfo,
        model_type: Optional[HFModelType] = None
    ) -> DeepfakeAnalysisResult:
        """
        Send media file to Hugging Face API for deepfake analysis.
        
        Args:
            file_bytes: Raw bytes of the media file
            file_info: Validated file information from security module
            model_type: Specific model to use (auto-selected if None)
            
        Returns:
            DeepfakeAnalysisResult: Analysis results including probability score
            
        Raises:
            HFTimeoutError: If API request times out
            HFAPIResponseError: If API returns an error
            HFAPIConnectionError: If connection fails
        """
        import time
        start_time = time.monotonic()
        
        if model_type is None:
            model_type = self._select_model(file_info)
        
        model_name = model_type.value
        url = HUGGINGFACE_INFERENCE_URL.format(model=model_name)
        
        await self._ensure_client()
        
        if self._client is None:
            raise HFAPIConnectionError("Failed to initialize HTTP client")
        
        if file_info.media_type == "image":
            payload = await self._prepare_image_payload(file_bytes, file_info)
        elif file_info.media_type == "video":
            payload = await self._prepare_video_payload(file_bytes, file_info)
        else:
            payload = await self._prepare_audio_payload(file_bytes, file_info)
        
        last_exception: Optional[Exception] = None
        
        for attempt in range(1, HF_RETRY_ATTEMPTS + 1):
            try:
                response = await self._client.post(url, json=payload)
                
                if response.status_code == 503:
                    retry_info = response.json().get("estimated_time", HF_RETRY_DELAY_SECONDS)
                    logger.warning(f"Model loading, retrying in {retry_info}s (attempt {attempt}/{HF_RETRY_ATTEMPTS})")
                    await asyncio.sleep(retry_info)
                    continue
                
                if response.status_code == 429:
                    logger.warning(f"Rate limited, retrying in {HF_RETRY_DELAY_SECONDS}s (attempt {attempt}/{HF_RETRY_ATTEMPTS})")
                    await asyncio.sleep(HF_RETRY_DELAY_SECONDS)
                    continue
                
                response.raise_for_status()
                
                result = await self._parse_response(response.json(), model_name)
                processing_time = (time.monotonic() - start_time) * 1000
                result.processing_time_ms = processing_time
                
                logger.info(
                    f"Deepfake analysis completed: score={result.probability_score:.2f}%, "
                    f"time={processing_time:.0f}ms, model={model_name}"
                )
                
                return result
                
            except httpx.TimeoutException as e:
                last_exception = HFTimeoutError(f"API request timed out: {str(e)}", 408)
                logger.warning(f"Timeout on attempt {attempt}/{HF_RETRY_ATTEMPTS}: {e}")
                if attempt < HF_RETRY_ATTEMPTS:
                    await asyncio.sleep(HF_RETRY_DELAY_SECONDS)
                    
            except httpx.HTTPStatusError as e:
                if e.response.status_code >= 500:
                    last_exception = HFAPIResponseError(
                        f"API returned error {e.response.status_code}: {e.response.text}",
                        e.response.status_code
                    )
                    logger.warning(f"Server error on attempt {attempt}/{HF_RETRY_ATTEMPTS}")
                    if attempt < HF_RETRY_ATTEMPTS:
                        await asyncio.sleep(HF_RETRY_DELAY_SECONDS)
                else:
                    raise HFAPIResponseError(
                        f"Client error {e.response.status_code}: {e.response.text}",
                        e.response.status_code
                    )
                    
            except httpx.RequestError as e:
                last_exception = HFAPIConnectionError(f"Connection error: {str(e)}")
                logger.warning(f"Connection error on attempt {attempt}/{HF_RETRY_ATTEMPTS}: {e}")
                if attempt < HF_RETRY_ATTEMPTS:
                    await asyncio.sleep(HF_RETRY_DELAY_SECONDS)
        
        if last_exception:
            raise last_exception
        
        raise HFModelError("Unknown error occurred during analysis")
    
    def _select_model(self, file_info: FileInfo) -> HFModelType:
        """Select appropriate model based on media type."""
        if file_info.media_type == "image":
            return HFModelType.DEEPFAKE_IMAGE
        elif file_info.media_type == "video":
            return HFModelType.DEEPFAKE_GENERAL
        else:
            return HFModelType.DEEPFAKE_GENERAL
    
    async def _prepare_image_payload(self, file_bytes: bytes, file_info: FileInfo) -> dict:
        """Prepare image data for API request."""
        b64_data = base64.b64encode(file_bytes).decode("utf-8")
        return {
            "inputs": b64_data,
            "parameters": {
                "options": {
                    "wait_for_model": True
                }
            }
        }
    
    async def _prepare_video_payload(self, file_bytes: bytes, file_info: FileInfo) -> dict:
        """Prepare video data for API request."""
        chunk_size = 1024 * 1024
        if len(file_bytes) > chunk_size:
            file_bytes = file_bytes[:chunk_size]
        
        b64_data = base64.b64encode(file_bytes).decode("utf-8")
        return {
            "inputs": b64_data,
            "parameters": {
                "options": {
                    "wait_for_model": True
                }
            }
        }
    
    async def _prepare_audio_payload(self, file_bytes: bytes, file_info: FileInfo) -> dict:
        """Prepare audio data for API request."""
        b64_data = base64.b64encode(file_bytes).decode("utf-8")
        return {
            "inputs": b64_data,
            "parameters": {
                "options": {
                    "wait_for_model": True
                }
            }
        }
    
    async def _parse_response(self, response: dict, model_name: str) -> DeepfakeAnalysisResult:
        """Parse API response into structured result."""
        if isinstance(response, list) and len(response) > 0:
            response = response[0]
        
        if "error" in response:
            raise HFAPIResponseError(f"Model error: {response['error']}")
        
        probability_score = self._extract_probability(response)
        
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
            raw_response=response
        )
    
    def _extract_probability(self, response: dict) -> float:
        """Extract probability score from various response formats."""
        if "score" in response:
            return float(response["score"]) * 100
        
        if "label" in response and "score" in response:
            label = response["label"].lower()
            score = float(response["score"]) * 100
            if "fake" in label or "deepfake" in label:
                return score
            return 100 - score
        
        if isinstance(response, list):
            for item in response:
                if isinstance(item, dict) and "score" in item:
                    label = item.get("label", "").lower()
                    score = float(item["score"]) * 100
                    if "fake" in label or "deepfake" in label:
                        return score
                    if "real" in label:
                        return 100 - score
            for item in response:
                if isinstance(item, dict) and item.get("label") == "deepfake":
                    return float(item.get("score", 0)) * 100
        
        return 0.0


_hf_client: Optional[HuggingFaceClient] = None


async def get_hf_client() -> HuggingFaceClient:
    """Get or create Hugging Face client instance."""
    global _hf_client
    if _hf_client is None:
        _hf_client = HuggingFaceClient(settings.SUPABASE_ANON_KEY)
    await _hf_client._ensure_client()
    return _hf_client


async def analyze_deepfake(
    file_bytes: bytes,
    file_info: FileInfo,
    model_type: Optional[HFModelType] = None
) -> DeepfakeAnalysisResult:
    """
    Convenience function to analyze media for deepfakes.
    
    Args:
        file_bytes: Raw bytes of the media file
        file_info: Validated file information
        model_type: Specific model to use (optional)
        
    Returns:
        DeepfakeAnalysisResult: Analysis results
    """
    client = await get_hf_client()
    return await client.analyze_media(file_bytes, file_info, model_type)
