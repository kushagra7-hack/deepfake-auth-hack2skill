'use client'

import { useEffect, useState, useCallback } from 'react'
import { useRouter } from 'next/navigation'
import { supabase, signOut } from '@/lib/supabase'
import { getScans, getScanStats, uploadScan, type ScanResponse, type ScanStatsResponse } from '@/lib/api'
import toast from 'react-hot-toast'
import UploadZone from '@/components/upload-zone'

function formatDate(dateString: string): string {
  return new Date(dateString).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  })
}

function getStatusBadge(status: string) {
  const styles: Record<string, string> = {
    pending: 'bg-yellow-500/10 text-yellow-500 border-yellow-500/20',
    processing: 'bg-blue-500/10 text-blue-500 border-blue-500/20',
    completed: 'bg-green-500/10 text-green-500 border-green-500/20',
    failed: 'bg-red-500/10 text-red-500 border-red-500/20',
  }
  return styles[status] || 'bg-slate-500/10 text-slate-500 border-slate-500/20'
}

function getThreatLevel(score: number | null): { label: string; color: string } {
  if (score === null) return { label: 'N/A', color: 'text-slate-400' }
  if (score >= 70) return { label: 'High Risk', color: 'text-red-500' }
  if (score >= 30) return { label: 'Medium Risk', color: 'text-yellow-500' }
  return { label: 'Low Risk', color: 'text-green-500' }
}

