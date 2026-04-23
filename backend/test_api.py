import asyncio
import os
import sys
from pprint import pprint
from app.core.security import FileInfo
from app.services.hf_client import analyze_deepfake
from app.services.gemini_client import run_gemini_analysis

async def test_deepfake_pipeline(image_path: str):
    if not os.path.exists(image_path):
        print(f"Error: Could not find image at {image_path}")
        return

    with open(image_path, "rb") as f:
        file_bytes = f.read()

    print(f"\n[1] Starting Tier-1 HuggingFace Scan for: {image_path}")
    file_info = FileInfo(signature=b"", mime_type="image/jpeg", media_type="image")
    
    hf_score_normalized = 1.0 # fallback default to force Gemini

    try:
        hf_result = await analyze_deepfake(file_bytes, file_info)
        hf_score_normalized = hf_result.probability_score / 100.0
        print(f"    - HuggingFace Raw Probability: {hf_result.probability_score:.2f}%")
        print(f"    - Is Deepfake (HF): {hf_result.is_deepfake}")
    except Exception as e:
        print(f"    - HuggingFace API returned an error: {e}. Forcing Tier 2.")

    print(f"\n[2] Starting Tier-2 Gemini Multimodal Forensics")
    try:
        gemini_result = await run_gemini_analysis(file_bytes, hf_score_normalized)
        print("\n=== FINAL FORENSIC VERDICT ===")
        print(f"Verdict: {gemini_result.get('gemini_verdict')}")
        print(f"Reasoning: {gemini_result.get('gemini_reasoning')}")
        print(f"Model Used: {gemini_result.get('gemini_model_used')}")
        print(f"Confidence: {gemini_result.get('gemini_confidence')}%")
    except Exception as e:
        print(f"Gemini evaluation failed: {e}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python test_api.py <path_to_image>")
        sys.exit(1)
    
    asyncio.run(test_deepfake_pipeline(sys.argv[1]))
