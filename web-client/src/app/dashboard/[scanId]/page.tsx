'use client'

import { useEffect, useState } from 'react'
import { useRouter, useParams } from 'next/navigation'
import { getScanById, type ScanResponse } from '@/lib/api'
import { GlobalAnimatedBackground } from '@/components/ui/spline-background'
import toast from 'react-hot-toast'

function formatDate(dateString: string): string {
  return new Date(dateString).toLocaleDateString('en-US', {
    year: 'numeric', month: 'long', day: 'numeric',
    hour: '2-digit', minute: '2-digit', second: '2-digit',
  })
}

function formatBytes(bytes: number | null | undefined): string {
  if (!bytes) return 'N/A'
  if (bytes < 1024) return `${bytes} B`
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`
  return `${(bytes / (1024 * 1024)).toFixed(2)} MB`
}

export default function ScanDetailPage() {
  const router = useRouter()
  const params = useParams()
  const scanId = params?.scanId as string

  const [scan, setScan] = useState<ScanResponse | null>(null)
  const [isLoading, setIsLoading] = useState(true)

  useEffect(() => {
    if (!scanId) return
    getScanById(scanId)
      .then(setScan)
      .catch(() => {
        toast.error('Scan not found')
        router.push('/dashboard')
      })
      .finally(() => setIsLoading(false))
  }, [scanId, router])

  if (isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="flex flex-col items-center gap-4">
          <div className="w-12 h-12 border-2 border-primary-500 border-t-transparent rounded-full animate-spin" />
          <p className="text-zinc-500 text-sm uppercase tracking-widest font-medium">Decrypting Record…</p>
        </div>
      </div>
    )
  }

  if (!scan) return null

  const rd = scan.result_details
  const threatScore = scan.threat_score != null ? Number(scan.threat_score) : null
  const geminiVerdict = rd?.gemini_verdict
  const geminiReasoning = rd?.gemini_reasoning
  const hfScorePct = rd?.hf_score_pct ?? threatScore
  const tierUsed = rd?.tier_used
  const modelUsed = rd?.model_used
  const isDeepfake = rd?.is_deepfake
  const confidenceLevel = rd?.confidence_level
  const processingMs = rd?.processing_time_ms

  const isDeepfakeFinal = geminiVerdict === 'DEEPFAKE'
  const threatColor = threatScore != null
    ? threatScore >= 70 ? 'text-rose-400' : threatScore >= 30 ? 'text-amber-400' : 'text-emerald-400'
    : 'text-zinc-500'

  const circumference = 2 * Math.PI * 54
  const dashOffset = threatScore != null ? circumference * (1 - threatScore / 100) : circumference

  return (
    <div className="min-h-screen relative">
      <div className="fixed inset-0 z-0 opacity-60">
        <GlobalAnimatedBackground />
      </div>

      {/* Header */}
      <header className="sticky top-0 z-50 bg-black/50 backdrop-blur-xl border-b border-white/5">
        <div className="max-w-5xl mx-auto px-4 sm:px-6 py-4 flex items-center gap-4">
          <button
            id="back-to-dashboard"
            onClick={() => router.push('/dashboard')}
            className="flex items-center gap-2 text-zinc-400 hover:text-white transition-colors text-sm font-medium group"
          >
            <svg className="w-4 h-4 group-hover:-translate-x-0.5 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
            </svg>
            Dashboard
          </button>
          <span className="text-zinc-700">/</span>
          <span className="text-zinc-300 text-sm font-medium truncate max-w-xs">{scan.file_name}</span>
        </div>
      </header>

      <main className="max-w-5xl mx-auto px-4 sm:px-6 py-10 relative z-10 space-y-6">

        {/* Top identity card */}
        <div className="glass-panel rounded-2xl p-6 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
          <div>
            <p className="text-xs text-zinc-500 uppercase tracking-widest font-semibold mb-1">Scan Record</p>
            <h1 className="text-2xl font-display font-semibold text-white tracking-tight">{scan.file_name}</h1>
            <p className="text-xs text-zinc-600 mt-1 font-mono">{scan.id}</p>
          </div>
          <div className="flex items-center gap-3">
            <span className={`inline-flex items-center px-3 py-1.5 rounded-lg text-[11px] font-bold uppercase tracking-widest border ${
              scan.status === 'completed' ? 'bg-emerald-500/10 text-emerald-400 border-emerald-500/20' :
              scan.status === 'failed'    ? 'bg-rose-500/10 text-rose-400 border-rose-500/20' :
              scan.status === 'processing'? 'bg-primary-500/10 text-primary-400 border-primary-500/20' :
              'bg-yellow-500/10 text-yellow-400 border-yellow-500/20'
            }`}>
              {scan.status}
            </span>
            <span className="text-xs text-zinc-500 uppercase tracking-wider">{scan.media_type}</span>
          </div>
        </div>

        {/* Score + Gemini side by side */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">

          {/* HF Threat Score Gauge */}
          <div className="glass-panel rounded-2xl p-6 flex flex-col items-center justify-center gap-4">
            <p className="text-xs text-zinc-500 uppercase tracking-widest font-semibold self-start">Tier-1 · HuggingFace Score</p>
            <div className="relative w-36 h-36">
              <svg className="w-full h-full -rotate-90" viewBox="0 0 120 120">
                <circle cx="60" cy="60" r="54" fill="none" stroke="rgba(255,255,255,0.05)" strokeWidth="10" />
                <circle
                  cx="60" cy="60" r="54" fill="none"
                  stroke={threatScore != null ? (threatScore >= 70 ? '#f43f5e' : threatScore >= 30 ? '#f59e0b' : '#10b981') : '#374151'}
                  strokeWidth="10"
                  strokeLinecap="round"
                  strokeDasharray={circumference}
                  strokeDashoffset={dashOffset}
                  style={{ transition: 'stroke-dashoffset 1s ease-out' }}
                />
              </svg>
              <div className="absolute inset-0 flex flex-col items-center justify-center">
                <span className={`text-3xl font-display font-bold ${threatColor}`}>
                  {threatScore != null ? threatScore.toFixed(1) : 'N/A'}
                </span>
                <span className="text-zinc-600 text-xs font-medium">%</span>
              </div>
            </div>
            <div className="grid grid-cols-2 gap-x-8 gap-y-1 text-center w-full text-xs">
              <div>
                <p className="text-zinc-600 uppercase tracking-wider">Model</p>
                <p className="text-zinc-300 font-medium truncate">{modelUsed ?? '—'}</p>
              </div>
              <div>
                <p className="text-zinc-600 uppercase tracking-wider">Confidence</p>
                <p className="text-zinc-300 font-medium capitalize">{confidenceLevel ?? '—'}</p>
              </div>
              <div>
                <p className="text-zinc-600 uppercase tracking-wider">Tier Used</p>
                <p className="text-zinc-300 font-medium">{tierUsed ?? '—'}</p>
              </div>
              <div>
                <p className="text-zinc-600 uppercase tracking-wider">Time</p>
                <p className="text-zinc-300 font-medium">{processingMs != null ? `${processingMs.toFixed(0)}ms` : '—'}</p>
              </div>
            </div>
          </div>

          {/* Gemini Verdict */}
          <div className={`glass-panel rounded-2xl p-6 flex flex-col gap-4 border ${
            geminiVerdict === 'DEEPFAKE'
              ? 'border-rose-500/20 shadow-[0_0_30px_rgba(225,29,72,0.08)]'
              : geminiVerdict === 'AUTHENTIC'
              ? 'border-emerald-500/20 shadow-[0_0_30px_rgba(16,185,129,0.08)]'
              : 'border-white/5'
          }`}>
            <p className="text-xs text-zinc-500 uppercase tracking-widest font-semibold">Tier-2 · Gemini Forensics</p>

            {geminiVerdict ? (
              <>
                <div className="flex items-center gap-3">
                  <div className={`w-12 h-12 rounded-xl flex items-center justify-center ${
                    isDeepfakeFinal ? 'bg-rose-500/10 border border-rose-500/20' : 'bg-emerald-500/10 border border-emerald-500/20'
                  }`}>
                    {isDeepfakeFinal ? (
                      <svg className="w-6 h-6 text-rose-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 9v2m0 4h.01M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z" />
                      </svg>
                    ) : (
                      <svg className="w-6 h-6 text-emerald-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                      </svg>
                    )}
                  </div>
                  <div>
                    <p className={`text-2xl font-display font-bold tracking-tight ${
                      isDeepfakeFinal ? 'text-rose-400' : 'text-emerald-400'
                    }`}>{geminiVerdict}</p>
                    <p className="text-xs text-zinc-600 uppercase tracking-wider">Gemini Verdict</p>
                  </div>
                </div>

                <div className="bg-white/[0.03] border border-white/5 rounded-xl p-4">
                  <p className="text-xs text-zinc-500 uppercase tracking-wider font-semibold mb-2">Forensic Reasoning</p>
                  <p className="text-sm text-zinc-300 leading-relaxed">{geminiReasoning ?? 'No reasoning available.'}</p>
                </div>
              </>
            ) : (
              <div className="flex-1 flex flex-col items-center justify-center gap-3 py-8 text-center">
                <div className="w-12 h-12 rounded-xl bg-white/5 border border-white/10 flex items-center justify-center">
                  <svg className="w-6 h-6 text-zinc-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M9 12h6m-6 4h6M5 5h14a2 2 0 012 2v10a2 2 0 01-2 2H5a2 2 0 01-2-2V7a2 2 0 012-2z" />
                  </svg>
                </div>
                <p className="text-zinc-500 text-sm">Tier-2 Not Triggered</p>
                <p className="text-zinc-700 text-xs max-w-[200px]">HF score was below the 20% threshold — Gemini analysis was not needed.</p>
              </div>
            )}
          </div>
        </div>

        {/* Metadata strip */}
        <div className="glass-panel rounded-2xl p-6">
          <p className="text-xs text-zinc-500 uppercase tracking-widest font-semibold mb-4">File Metadata</p>
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
            {[
              { label: 'File Size', value: formatBytes(scan.file_size) },
              { label: 'Media Type', value: scan.media_type ?? '—' },
              { label: 'Created', value: scan.created_at ? formatDate(scan.created_at) : '—' },
              { label: 'Completed', value: scan.completed_at ? formatDate(scan.completed_at) : '—' },
            ].map(({ label, value }) => (
              <div key={label}>
                <p className="text-[10px] text-zinc-600 uppercase tracking-wider mb-1">{label}</p>
                <p className="text-sm text-zinc-300 font-medium truncate">{value}</p>
              </div>
            ))}
          </div>

          <div className="mt-4 pt-4 border-t border-white/5">
            <p className="text-[10px] text-zinc-600 uppercase tracking-wider mb-1">SHA-256 Hash</p>
            <p className="text-xs text-zinc-500 font-mono break-all">{scan.file_hash}</p>
          </div>
        </div>

      </main>
    </div>
  )
}
