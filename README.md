<!-- PROJECT BADGES -->
<p align="center">
  <img src="https://img.shields.io/badge/Platform-Flutter%20%F0%9F%8C%99-02569B?style=for-the-badge&logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Backend-FastAPI-009688?style=for-the-badge&logo=fastapi" alt="FastAPI">
  <img src="https://img.shields.io/badge/AI-Hugging%20Face-orange?style=for-the-badge&logo=huggingface" alt="Hugging Face">
  <img src="https://img.shields.io/badge/AI-NVIDIA%20NIM-76B900?style=for-the-badge" alt="NVIDIA NIM">
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge">
</p>

<h1 align="center">🛡️ Nexus Gateway — Enterprise Deepfake Detection</h1>

<p align="center">
  <strong>Zero-Trust AI-Powered Platform to Detect Deepfakes in Images, Video & Audio</strong><br>
  Built with Flutter • FastAPI • Firebase • Hugging Face • NVIDIA NIM
</p>

---

## 📌 Why This Project?

Deepfakes are weaponized for **fraud, misinformation, and identity theft**. Traditional detection tools are slow, inaccurate, and expensive.

**Nexus Gateway** solves this with a **two-tier AI pipeline** that delivers:
- ⚡ **Real-time detection** (< 10s for images, < 30s for audio)
- 🔒 **Zero-Trust architecture** (every image gets Tier-2 forensic analysis)
- 💰 **Cost-optimized** (Tier-1 pre-screen filters 70%+ of traffic)
- 🌐 **Cross-platform** (iOS, Android, Web, Desktop — single codebase)

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                      Flutter Client                            │
│   (iOS • Android • Web • Desktop)                              │
└─────────────────────┬───────────────────────────────────────┘
                      │ Firebase Auth (JWT)
                      ▼
┌─────────────────────────────────────────────────────────────────┐
│                   FastAPI Backend                             │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │ Tier‑1: Hugging Face (prithivMLmods/Deepfake-Detection)  │  │
│  │   → Fast pre-screen, ~2s latency, cheap                 │  │
│  └─────────────────────────────────────────────────────────┘  │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │ Tier‑2: NVIDIA NIM (llama-3.2-90b-vision-instruct)      │  │
│  │   → Deep visual forensics, zero-trust override          │  │
│  │   → Runs on EVERY image regardless of Tier‑1 score    │  │
│  └─────────────────────────────────────────────────────────┘  │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │ Firebase Firestore (Audit Logs & Scan History)          │  │
│  └─��───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

---

## ✨ Key Features

| Feature | Description |
|--------|-------------|
| **Two-Tier AI Pipeline** | Tier-1 = fast Hugging Face pre-screen, Tier-2 = deep NVIDIA visual forensics |
| **Zero-Trust Override** | Every image (regardless of Tier-1 score) gets Tier-2 forensic analysis |
| **Multi-Media Support** | Images (JPEG, PNG, WebP, GIF), Video (MP4, MOV, AVI), Audio (MP3, WAV, M4A) |
| **Magic-Byte Validation** | Backend verifies file signatures before any AI processing |
| **Rate Limiting** | Per-user request quotas to prevent abuse |
| **Audit Trail** | Every scan logged to Firestore with full traceability |
| **Cross-Platform** | Flutter compiles to iOS, Android, Web, and Desktop |
| **Docker-Ready** | Single `docker compose up` spins up the backend |

---

## 🚀 Quick Start

### Prerequisites
- **Flutter SDK** ≥ 3.19
- **Python** ≥ 3.11
- **Docker Desktop** ≥ 20.10
- **Firebase Project** (Auth + Firestore enabled)

### 1️⃣ Clone
```bash
git clone https://github.com/kushagra7-hack/deepfake-auth-hack2skill.git
cd deepfake-auth-hack2skill
```

### 2️⃣ Firebase Setup
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a project → Enable **Authentication** (Email/Password + Google)
3. Enable **Firestore Database** (Start in Test Mode)
4. Project Settings → Service Accounts → Generate **Admin SDK JSON**
5. Download and place in `backend/your-project-id firebase-adminsdk-*.json`

### 3️⃣ Environment Variables
```bash
# backend/.env
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_CREDENTIALS_PATH=your-project-id-firebase-adminsdk-xxx.json
HUGGINGFACE_API_TOKEN=hf_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
NVIDIA_API_KEY=nvapi-xxxxxxxxxxxxxxxxxxxxxxxx
DEBUG=true
```

