# Deepfake Authentication Gateway 
**Project Overview & File Explanations**

## Prompt for Explanation
*If you need a quick prompt to explain the architecture to a judge, investor, or reviewer, you can use the following:*

> "This project is an Enterprise-Grade Deepfake Authentication Gateway. It features a zero-trust architecture powered by a FastAPI backend, a Next.js web client, and a Supabase PostgreSQL database. The system ensures top-tier security by enforcing Row Level Security (RLS) on the database, explicitly validating JWT tokens on the backend APIs, and proactively mitigating malicious payloads by inspecting file magic-bytes before passing the media to Hugging Face AI models for deepfake detection. It also leverages cryptographic deduplication via SHA-256 hashing to eliminate redundant AI processing."

---

## Files Built (One-Line Explanations)

### 🗄️ Database (`database/`)
*   **`schema.sql`**: Sets up the PostgreSQL tables (`users`, `scans`, `audit_logs`) and enforces zero-trust Row Level Security (RLS).
*   **`SETUP_GUIDE.md`**: Step-by-step instructions for deploying the database securely and acquiring the necessary Supabase API keys.

### ⚙️ Backend (`backend/app/`)
*   **`models/schemas.py`**: Defines strict Pydantic data models to safely validate and enforce the shape of all incoming/outgoing API data.
*   **`core/security.py`**: Implements malicious payload mitigation by cryptographically sniffing file magic-bytes and generating SHA-256 hashes.
*   **`api/dependencies.py`**: Secures our endpoints via a zero-trust perimeter that strictly decodes and verifies Supabase JWT access tokens.
*   **`services/hf_client.py`**: An asynchronous network client that manages real-time, resilient communication with Hugging Face deepfake models.
*   **`services/supabase_db.py`**: A secure database adapter that handles cryptographic scan deduplication and permanent audit logging.
*   **`api/routes/scan.py`**: The main `POST /scan` orchestrator that authenticates the user, inspects the file, deduplicates, analyzes, logs, and returns the threat score.

### 🌐 Web Client (`web-client/src/`)
*   **`lib/supabase.ts`**: Initializes the secure Supabase client used for handling frontend browser sessions and authentication.
*   **`app/login/page.tsx`**: A responsive, Tailwind CSS-styled login screen that safely passes credentials to Supabase Auth.
*   **`app/dashboard/page.tsx`**: A protected route that natively respects database RLS to safely display only the logged-in user's historical scans.
