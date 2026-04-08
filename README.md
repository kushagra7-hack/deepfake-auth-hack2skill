# Deepfake Authentication Gateway

> **Enterprise‑grade deepfake detection and authentication**
>
> This project implements a zero‑trust architecture that combines a **FastAPI** backend, a **Next.js** web client, a **Supabase** PostgreSQL database, and optional **Expo** mobile client. It securely authenticates users, validates uploaded media, deduplicates scans, and leverages **Hugging Face** AI models to detect deepfakes.

---

## Table of Contents
- [Features](#features)
- [Architecture Overview](#architecture-overview)
- [Prerequisites](#prerequisites)
- [Quick Start (Docker Compose)](#quick-start-docker-compose)
- [Backend Setup](#backend-setup)
- [Web Client Setup](#web-client-setup)
- [Mobile Client Setup](#mobile-client-setup)
- [Database](#database)
- [Running Tests](#running-tests)
- [Contribution Guidelines](#contribution-guidelines)
- [License](#license)

---

## Features
- **Zero‑trust security**: JWT verification against Supabase, row‑level security (RLS) in the database.
- **Deepfake detection**: Asynchronous calls to Hugging Face models.
- **File validation**: Magic‑byte inspection and SHA‑256 deduplication to avoid redundant scans.
- **Scalable architecture**: Docker‑compose ready, can be deployed to any container platform.
- **Multi‑client support**: Web (Next.js) and mobile (Expo/React‑Native) front‑ends.
- **Extensive logging & audit**: All scans are logged with user context.

---

## Architecture Overview
```
+----------------+      +-------------------+      +-------------------+
|  Web Client    | ---> |   FastAPI Backend | ---> |   Supabase DB     |
| (Next.js)      |      | (Python)          |      | (PostgreSQL)      |
+----------------+      +-------------------+      +-------------------+
        |                         |                         |
        |                         |   +-------------------+
        |                         +---| Hugging Face AI   |
        |                             | (Deepfake Model) |
        +---------------------------+-------------------+
```
- **Web Client** authenticates via Supabase and calls the backend API.
- **Backend** validates JWT, inspects the uploaded file, checks for prior scans (deduplication), forwards the file to Hugging Face, logs the result, and returns a threat score.
- **Database** stores users, scan records, and audit logs. RLS ensures each user only sees their own data.

---

## Prerequisites
- **Docker & Docker‑Compose** (recommended for quick start)
- **Python 3.11+** (if running backend locally)
- **Node.js 20+** (for web‑client and mobile client)
- **Supabase account** – you will need the `SUPABASE_URL` and `SUPABASE_ANON_KEY` (and optionally the service‑role key) – see [`database/SETUP_GUIDE.md`](database/SETUP_GUIDE.md).
- **Hugging Face API token** – create at https://huggingface.co/settings/tokens.
- **Optional**: Expo CLI (`npm i -g expo-cli`) for the mobile client.

---

## Quick Start (Docker Compose)
1. **Copy the placeholder env file** and fill in your secrets:
   ```bash
   cp backend/.env.example backend/.env   # (if you have an example file) or edit the existing .env
   ```
   Populate the variables listed in the file (`SUPABASE_URL`, `HUGGINGFACE_API_KEY`, etc.).
2. **Start the stack**:
   ```bash
   docker compose up --build
   ```
   - Backend will be reachable at `http://localhost:8000`
   - Web client at `http://localhost:3000`
3. Open `http://localhost:3000` in your browser, sign‑up/login via Supabase, and start scanning files.

---

## Backend Setup (Manual)
```bash
# Clone the repo (already done)
cd backend
# Create a virtual environment
python -m venv venv
source venv/bin/activate   # Windows: venv\Scripts\activate
# Install dependencies
pip install -r requirements.txt
# Ensure a .env file exists (see the placeholder created earlier)
# Run the API
uvicorn app.main:app --host 0.0.0.0 --port 8000
```
The API documentation is automatically generated at `http://localhost:8000/docs`.

### Key Backend Packages
- **FastAPI** – high‑performance web framework.
- **Pydantic** – data validation.
- **httpx** – async HTTP client for Hugging Face.
- **supabase-py** – Supabase integration.
- **python‑jwt** – JWT verification.
- **python‑magic** – file‑type detection.

---

## Web Client Setup (Next.js)
```bash
cd web-client
npm install
npm run dev
```
The client expects the environment variable `NEXT_PUBLIC_API_URL` pointing to the backend (default `http://localhost:8000`). You can change it in `.env.local`.

### Main Pages
- **/login** – Supabase authentication.
- **/dashboard** – Shows a table of the user’s previous scans.
- **/scan** – Upload component that sends a file to `POST /scan`.

---

## Mobile Client Setup (Expo)
```bash
cd mobile-client
npm install
expo start
```
The mobile app mirrors the web client: login, scan, and view history. It stores the Supabase session securely using `expo-secure-store`.

---

## Database
The project uses Supabase (PostgreSQL) with a predefined schema.
1. Review the schema: [`database/schema.sql`](database/schema.sql)
2. Follow the step‑by‑step guide: [`database/SETUP_GUIDE.md`](database/SETUP_GUIDE.md) to create the tables, enable Row Level Security, and generate the necessary service‑role key.

---

## Running Tests
Backend tests are written with **pytest**.
```bash
cd backend
pytest
```
All tests should pass. Tests cover JWT validation, file inspection, and the scan orchestration logic.

---

## Contribution Guidelines
1. Fork the repository.
2. Create a feature branch (`git checkout -b feat/your-feature`).
3. Ensure code follows the existing style (black, isort, mypy). The repo includes pre‑commit hooks.
4. Write tests for new functionality.
5. Submit a Pull Request with a clear description of the change.

---

## License
This project is licensed under the **MIT License** – see the `LICENSE` file for details.

---

## Acknowledgements
- **Supabase** for instant auth & database.
- **Hugging Face** for state‑of‑the‑art deepfake detection models.
- **FastAPI** community for an excellent async framework.

---

*Happy hacking!*
