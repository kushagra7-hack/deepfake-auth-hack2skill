# Deepfake Authentication Gateway

## 📖 Project Overview
This repository implements an **Enterprise‑Grade Deepfake Authentication Gateway** — a **zero‑trust** end‑to‑end solution that securely ingests media files (images, video, audio) and validates them using a **two‑tier AI pipeline** before a final verdict is returned. The backend is built with **FastAPI**, the client is a **Flutter** cross‑platform app (iOS, Android, Web, Desktop), and the database uses **Firebase Firestore** with **Firebase Auth**.

### The Two‑Tier AI Pipeline
| Tier | Provider | Model | Role |
|------|----------|-------|------|
| **Tier‑1** | Hugging Face | `prithivMLmods/Deepfake-Detection-Real-vs-Fake` (primary), with `Organika/sdxl-detector` and `Falconsai/nsfw_image_detection` as fallbacks. Audio uses `MelodyMachine/Deepfake-audio-detection-V2`. | Fast mathematical pre‑screen — quick probability score for every upload. |
| **Tier‑2** | NVIDIA NIM | `meta/llama-3.2-90b-vision-instruct` via OpenAI‑compatible SDK | Deep visual forensics on every **image** payload regardless of Tier‑1 score (zero‑trust override). Audio goes straight to Tier‑2. |

### How It Works (High‑Level Flow)
1. **User Authentication** – Flutter client authenticates via **Firebase Auth** (email/password or Google OAuth), receiving a Firebase ID token.
2. **File Upload** – Authenticated user selects a media file in the Flutter UI. The token is sent as a Bearer token in the Authorization header.
3. **Magic‑Byte Inspection** – The backend reads the file in 1 MB chunks, inspects its magic bytes, and rejects unsupported/empty payloads before any AI processing.
4. **SHA‑256 Hashing** – The file bytes are hashed. (Deduplication logic is present in the codebase but currently bypassed so every fresh upload runs the full pipeline.)
5. **Tier‑1 Scan** – The file is sent to Hugging Face. The model returns a raw probability score.
6. **Tier‑2 Scan (images only)** – The image is always forwarded to NVIDIA NIM for deep visual forensics (zero‑trust override). Audio files go directly to Tier‑2 without Tier‑1.
7. **Audit Logging** – Every scan (pending → completed/failed) is stored in **Firebase Firestore** with full traceability.
8. **Result Delivery** – The API returns a structured `ScanResponse` containing `threat_score`, `gemini_verdict`, `gemini_reasoning`, and confidence level. The Flutter client renders a colour‑coded badge (green = AUTHENTIC, red = DEEPFAKE, amber = ELEVATED_RISK).

---

## ✨ Core Features
- **Zero‑Trust Architecture** – Magic‑byte validation, JWT‑style token verification, per‑user rate limiting, and Tier‑2 forced analysis for images eliminate trust shortcuts.
- **Two‑Tier AI Pipeline** – Tier‑1 is fast and cheap; Tier‑2 is rigorous. Only images trigger both tiers. Audio goes straight to Tier‑2.
- **NVIDIA NIM (Tier‑2)** – Uses the OpenAI‑compatible SDK with `base_url=https://integrate.api.nvidia.com/v1`, requiring only `NVIDIA_API_KEY`.
- **Asynchronous HF Client** – Non‑blocking calls to Hugging Face with automatic retries, exponential back‑off, and cold‑start detection (503 handling with wait‑and‑retry).
- **Typed API Contracts** – Pydantic schemas (`ScanResponse`, `ScanStatus`, `ErrorResponse`) guarantee request/response integrity across all endpoints.
- **Firebase Firestore** – Stores scan records (`pending` → `completed`/`failed`), user stats, and audit logs.
- **Flutter‑First Client** – Single Dart codebase runs on iOS, Android, Web, and Desktop. UI uses Material 3 with a dark enterprise theme.
- **Docker‑First Backend** – `docker compose up --build` spins up the FastAPI service and a local Firestore emulator for development.
- **Observability** – Structured JSON logs, `/health` and `/ready` endpoints, and security headers on every response.
- **Scalable Design** – Stateless FastAPI service can be horizontally scaled behind a load balancer.

---

