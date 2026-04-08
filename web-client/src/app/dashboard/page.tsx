'use client'

import { useEffect, useState, useCallback } from 'react'
import { useRouter } from 'next/navigation'
import { supabase, signOut } from '@/lib/supabase'
import { getScans, getScanStats, uploadScan, type ScanResponse, type ScanStatsResponse } from '@/lib/api'
import toast from 'react-hot-toast'
import UploadZone from '@/components/upload-zone'
import ThreatChart from '@/components/threat-chart'
import { GlobalAnimatedBackground } from '@/components/ui/spline-background'
import { ParallaxScrollFeatureSection } from '@/components/ui/parallax-scroll-feature-section'

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
    pending: 'bg-yellow-500/10 text-yellow-500 border-yellow-500/20 shadow-[0_0_10px_rgba(234,179,8,0.2)]',
    processing: 'bg-primary-500/10 text-primary-500 border-primary-500/20 shadow-[0_0_10px_rgba(59,130,246,0.2)]',
    completed: 'bg-emerald-500/10 text-emerald-500 border-emerald-500/20 shadow-[0_0_10px_rgba(16,185,129,0.2)]',
    failed: 'bg-rose-500/10 text-rose-500 border-rose-500/20 shadow-[0_0_10px_rgba(225,29,72,0.2)]',
  }
  return styles[status] || 'bg-zinc-500/10 text-zinc-400 border-zinc-500/20'
}

function getThreatLevel(score: number | string | null | undefined): { label: string; color: string } {
  if (score == null) return { label: 'N/A', color: 'text-zinc-500' }
  const numScore = Number(score)
  if (isNaN(numScore)) return { label: 'N/A', color: 'text-zinc-500' }
  if (numScore >= 70) return { label: 'Critical', color: 'text-rose-500 drop-shadow-[0_0_8px_rgba(225,29,72,0.5)]' }
  if (numScore >= 30) return { label: 'Elevated', color: 'text-amber-500 drop-shadow-[0_0_8px_rgba(245,158,11,0.5)]' }
  return { label: 'Secure', color: 'text-emerald-500 drop-shadow-[0_0_8px_rgba(16,185,129,0.5)]' }
}

