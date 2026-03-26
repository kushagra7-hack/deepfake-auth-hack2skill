/**
 * API Client for Deepfake Gateway Mobile
 * 
 * Handles all API communication with the FastAPI backend
 * with automatic JWT injection from secure storage.
 */

import { getJWT, saveJWT, clearAuthSession } from './secure-store'
import Constants from 'expo-constants'

const API_URL = Constants.expoConfig?.extra?.apiUrl || process.env.EXPO_PUBLIC_API_URL || 'http://localhost:8000'

export interface ScanResponse {
  id: string
  user_id: string
  file_name: string
  file_hash: string
  threat_score: number | null
  status: 'pending' | 'processing' | 'completed' | 'failed'
  media_type: string | null
  file_size: number | null
  result_details: Record<string, unknown> | null
  created_at: string
  completed_at: string | null
}

export interface ScanListResponse {
  scans: ScanResponse[]
  total: number
  page: number
  page_size: number
}

export interface UserProfile {
  id: string
  email: string
  full_name: string | null
  role: string
  created_at: string
  is_active: boolean
}

export interface ApiError {
  error: string
  message: string
  details?: Record<string, unknown>
}

export class ApiClientError extends Error {
  constructor(
    message: string,
    public status: number,
    public details?: ApiError
  ) {
    super(message)
    this.name = 'ApiClientError'
  }
}

export interface LoginCredentials {
  email: string
  password: string
}

export interface AuthResponse {
  access_token: string
  refresh_token: string
  token_type: string
  expires_in: number
  user: {
    id: string
    email: string
  }
}

export interface SupabaseConfig {
  supabaseUrl: string
  supabaseAnonKey: string
}

const SUPABASE_URL = Constants.expoConfig?.extra?.supabaseUrl || process.env.EXPO_PUBLIC_SUPABASE_URL
const SUPABASE_ANON_KEY = Constants.expoConfig?.extra?.supabaseAnonKey || process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY

/**
 * Login with email and password via Supabase
 */
export async function login(email: string, password: string): Promise<AuthResponse> {
  if (!SUPABASE_URL || !SUPABASE_ANON_KEY) {
    throw new Error('Supabase configuration missing')
  }

  const response = await fetch(`${SUPABASE_URL}/auth/v1/token?grant_type=password`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'apikey': SUPABASE_ANON_KEY,
    },
    body: JSON.stringify({ email, password }),
  })

  if (!response.ok) {
    const error = await response.json().catch(() => ({ error_description: 'Login failed' }))
    throw new ApiClientError(
      error.error_description || error.message || 'Login failed',
      response.status
    )
  }

  const data = await response.json()
  
  await saveJWT(data.access_token)
  
  return {
    access_token: data.access_token,
    refresh_token: data.refresh_token,
    token_type: data.token_type || 'bearer',
    expires_in: data.expires_in || 3600,
    user: {
      id: data.user?.id || '',
      email: data.user?.email || email,
    },
  }
}

/**
 * Logout and clear session
 */
export async function logout(): Promise<void> {
  await clearAuthSession()
}

/**
 * Make authenticated API request
 */
async function apiRequest<T>(
  endpoint: string,
  options: RequestInit = {}
): Promise<T> {
  const token = await getJWT()
  
  if (!token) {
    throw new ApiClientError('Not authenticated', 401)
  }

  const response = await fetch(`${API_URL}${endpoint}`, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`,
      ...options.headers,
    },
  })

  if (response.status === 401) {
    await clearAuthSession()
    throw new ApiClientError('Session expired', 401)
  }

  if (!response.ok) {
    const error: ApiError = await response.json().catch(() => ({
      error: 'unknown_error',
      message: 'An unknown error occurred',
    }))
    throw new ApiClientError(error.message, response.status, error)
  }

  return response.json()
}

/**
 * Upload file for scanning
 */
export async function uploadScan(fileUri: string, fileName: string): Promise<ScanResponse> {
  const token = await getJWT()
  
  if (!token) {
    throw new ApiClientError('Not authenticated', 401)
  }

  const formData = new FormData()
  
  const file = {
    uri: fileUri,
    type: getMimeType(fileName),
    name: fileName,
  }
  
  formData.append('file', file as unknown as Blob)

  const response = await fetch(`${API_URL}/api/scan`, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${token}`,
    },
    body: formData,
  })

  if (response.status === 401) {
    await clearAuthSession()
    throw new ApiClientError('Session expired', 401)
  }

  if (!response.ok) {
    const error: ApiError = await response.json().catch(() => ({
      error: 'upload_failed',
      message: 'Failed to upload file',
    }))
    throw new ApiClientError(error.message, response.status, error)
  }

  return response.json()
}

/**
 * Get user's scan history
 */
export async function getScans(page = 1, pageSize = 20): Promise<ScanListResponse> {
  return apiRequest<ScanListResponse>(`/api/scan?page=${page}&page_size=${pageSize}`)
}

/**
 * Get scan by ID
 */
export async function getScanById(scanId: string): Promise<ScanResponse> {
  return apiRequest<ScanResponse>(`/api/scan/${scanId}`)
}

/**
 * Get user profile
 */
export async function getUserProfile(): Promise<UserProfile> {
  return apiRequest<UserProfile>('/api/auth/me')
}

/**
 * Get MIME type from filename
 */
function getMimeType(fileName: string): string {
  const ext = fileName.split('.').pop()?.toLowerCase()
  
  const mimeTypes: Record<string, string> = {
    mp4: 'video/mp4',
    avi: 'video/x-msvideo',
    mov: 'video/quicktime',
    webm: 'video/webm',
    mkv: 'video/x-matroska',
    mp3: 'audio/mpeg',
    wav: 'audio/wav',
    flac: 'audio/flac',
    ogg: 'audio/ogg',
    png: 'image/png',
    jpg: 'image/jpeg',
    jpeg: 'image/jpeg',
    gif: 'image/gif',
    webp: 'image/webp',
    bmp: 'image/bmp',
  }
  
  return mimeTypes[ext || ''] || 'application/octet-stream'
}

/**
 * Check if user has valid session
 */
export async function checkAuth(): Promise<boolean> {
  try {
    const token = await getJWT()
    return token !== null
  } catch {
    return false
  }
}
