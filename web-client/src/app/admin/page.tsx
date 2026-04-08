'use client'

import { useEffect, useState } from 'react'
import { getAdminStats, type AdminStatsResponse } from '@/lib/api'
import toast from 'react-hot-toast'

export default function AdminOverviewPage() {
  const [stats, setStats] = useState<AdminStatsResponse | null>(null)
  const [isLoading, setIsLoading] = useState(true)

  useEffect(() => {
    const fetchStats = async () => {
      try {
        const data = await getAdminStats()
        setStats(data)
      } catch (error) {
        toast.error('Failed to load admin statistics')
        console.error(error)
      } finally {
        setIsLoading(false)
      }
    }

    fetchStats()
  }, [])

  if (isLoading) {
    return (
      <div className="flex justify-center py-20">
        <div className="w-12 h-12 relative flex items-center justify-center">
           <div className="absolute inset-0 border-2 border-primary-500 border-t-transparent rounded-full animate-spin"></div>
        </div>
      </div>
    )
  }

  return (
    <div className="animate-fade-up">
      <div className="mb-10">
        <h1 className="text-3xl font-display font-medium tracking-tight text-white">System Command</h1>
        <p className="text-sm text-zinc-500 mt-2 font-medium tracking-wide uppercase">Global Network Overview • Sector Alpha</p>
      </div>
      
      {stats ? (
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div className="glass-panel p-8 rounded-2xl relative overflow-hidden group">
            <div className="absolute -right-4 -top-4 opacity-5 group-hover:opacity-10 transition-opacity">
              <svg className="w-32 h-32 text-primary-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1} d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
              </svg>
            </div>
            <div className="relative z-10">
              <div className="flex items-center text-primary-500 mb-4">
                <div className="w-8 h-8 rounded-full bg-primary-500/10 flex items-center justify-center mr-3 border border-primary-500/20">
                  <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
                  </svg>
                </div>
                <h2 className="text-xs font-semibold uppercase tracking-widest text-primary-400">Total Actors</h2>
              </div>
              <p className="text-7xl font-display font-light text-white tracking-tighter mb-2">{stats.total_users}</p>
              <div className="w-full h-px bg-white/5 my-4"></div>
              <p className="text-[10px] text-zinc-500 font-semibold uppercase tracking-widest">Identities synchronized across network</p>
            </div>
          </div>
          
          <div className="glass-panel p-8 rounded-2xl relative overflow-hidden group">
            <div className="absolute -right-4 -top-4 opacity-5 group-hover:opacity-10 transition-opacity">
              <svg className="w-32 h-32 text-emerald-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </div>
            <div className="relative z-10">
              <div className="flex items-center text-emerald-500 mb-4">
                <div className="w-8 h-8 rounded-full bg-emerald-500/10 flex items-center justify-center mr-3 border border-emerald-500/20">
                  <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                </div>
                <h2 className="text-xs font-semibold uppercase tracking-widest text-emerald-400">Live Connections</h2>
              </div>
              <p className="text-7xl font-display font-light text-emerald-500 tracking-tighter mb-2 drop-shadow-[0_0_15px_rgba(16,185,129,0.3)]">{stats.active_users}</p>
              <div className="w-full h-px bg-white/5 my-4"></div>
              <p className="text-[10px] text-zinc-500 font-semibold uppercase tracking-widest">Nodes maintaining active uplink</p>
            </div>
          </div>
          
          <div className="glass-panel p-8 rounded-2xl relative overflow-hidden group">
            <div className="absolute -right-4 -top-4 opacity-5 group-hover:opacity-10 transition-opacity">
              <svg className="w-32 h-32 text-indigo-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
              </svg>
            </div>
            <div className="relative z-10">
              <div className="flex items-center text-indigo-500 mb-4">
                <div className="w-8 h-8 rounded-full bg-indigo-500/10 flex items-center justify-center mr-3 border border-indigo-500/20">
                  <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                  </svg>
                </div>
                <h2 className="text-xs font-semibold uppercase tracking-widest text-indigo-400">Total Interrogations</h2>
              </div>
              <p className="text-7xl font-display font-light text-white tracking-tighter mb-2">{stats.total_scans}</p>
              <div className="w-full h-px bg-white/5 my-4"></div>
              <p className="text-[10px] text-zinc-500 font-semibold uppercase tracking-widest">Media payloads processed & vetted</p>
            </div>
          </div>
        </div>
      ) : (
        <div className="glass-panel rounded-xl p-12 text-center border-rose-500/20">
          <svg className="mx-auto h-12 w-12 text-rose-500/50 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1} d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
          <p className="text-xs font-semibold tracking-widest uppercase text-rose-500">Telemetry Disconnected</p>
          <p className="text-zinc-500 mt-2 text-sm">Failed to establish connection with stats oracle.</p>
        </div>
      )}
    </div>
  )
}