function getGeminiVerdictBadge(verdict: string | undefined | null) {
  if (!verdict) return null
  const isDeepfake = verdict === 'DEEPFAKE'
  return (
    <span className={`inline-flex items-center gap-1 px-2.5 py-1 rounded-md text-[10px] font-bold uppercase tracking-widest border ${
      isDeepfake
        ? 'bg-rose-500/10 text-rose-400 border-rose-500/20 shadow-[0_0_8px_rgba(225,29,72,0.15)]'
        : 'bg-emerald-500/10 text-emerald-400 border-emerald-500/20 shadow-[0_0_8px_rgba(16,185,129,0.15)]'
    }`}>
      <span className={`w-1.5 h-1.5 rounded-full ${isDeepfake ? 'bg-rose-400' : 'bg-emerald-400'} animate-pulse`} />
      {verdict}
    </span>
  )
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

  const handleUpload = async (file: File, onProgress?: (p: number) => void) => {
    try {
      toast.loading('Initializing neural analysis...', { id: 'upload' })
      const result = await uploadScan(file, onProgress)
      toast.success('Analysis complete.', { id: 'upload' })
      setScans((prev) => [result, ...prev])
      fetchData()
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Analysis failed', { id: 'upload' })
    }
  }

  if (isLoading) {
    return (
      <div className="min-h-screen p-8">
        <div className="max-w-7xl mx-auto space-y-8 animate-pulse">
          <div className="h-16 bg-white/5 rounded-xl border border-white/10 w-1/4"></div>
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            {[1, 2, 3, 4].map(i => <div key={i} className="h-32 bg-white/5 border border-white/10 rounded-xl"></div>)}
          </div>
          <div className="h-48 bg-white/5 border border-white/10 rounded-xl"></div>
          <div className="h-96 bg-white/5 border border-white/10 rounded-xl"></div>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen relative">
      {/* Background Spline Animation */}
      <div className="fixed inset-0 z-0 opacity-80">
        <GlobalAnimatedBackground />
      </div>

      <header className="sticky top-0 z-50 bg-black/50 backdrop-blur-xl border-b border-white/5">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-4">
              <div className="w-10 h-10 bg-gradient-to-br from-primary-500 to-primary-800 rounded-lg flex items-center justify-center shadow-[0_0_15px_rgba(59,130,246,0.3)] border border-primary-400/20 relative overflow-hidden">
                <div className="absolute inset-0 bg-white/10 animate-pulse-slow"></div>
                <svg className="w-5 h-5 text-white relative z-10" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                </svg>
              </div>
              <div>
                <h1 className="text-xl font-display font-semibold tracking-wide text-white">NEXUS<span className="text-primary-500">_</span>GATEWAY</h1>
                <p className="text-xs font-medium text-zinc-500 tracking-wider">OP: {user?.email}</p>
              </div>
            </div>
            <button
              onClick={handleSignOut}
              className="px-4 py-2 text-xs font-semibold uppercase tracking-wider text-zinc-400 hover:text-white transition-colors border border-transparent hover:border-white/10 rounded-lg"
            >
              Terminate Session
            </button>
          </div>
        </div>
      </header>

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 relative z-10">
        {stats && (
          <>
            <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-10">
              <div className="glass-panel p-6 rounded-2xl relative overflow-hidden group animate-cinematic-entrance" style={{ animationDelay: '0.1s' }}>
                <div className="absolute top-0 right-0 p-4 opacity-10 group-hover:opacity-20 transition-opacity">
                  <svg className="w-12 h-12 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path></svg>
                </div>
                <p className="text-xs font-semibold text-zinc-400 uppercase tracking-wider mb-2 relative z-10">Total Ingested</p>
                <p className="text-4xl font-display font-light text-white tracking-tight relative z-10">{stats.total_scans}</p>
              </div>

              <div className="glass-panel p-6 rounded-2xl relative overflow-hidden group animate-cinematic-entrance" style={{ animationDelay: '0.2s' }}>
                <div className="absolute top-0 right-0 p-4 opacity-10 group-hover:opacity-20 transition-opacity text-amber-500">
                  <svg className="w-12 h-12" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                </div>
                <p className="text-xs font-semibold text-zinc-400 uppercase tracking-wider mb-2 relative z-10">Queued Analysis</p>
                <p className="text-4xl font-display font-light text-amber-500 drop-shadow-[0_0_8px_rgba(245,158,11,0.5)] tracking-tight relative z-10">{stats.pending_scans}</p>
              </div>

              <div className="glass-panel p-6 rounded-2xl relative overflow-hidden group animate-cinematic-entrance" style={{ animationDelay: '0.3s' }}>
                <div className="absolute top-0 right-0 p-4 opacity-10 group-hover:opacity-20 transition-opacity text-emerald-500">
                  <svg className="w-12 h-12" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                </div>
                <p className="text-xs font-semibold text-zinc-400 uppercase tracking-wider mb-2 relative z-10">Verified Safe</p>
                <p className="text-4xl font-display font-light text-emerald-500 drop-shadow-[0_0_8px_rgba(16,185,129,0.5)] tracking-tight relative z-10">{stats.completed_scans}</p>
              </div>

              <div className="glass-panel p-6 rounded-2xl relative overflow-hidden group animate-cinematic-entrance" style={{ animationDelay: '0.4s' }}>
                <div className="absolute inset-0 bg-gradient-to-br from-rose-500/5 to-transparent pointer-events-none"></div>
                <p className="text-xs font-semibold text-zinc-400 uppercase tracking-wider mb-2 relative z-10">Global Threat Index</p>
                <div className="flex items-baseline space-x-1 relative z-10">
                  <p className="text-4xl font-display font-light text-white tracking-tight">{Number(stats.avg_threat_score).toFixed(1)}</p>
                  <span className="text-lg text-zinc-500">%</span>
                </div>
              </div>
            </div>

            <div className="mb-10 animate-cinematic-entrance" style={{ animationDelay: '0.5s' }}>
              <div className="glass-panel p-6 rounded-2xl border-white/5">
                <ThreatChart stats={stats} />
              </div>
            </div>
          </>
        )}

        <div className="grid grid-cols-1 xl:grid-cols-3 gap-8 mb-10">
          <div className="xl:col-span-1 animate-cinematic-entrance" style={{ animationDelay: '0.6s' }}>
            <UploadZone onUpload={handleUpload} />
          </div>

          <div className="xl:col-span-2 glass-panel rounded-2xl overflow-hidden animate-cinematic-entrance flex flex-col" style={{ animationDelay: '0.7s' }}>
            <div className="px-6 py-5 border-b border-white/5 bg-black/20 flex justify-between items-center">
              <div>
                <h2 className="text-sm font-semibold tracking-widest uppercase text-white font-display">Analysis Log</h2>
                <p className="text-xs text-primary-500/80 mt-1 uppercase tracking-wider font-medium">RLS Protection Active</p>
              </div>
              <div className="h-2 w-2 rounded-full bg-primary-500 animate-pulse shadow-[0_0_8px_rgba(59,130,246,0.8)]"></div>
            </div>

            {scans.length === 0 ? (
              <div className="px-6 py-16 text-center flex-1 flex flex-col items-center justify-center">
                <div className="w-16 h-16 rounded-full bg-white/5 flex items-center justify-center mb-4 border border-white/10">
                  <svg className="h-8 w-8 text-zinc-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                  </svg>
                </div>
                <h3 className="text-sm font-medium tracking-wide text-zinc-300">Awaiting Signal</h3>
                <p className="mt-1 text-xs text-zinc-500 uppercase tracking-widest">Provide media payload for evaluation</p>
              </div>
            ) : (
              <div className="overflow-x-auto flex-1">
                <table className="w-full text-left">
                  <thead>
                    <tr className="text-xs uppercase tracking-wider text-zinc-500 bg-white/[0.02] border-b border-white/5">
                      <th className="px-6 py-4 font-semibold">Payload ID</th>
                      <th className="px-6 py-4 font-semibold">Status</th>
                      <th className="px-6 py-4 font-semibold text-center">Threat Level</th>
                      <th className="px-6 py-4 font-semibold text-center">Gemini</th>
                      <th className="px-6 py-4 font-semibold">Type</th>
                      <th className="px-6 py-4 font-semibold text-right">Timestamp</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-white/5">
                    {scans.map((scan) => {
                      const threatLevel = getThreatLevel(scan.threat_score)
                      const geminiVerdict = scan.result_details?.gemini_verdict
                      return (
                        <tr
                          key={scan.id}
                          onClick={() => router.push(`/dashboard/${scan.id}`)}
                          className="hover:bg-white/[0.02] transition-colors group cursor-pointer"
                        >
                          <td className="px-6 py-4">
                            <div className="flex items-center space-x-4">
                              <div className="flex-shrink-0 text-zinc-500 group-hover:text-white transition-colors">
                                {scan.media_type === 'image' && <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" /></svg>}
                                {scan.media_type === 'video' && <svg className="w-5 h-5 text-zinc-500 group-hover:text-white transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M15 10l4.553-2.276A1 1 0 0121 8.618v6.764a1 1 0 01-1.447.894L15 14M5 18h8a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2z" /></svg>}
                                {scan.media_type === 'audio' && <svg className="w-5 h-5 text-zinc-500 group-hover:text-white transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M9 19V6l12-3v13M9 19c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zm12-3c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zM9 10l12-3" /></svg>}
                              </div>
                              <span className="text-white font-medium text-sm truncate max-w-[180px]">{scan.file_name}</span>
                            </div>
                          </td>
                          <td className="px-6 py-4">
                            <span className={`inline-flex items-center px-2.5 py-1 rounded-md text-[10px] font-bold uppercase tracking-widest border ${getStatusBadge(scan.status)}`}>
                              {scan.status}
                            </span>
                          </td>
                          <td className="px-6 py-4 text-center">
                            <div className="flex flex-col items-center">
                              <span className={`font-display font-medium text-lg ${threatLevel.color}`}>
                                {scan.threat_score != null ? `${Number(scan.threat_score).toFixed(1)}` : 'N/A'}
                              </span>
                              {scan.threat_score != null && (
                                <span className={`text-[10px] font-semibold uppercase tracking-wider mt-0.5 ${threatLevel.color} opacity-80`}>
                                  {threatLevel.label}
                                </span>
                              )}
                            </div>
                          </td>
                          <td className="px-6 py-4 text-center">
                            {geminiVerdict
                              ? getGeminiVerdictBadge(geminiVerdict)
                              : <span className="text-zinc-600 text-[10px] uppercase tracking-widest">—</span>
                            }
                          </td>
                          <td className="px-6 py-4 text-zinc-400 text-xs font-semibold uppercase tracking-wider">
                            {scan.media_type || 'Unknown'}
                          </td>
                          <td className="px-6 py-4 text-zinc-500 text-xs tracking-wider text-right font-medium">
                            {scan.created_at ? formatDate(scan.created_at) : 'N/A'}
                          </td>
                        </tr>
                      )
                    })}
                  </tbody>
                </table>
              </div>
            )}

            {totalPages > 1 && (
              <div className="px-6 py-4 bg-white/[0.02] border-t border-white/5 flex items-center justify-between">
                <button
                  onClick={() => setPage((p) => Math.max(1, p - 1))}
                  disabled={page === 1}
                  className="px-4 py-2 text-xs font-semibold uppercase tracking-wider text-zinc-400 border border-white/10 rounded hover:text-white hover:border-white/30 disabled:opacity-30 disabled:cursor-not-allowed transition-all"
                >
                  Prev
                </button>
                <div className="flex space-x-1">
                  {[...Array(totalPages)].map((_, i) => (
                    <div key={i} className={`w-2 h-2 rounded-full ${page === i + 1 ? 'bg-primary-500 shadow-[0_0_8px_rgba(59,130,246,0.8)]' : 'bg-white/10'}`}></div>
                  ))}
                </div>
                <button
                  onClick={() => setPage((p) => Math.min(totalPages, p + 1))}
                  disabled={page === totalPages}
                  className="px-4 py-2 text-xs font-semibold uppercase tracking-wider text-zinc-400 border border-white/10 rounded hover:text-white hover:border-white/30 disabled:opacity-30 disabled:cursor-not-allowed transition-all"
                >
                  Next
                </button>
              </div>
            )}
          </div>
        </div>
      </main>

      {/* Feature Showcase in Dashboard */}
      <div className="relative z-10 bg-transparent mt-20 pb-20">
        <ParallaxScrollFeatureSection />
      </div>
    </div>
  )
}