## 📂 Repository Structure
```
├─ backend/               # FastAPI service
│   ├─ app/
│   │   ├─ api/routes/   # scan.py
│   │   ├─ core/          # config.py, security.py
│   │   ├─ services/      # hf_client.py, gemini_client.py, firestore_db.py
│   │   └─ models/        # schemas.py
│   ├─ nexus-gateway-*-firebase-adminsdk-*.json  # Firebase credentials
│   ├─ requirements.txt
│   └─ Dockerfile
├─ flutter-client/        # Flutter cross‑platform app
│   ├─ lib/
│   │   ├─ screens/      # landing_screen.dart, login_screen.dart, dashboard_screen.dart
│   │   ├─ services/    # auth_service.dart (Firebase Auth), api_service.dart
│   │   └─ main.dart
│   ├─ pubspec.yaml
│   └─ test/
├─ docker-compose.yml     # Backend + Firestore emulator
├─ .env.example
└─ Project_Explanation.md
```

### Key Backend Files
| File | Purpose |
|------|---------|
| `app/main.py` | FastAPI app entry point; registers scan router, CORS, lifespan (Firebase init, HF client teardown), `/health`, `/ready`, and security headers middleware. |
| `app/api/routes/scan.py` | `POST /api/scan` — full two‑tier pipeline. `GET /api/scan` — paginated scan history. `GET /api/scan/stats` — user statistics. |
| `app/core/config.py` | Pydantic settings — loads `HUGGINGFACE_API_KEY`, `NVIDIA_API_KEY`, `FIREBASE_*` credentials, rate limits, and thresholds from `.env`. |
| `app/core/security.py` | Magic‑byte validation (`verify_file_signature`), SHA‑256 hashing (`generate_file_hash`). |
| `app/services/hf_client.py` | Async Hugging Face client with model fallbacks, retry logic, cold‑start detection, and response parsing. |
| `app/services/gemini_client.py` | NVIDIA NIM client using OpenAI SDK for Tier‑2 visual forensics. |
| `app/services/firestore_db.py` | Firestore adapter — creates/updates scans, checks hash deduplication, logs audit entries. |

### Key Flutter Files
| File | Purpose |
|------|---------|
| `lib/main.dart` | App entry point; initialises Firebase, sets Material 3 dark theme, `AuthWrapper` routes between landing/login/dashboard. |
| `lib/screens/login_screen.dart` | Email/password login, register toggle, Google OAuth sign‑in. |
| `lib/screens/dashboard_screen.dart` | File picker, scan trigger, threat score gauge, scan history chart, logout. |
| `lib/services/auth_service.dart` | Wraps `FirebaseAuth` — `signInWithEmailAndPassword`, `registerWithEmailAndPassword`, `signInWithGoogle`, `getIdToken`, `signOut`. |
| `lib/services/api_service.dart` | HTTP client — `POST /api/scan`, `GET /api/scan`, `GET /api/scan/stats`; includes JWT in `Authorization` header. |

---

## 🚀 Getting Started