export default function DashboardPage() {
  const router = useRouter()
  const [isLoading, setIsLoading] = useState(true)
  const [user, setUser] = useState<{ email: string } | null>(null)
  const [scans, setScans] = useState<ScanResponse[]>([])
  const [stats, setStats] = useState<ScanStatsResponse | null>(null)
  const [page, setPage] = useState(1)
  const [totalPages, setTotalPages] = useState(1)

  const fetchData = useCallback(async () => {
    try {
      const [scansData, statsData] = await Promise.all([
        getScans(page, 10),
        getScanStats(),
      ])
      
      setScans(scansData.scans)
      setTotalPages(Math.ceil(scansData.total / 10))
      setStats(statsData)
    } catch (error) {
      console.error('Error fetching data:', error)
      toast.error('Failed to load scan data')
    } finally {
      setIsLoading(false)
    }
  }, [page])

  useEffect(() => {
    const checkSession = async () => {
      const { data: { session } } = await supabase.auth.getSession()
      
      if (!session) {
        router.push('/login')
        return
      }
      
      setUser({ email: session.user.email || 'user@example.com' })
      fetchData()
    }
    
    checkSession()
    
    const { data: { subscription } } = supabase.auth.onAuthStateChange(
      (event) => {
        if (event === 'SIGNED_OUT') {
          router.push('/login')
        }
      }
    )
    
    return () => {
      subscription.unsubscribe()
    }
  }, [router, fetchData])

  const handleSignOut = async () => {
    try {
      await signOut()
      router.push('/login')
    } catch (error) {
      toast.error('Failed to sign out')
    }
  }

  const handleUpload = async (file: File) => {
    try {
      toast.loading('Uploading file...', { id: 'upload' })
      const result = await uploadScan(file)
      toast.success('File uploaded successfully!', { id: 'upload' })
      setScans((prev) => [result, ...prev])
      fetchData()
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Upload failed', { id: 'upload' })
    }
  }

  if (isLoading) {
    return (
      <div className="min-h-screen bg-slate-900 flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-500"></div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-slate-900">
      <header className="bg-slate-800/50 border-b border-slate-700">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-3">
              <div className="w-10 h-10 bg-gradient-to-r from-primary-500 to-primary-600 rounded-xl flex items-center justify-center">
                <svg className="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                </svg>
              </div>
              <div>
                <h1 className="text-xl font-bold text-white">Deepfake Gateway</h1>
                <p className="text-sm text-slate-400">{user?.email}</p>
              </div>
            </div>
            <button
              onClick={handleSignOut}
              className="px-4 py-2 text-sm text-slate-300 hover:text-white transition-colors"
            >
              Sign Out
            </button>
          </div>
        </div>
      </header>

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {stats && (
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-8">
            <div className="bg-slate-800/50 rounded-xl p-6 border border-slate-700">
              <p className="text-sm text-slate-400 mb-1">Total Scans</p>
              <p className="text-3xl font-bold text-white">{stats.total_scans}</p>
            </div>
            <div className="bg-slate-800/50 rounded-xl p-6 border border-slate-700">
              <p className="text-sm text-slate-400 mb-1">Pending</p>
              <p className="text-3xl font-bold text-yellow-500">{stats.pending_scans}</p>
            </div>
            <div className="bg-slate-800/50 rounded-xl p-6 border border-slate-700">
              <p className="text-sm text-slate-400 mb-1">Completed</p>
              <p className="text-3xl font-bold text-green-500">{stats.completed_scans}</p>
            </div>
            <div className="bg-slate-800/50 rounded-xl p-6 border border-slate-700">
              <p className="text-sm text-slate-400 mb-1">Avg Threat Score</p>
              <p className="text-3xl font-bold text-white">{stats.avg_threat_score.toFixed(1)}%</p>
            </div>
          </div>
        )}

        <div className="mb-8">
          <UploadZone onUpload={handleUpload} />
        </div>

        <div className="bg-slate-800/50 rounded-xl border border-slate-700 overflow-hidden">
          <div className="px-6 py-4 border-b border-slate-700">
            <h2 className="text-lg font-semibold text-white">Scan History</h2>
            <p className="text-sm text-slate-400 mt-1">
              Protected by Row Level Security - you can only see your own scans
            </p>
          </div>

          {scans.length === 0 ? (
            <div className="px-6 py-12 text-center">
              <svg className="mx-auto h-12 w-12 text-slate-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
              </svg>
              <h3 className="mt-2 text-sm font-medium text-slate-300">No scans yet</h3>
              <p className="mt-1 text-sm text-slate-500">Upload a file to get started with deepfake detection.</p>
            </div>
          ) : (
            <div className="overflow-x-auto">
              <table className="w-full">
                <thead>
                  <tr className="text-left text-sm text-slate-400 border-b border-slate-700">
                    <th className="px-6 py-3 font-medium">File Name</th>
                    <th className="px-6 py-3 font-medium">Status</th>
                    <th className="px-6 py-3 font-medium">Threat Score</th>
                    <th className="px-6 py-3 font-medium">Media Type</th>
                    <th className="px-6 py-3 font-medium">Date</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-700">
                  {scans.map((scan) => {
                    const threatLevel = getThreatLevel(scan.threat_score)
                    return (
                      <tr key={scan.id} className="hover:bg-slate-700/30 transition-colors">
                        <td className="px-6 py-4">
                          <div className="flex items-center space-x-3">
                            <div className="flex-shrink-0">
                              {scan.media_type === 'image' && (
                                <svg className="w-5 h-5 text-purple-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                </svg>
                              )}
                              {scan.media_type === 'video' && (
                                <svg className="w-5 h-5 text-blue-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 10l4.553-2.276A1 1 0 0121 8.618v6.764a1 1 0 01-1.447.894L15 14M5 18h8a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2z" />
                                </svg>
                              )}
                              {scan.media_type === 'audio' && (
                                <svg className="w-5 h-5 text-green-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 19V6l12-3v13M9 19c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zm12-3c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zM9 10l12-3" />
                                </svg>
                              )}
                            </div>
                            <span className="text-white font-medium">{scan.file_name}</span>
                          </div>
                        </td>
                        <td className="px-6 py-4">
                          <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium border ${getStatusBadge(scan.status)}`}>
                            {scan.status.charAt(0).toUpperCase() + scan.status.slice(1)}
                          </span>
                        </td>
                        <td className="px-6 py-4">
                          <div className="flex items-center space-x-2">
                            <span className={`font-medium ${threatLevel.color}`}>
                              {scan.threat_score !== null ? `${scan.threat_score.toFixed(1)}%` : 'N/A'}
                            </span>
                            {scan.threat_score !== null && (
                              <span className={`text-xs ${threatLevel.color}`}>
                                ({threatLevel.label})
                              </span>
                            )}
                          </div>
                        </td>
                        <td className="px-6 py-4 text-slate-300">
                          {scan.media_type ? scan.media_type.charAt(0).toUpperCase() + scan.media_type.slice(1) : 'Unknown'}
                        </td>
                        <td className="px-6 py-4 text-slate-400 text-sm">
                          {formatDate(scan.created_at)}
                        </td>
                      </tr>
                    )
                  })}
                </tbody>
              </table>
            </div>
          )}

          {totalPages > 1 && (
            <div className="px-6 py-4 border-t border-slate-700 flex items-center justify-between">
              <button
                onClick={() => setPage((p) => Math.max(1, p - 1))}
                disabled={page === 1}
                className="px-4 py-2 text-sm text-slate-300 hover:text-white disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
              >
                Previous
              </button>
              <span className="text-sm text-slate-400">
                Page {page} of {totalPages}
              </span>
              <button
                onClick={() => setPage((p) => Math.min(totalPages, p + 1))}
                disabled={page === totalPages}
                className="px-4 py-2 text-sm text-slate-300 hover:text-white disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
              >
                Next
              </button>
            </div>
          )}
        </div>
      </main>
    </div>
  )
}