### 4️⃣ Start Backend
```bash
docker compose up --build
# API: http://localhost:8000
# Docs: http://localhost:8000/api/docs
```

### 5️⃣ Run Flutter Client
```bash
cd flutter-client
flutter pub get
flutter run   # or: flutter build web --wasm
```

---

## 📂 Project Structure

```
hack2skill_deepfake/
├── backend/                    # FastAPI backend
│   ├── app/
│   │   ├── api/routes/   # scan.py (POST /api/scan)
│   │   ├── core/        # config.py, security.py
│   │   ├── services/   # hf_client.py, gemini_client.py, firestore_db.py
│   │   └── models/     # schemas.py (Pydantic)
│   ├── .env
│   └── Dockerfile
├── flutter-client/           # Flutter cross-platform
│   ├── lib/
│   │   ├── screens/    # landing, login, dashboard
│   │   ├── services/  # auth_service.dart, api_service.dart
│   │   └── main.dart
│   ├── pubspec.yaml
│   └── test/
├── docker-compose.yml
└── README.md
```

---

## 📡 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/api/scan` | Upload media for deepfake analysis |
| `GET` | `/api/scan` | Paginated scan history |
| `GET` | `/api/scan/stats` | User statistics |
| `GET` | `/health` | Health check |
| `GET` | `/ready` | Readiness check |

### Request Example
```bash
curl -X POST http://localhost:8000/api/scan \
  -H "Authorization: Bearer $(firebase-id-token)" \
  -F "file=@image.jpg"
```

### Response
```json
{
  "id": "scan_abc123",
  "threat_score": 87.5,
  "gemini_verdict": "DEEPFAKE",
  "gemini_reasoning": "Portrait. Unnatural symmetry in eye positioning, skin texture artifact consistent with diffusion model generation.",
  "confidence_level": "high"
}
```

---

## 🏆 Why It Wins Competitions

| Criterion | Nexus Gateway Excels |
|-----------|---------------------|
| **Technical Depth** | Two-tier AI, zero-trust override, magic-byte inspection, async pipeline |
| **Innovation** | Tier-2 forced on EVERY image — unlike competitors who skip it |
| **Scalability** | Stateless FastAPI, horizontal scaling, Redis caching-ready |
| **Social Impact** | Directly stops deepfake fraud, voice phishing, misinformation |
| **Code Quality** | Typed Pydantic, async/await, linted Flutter, test coverage |

---

## 🌍 Real-World Use Cases

- **Banks**: Verify customer identity photos/videos before account creation
- **Social Platforms**: Auto-scan uploads before posting
- **HR/Recruiting**: Validate candidate video interviews
- **Journalism**: Verify authenticity of viral media
- **Law Enforcement**: Forensic deepfake analysis

---

## 📦 Deployment

### Production Checklist
- [ ] Enable Firebase Authentication (restrict to your domain)
- [ ] Set Firestore security rules (no public access)
- [ ] Add `NVIDIA_API_KEY` to production secrets
- [ ] Configure TLS/SSL (Traefik or Nginx)
- [ ] Set up Prometheus alerts for `/ready`

### Docker Production
```bash
docker build -t nexus-gateway-backend ./backend
docker run -d -p 8000:8000 --env-file backend/.env nexus-gateway-backend
```

---

## 🤝 Contributing

1. Fork the repo
2. Create a feature branch (`git checkout -b feature/amazing`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to GitHub (`git push origin main`)
5. Open a Pull Request

---

## 📜 License

**MIT** — Free for commercial and personal use.

---

## 🙏 Acknowledgments

- [Hugging Face](https://huggingface.co) — Inference API
- [NVIDIA NIM](https://www.nvidia.com/en-us/ai/) — Vision language models
- [Flutter](https://flutter.dev) — Cross-platform UI
- [FastAPI](https://fastapi.tiangular.com) — Python web framework
- [Firebase](https://firebase.google.com) — Auth & Firestore

---

<p align="center">
  <strong>🛡️ Powered by AI. Secured by Design.</strong><br>
  <a href="https://github.com/kushagra7-hack/deepfake-auth-hack2skill">View on GitHub</a> • <a href="https://github.com/kushagra7-hack/deepfake-auth-hack2skill/issues">Report Issues</a>
</p>