### Prerequisites
- **Docker Desktop** ≥ 20.10
- **Flutter SDK** ≥ 3.19 (https://flutter.dev/docs/get-started/install)
- **Python** 3.11
- **Git**
- **Firebase project** with Firestore and Authentication enabled (see `.env.example` for required keys)

### 1. Clone the Repository
```bash
git clone https://github.com/your-org/deepfake-auth-gateway.git
cd deepfake-auth-gateway
```

### 2. Configure Environment Variables
```bash
cp .env.example .env
# Fill in all required values:
#   FIREBASE_PROJECT_ID      (from firebase-service-account.json)
#   HUGGINGFACE_API_TOKEN   (from huggingface.co → Access Tokens)
#   NVIDIA_API_KEY          (from console.nvidia.com → API Keys)
#   DEBUG=true              (for development)
```
> **Note:** Place your Firebase admin SDK JSON file (e.g., `nexus-gateway-xxx-firebase-adminsdk-xxx.json`) inside the `backend/` folder.

### 3. Start the Backend
```bash
# Uses docker-compose which starts the FastAPI service + Firestore emulator
docker compose up --build
```
- **API server**: `http://localhost:8000`
- **API docs**: `http://localhost:8000/api/docs`
- **Readiness**: `http://localhost:8000/ready`

For local development without Docker:
```bash
cd backend
pip install -r requirements.txt
python -m uvicorn app.main:app --reload --port 8000
```

### 4. Run the Flutter Client
```bash
cd flutter-client

# Install dependencies
flutter pub get

# Build and run for production (WebAssembly optimized)
flutter build web --wasm
```

### 5. Connecting the Client to the Backend
The `ApiService` in `flutter-client/lib/services/api_service.dart` already points to:
- **Web/Desktop**: `http://127.0.0.1:8000`
- **Android emulator**: `http://10.0.2.2:8000`

The Firebase ID token (from `AuthService.getIdToken()`) is sent as a Bearer token in every API request. The backend validates it via `verify_firebase_token` in `app/api/dependencies.py`.

---

## 🧪 Testing

### Backend
```bash
cd backend
pytest
```

### Flutter
```bash
cd flutter-client
flutter test
```

CI pipelines (GitHub Actions) run both test suites on every push.

---

## 📦 Deployment Guide
1. Build and push the backend Docker image to your registry.
2. Deploy `docker-compose.yml` (or a Kubernetes Helm chart) to your production environment.
3. Set all required environment variables (`FIREBASE_PROJECT_ID`, `HUGGINGFACE_API_TOKEN`, `NVIDIA_API_KEY`, etc.) as production secrets.
4. Enable **TLS** (Traefik/Nginx) in front of the API.
5. Add Prometheus scraping for the `/ready` endpoint.
6. Set up **Alertmanager** alerts for failed scans, high latency, or Firestore connection issues.

> **Note:** The web client is compiled to WebAssembly (Wasm) for maximum performance. Ensure your hosting provider (e.g., Firebase Hosting, Vercel) is configured to serve `.wasm` files with the correct MIME type (`application/wasm`) and cross-origin isolation headers if required.

---

## 🌍 Real‑World Impact & Abuse Prevention
- **AI‑generated media scams** are proliferating: deepfake video impersonation, synthetic audio phishing, and fake image propaganda threaten individuals, brands, and democratic processes.
- **Financial institutions** face voice‑synthesis attacks that bypass voice‑based authentication.
- **Social platforms** struggle to detect and remove malicious content at scale.
- **Our Gateway** provides a plug‑and‑play verification layer:
  - **Instant credibility scoring** before media is posted or shared.
  - **Audit trails** suitable for forensic investigations and compliance reporting.
  - **Two‑tier AI pipeline** ensures no deepfake slips through even if Tier‑1 is bypassed.
- **Societal benefit** – By lowering the barrier to deepfake detection, journalists, NGOs, and law‑enforcement agencies can quickly validate suspect media.

---

## 🏆 Judges' Scoring Criteria & Competitive Edge
| Criterion | How the Project Excels |
|-----------|----------------------|
| **Technical Depth** | Two‑tier AI pipeline, zero‑trust image override, magic‑byte inspection, SHA‑256 hashing, async HF client with cold‑start retry. |
| **Innovation** | Tier‑2 NVIDIA NIM visual forensics on every image regardless of Tier‑1 score; forced Tier‑2 for audio payloads. |
| **Scalability & Ops** | Docker‑compose, stateless FastAPI, horizontal scaling plan, observability built in. |
| **Social Impact** | Directly mitigates deepfake‑driven fraud, misinformation, and voice‑phishing attacks. |
| **Documentation & Walkthrough** | Complete setup guide, Docker instructions, environment configuration, CI/CD pipeline. |
| **Code Quality** | Typed Pydantic schemas, linted Flutter code, async/await throughout, test coverage. |
| **Extensibility** | Modular services allow swapping Tier‑2 models, adding new media types, or swapping Firebase for Supabase without breaking the contract. |
| **Performance** | Streaming file reads (1 MB chunks), async HF calls, client‑side image compression planned. |
| **Security** | Magic‑byte validation, JWT verification, rate limiting, security headers on every response. |
| **Community Readiness** | Open‑source ready, Flutter cross‑platform (iOS/Android/Web/Desktop), Docker images for production. |

---

## 📚 Additional Resources
- **Firebase Auth Docs** – https://firebase.google.com/docs/auth
- **Firebase Firestore** – https://firebase.google.com/docs/firestore
- **FastAPI Security** – https://fastapi.tiangolo.com/tutorial/security/
- **Hugging Face Inference API** – https://huggingface.co/docs/api-inference
- **NVIDIA NIM** – https://docs.nvidia.com/nim/
- **Flutter Docs** – https://flutter.dev/docs
- **Docker Compose Reference** – https://docs.docker.com/compose/

Happy hacking! 🚀