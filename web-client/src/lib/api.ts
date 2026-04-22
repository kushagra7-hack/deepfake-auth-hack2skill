/**
 * API Client Configuration
 * 
 * Provides type-safe API calls to the FastAPI backend with automatic
 * JWT token injection and error handling.
 */

import { getAccessToken } from './supabase'

const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000'

export interface ScanResultDetails {
  gemini_verdict?: 'AUTHENTIC' | 'DEEPFAKE'
  gemini_reasoning?: string
  hf_score?: number
  hf_score_pct?: number
  tier_used?: number
  model_used?: string
  is_deepfake?: boolean
  confidence_level?: 'low' | 'medium' | 'high'
  processing_time_ms?: number
  error?: string
  error_type?: string
  message?: string
}

export interface ScanResponse {
  id: string
  user_id: string
  file_name: string
  file_hash: string
  threat_score: number | null
  status: 'pending' | 'processing' | 'completed' | 'failed'
  media_type: string | null
  file_size: number | null
  result_details: ScanResultDetails | null
  created_at: string
  completed_at: string | null
}

export interface ScanListResponse {
  scans: ScanResponse[]
  total: number
  page: number
  page_size: number
}

export interface ScanStatsResponse {
  total_scans: number
  pending_scans: number
  completed_scans: number
  avg_threat_score: number
}

export interface AdminStatsResponse {
  total_users: number
  total_scans: number
  active_users: number
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

class ApiClient {
  private baseUrl: string

  constructor(baseUrl: string) {
    this.baseUrl = baseUrl
  }

  private async getHeaders(): Promise<HeadersInit> {
    const token = await getAccessToken()
    
    const headers: HeadersInit = {
      'Content-Type': 'application/json',
    }
    
    if (token) {
      headers['Authorization'] = `Bearer ${token}`
    }
    
    return headers
  }

  private async handleResponse<T>(response: Response): Promise<T> {
    if (!response.ok) {
      const errorData = await response.json().catch(() => ({}))
      const errorMsg = errorData.detail || errorData.message || 'An unknown error occurred'
      throw new ApiClientError(errorMsg, response.status, errorData)
    }
    
    return response.json()
  }

  async get<T>(endpoint: string): Promise<T> {
    const response = await fetch(`${this.baseUrl}${endpoint}`, {
      method: 'GET',
      headers: await this.getHeaders(),
    })
    
    return this.handleResponse<T>(response)
  }

  async post<T>(endpoint: string, data?: unknown): Promise<T> {
    const response = await fetch(`${this.baseUrl}${endpoint}`, {
      method: 'POST',
      headers: await this.getHeaders(),
      body: data ? JSON.stringify(data) : undefined,
    })
    
    return this.handleResponse<T>(response)
  }

  async patch<T>(endpoint: string, data: unknown): Promise<T> {
    const response = await fetch(`${this.baseUrl}${endpoint}`, {
      method: 'PATCH',
      headers: await this.getHeaders(),
      body: JSON.stringify(data),
    })
    
    return this.handleResponse<T>(response)
  }

  async delete<T>(endpoint: string): Promise<T> {
    const response = await fetch(`${this.baseUrl}${endpoint}`, {
      method: 'DELETE',
      headers: await this.getHeaders(),
    })
    
    return this.handleResponse<T>(response)
  }

  async uploadFile<T>(endpoint: string, file: File, onProgress?: (p: number) => void): Promise<T> {
    const token = await getAccessToken()
    
    return new Promise((resolve, reject) => {
      const xhr = new XMLHttpRequest()
      xhr.open('POST', `${this.baseUrl}${endpoint}`)
      
      if (token) {
        xhr.setRequestHeader('Authorization', `Bearer ${token}`)
      }
      
      if (onProgress) {
        xhr.upload.onprogress = (event) => {
          if (event.lengthComputable) {
            onProgress(Math.round((event.loaded / event.total) * 100))
          }
        }
      }
      
      xhr.onload = () => {
        if (xhr.status >= 200 && xhr.status < 300) {
          try {
            resolve(JSON.parse(xhr.responseText))
          } catch (e) {
            resolve(xhr.responseText as unknown as T)
          }
        } else {
          try {
            const error = JSON.parse(xhr.responseText)
            const errorMsg = error.detail || error.message || 'Upload failed'
            reject(new ApiClientError(errorMsg, xhr.status, error))
          } catch (e) {
            reject(new ApiClientError('Upload failed', xhr.status))
          }
        }
      }
      
      xhr.onerror = () => reject(new ApiClientError('Network error', 0))
      
      const formData = new FormData()
      formData.append('file', file)
      xhr.send(formData)
    })
  }
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

export const apiClient = new ApiClient(API_URL)

export async function getScans(page = 1, pageSize = 20): Promise<ScanListResponse> {
  return apiClient.get<ScanListResponse>(`/api/scan?page=${page}&page_size=${pageSize}`)
}

export async function getScanById(scanId: string): Promise<ScanResponse> {
  return apiClient.get<ScanResponse>(`/api/scan/${scanId}`)
}

export async function uploadScan(file: File, onProgress?: (p: number) => void): Promise<ScanResponse> {
  return apiClient.uploadFile<ScanResponse>('/api/scan', file, onProgress)
}

export async function getScanStats(): Promise<ScanStatsResponse> {
  return apiClient.get<ScanStatsResponse>('/api/scan/stats/summary')
}

export async function getUserProfile(): Promise<UserProfile> {
  return apiClient.get<UserProfile>('/api/auth/me')
}

export async function updateUserProfile(data: { full_name?: string }): Promise<UserProfile> {
  return apiClient.patch<UserProfile>('/api/auth/me', data)
}

export async function deleteAccount(): Promise<{ message: string }> {
  return apiClient.delete<{ message: string }>('/api/auth/me')
}

export async function getAdminStats(): Promise<AdminStatsResponse> {
  return apiClient.get<AdminStatsResponse>('/api/admin/stats')
}

export async function getAdminUsers(): Promise<UserProfile[]> {
  return apiClient.get<UserProfile[]>('/api/admin/users')
}

export async function updateUserRole(userId: string, role: string): Promise<{ message: string }> {
  return apiClient.patch<{ message: string }>(`/api/admin/users/${userId}/role`, { role })
}
