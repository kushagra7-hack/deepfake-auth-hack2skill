'use client'

import { useEffect, useState } from 'react'
import { apiClient } from '@/lib/api'

export default function StatusPage() {
  const [backendStatus, setBackendStatus] = useState<{ status: string; version?: string } | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const checkBackend = async () => {
      try {
        const data = await apiClient.get<{ status: string; version: string }>('/health')
        setBackendStatus(data)
      } catch (error) {
        setBackendStatus({ status: 'unreachable' })
      } finally {
        setLoading(false)
      }
    }
    checkBackend()
  }, [])

  return (
    <div className="min-h-screen bg-slate-900 flex items-center justify-center p-8 text-center text-white">
      <div className="max-w-md w-full p-6 bg-slate-800 rounded-xl border border-slate-700">
        <h1 className="text-2xl font-bold mb-4">System Status</h1>
        
        <div className="space-y-4">
          <div className="flex justify-between items-center p-3 bg-slate-900/50 rounded-lg">
            <span>Web Client</span>
            <span className="text-green-500 font-medium tracking-wide">OPERATIONAL</span>
          </div>
          
          <div className="flex justify-between items-center p-3 bg-slate-900/50 rounded-lg">
            <span>Backend API</span>
            {loading ? (
              <span className="text-slate-400">Checking...</span>
            ) : backendStatus?.status === 'unreachable' ? (
              <span className="text-red-500 font-medium tracking-wide">UNREACHABLE</span>
            ) : (
              <span className="text-green-500 font-medium tracking-wide">
                OPERATIONAL <span className="text-slate-500 text-xs ml-1">(v{backendStatus?.version})</span>
              </span>
            )}
          </div>
        </div>
      </div>
    </div>
  )
}
