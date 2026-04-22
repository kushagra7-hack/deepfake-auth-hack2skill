import os
from dotenv import load_dotenv
from huggingface_hub import InferenceClient

load_dotenv()

api_key = os.getenv("HUGGINGFACE_API_KEY")
if not api_key:
    print("Error: HUGGINGFACE_API_KEY is missing from .env")
    exit(1)

print(f"Loaded HF API Key starting with: {api_key[:6]}...")

client = InferenceClient(provider="hf-inference", api_key=api_key)

models = [
    "Falconsai/nsfw_image_detection",
    "Organika/sdxl-detector", 
    "dima806/deepfake_detection"
]

test_image_url = "https://huggingface.co/datasets/mishig/sample_images/resolve/main/tiger.jpg"

for model in models:
    print(f"\nTesting model: {model}")
    try:
        results = client.image_classification(test_image_url, model=model)
        print("Success! Labels:")
        for res in results:
            print(f"  - {res.label}: {res.score:.4f}")
    except Exception as e:
        print(f"Error calling {model}: {e}")
