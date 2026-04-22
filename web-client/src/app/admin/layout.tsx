'use client'

import { useEffect, useState } from 'react'
import { useRouter, usePathname } from 'next/navigation'
import Link from 'next/link'
import { getUserProfile, type UserProfile } from '@/lib/api'
import { supabase, signOut } from '@/lib/supabase'
import toast from 'react-hot-toast'

export default function AdminLayout({
  children,
}: {
  children: React.ReactNode
}) {
  const router = useRouter()
  const pathname = usePathname()
  const [isLoading, setIsLoading] = useState(true)
  const [profile, setProfile] = useState<UserProfile | null>(null)

  useEffect(() => {
    const checkAdminAccess = async () => {
      try {
        const { data: { session } } = await supabase.auth.getSession()
        
        if (!session) {
          router.replace('/login')
          return
        }

        const userProfile = await getUserProfile()
        if (userProfile.role !== 'admin') {
          toast.error('Access denied. Administrator privileges required.')
          router.replace('/dashboard')
          return
        }

        setProfile(userProfile)
      } catch (error) {
        console.error('Error verifying admin access:', error)
        router.replace('/dashboard')
      } finally {
        setIsLoading(false)
      }
    }

    checkAdminAccess()
  }, [router])

  const handleSignOut = async () => {
    try {
      await signOut()
      router.push('/login')
    } catch (error) {
      toast.error('Failed to sign out')
    }
  }

  if (isLoading) {
    return (
      <div className="min-h-screen bg-black flex items-center justify-center">
        <div className="w-16 h-16 relative flex items-center justify-center">
           <div className="absolute inset-0 border-2 border-primary-500 border-t-transparent rounded-full animate-spin"></div>
        </div>
      </div>
    )
  }

  const navItems = [
    { name: 'Overview', href: '/admin' },
    { name: 'Users', href: '/admin/users' },
  ]

  return (
    <div className="min-h-screen bg-black flex selection:bg-primary-500/30 font-body">
      {/* Sleek Sidebar */}
      <div className="w-64 bg-black border-r border-white/5 flex flex-col relative z-20">
        <div className="h-20 flex items-center px-6 border-b border-white/5 space-x-3">
          <div className="w-8 h-8 bg-gradient-to-br from-primary-500 to-primary-800 rounded-lg flex items-center justify-center shadow-[0_0_15px_rgba(59,130,246,0.3)] border border-primary-400/20 relative overflow-hidden">
            <div className="absolute inset-0 bg-white/10 animate-pulse-slow"></div>
            <svg className="w-4 h-4 text-white relative z-10" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
            </svg>
          </div>
          <span className="text-white font-display font-medium tracking-wide">NEXUS<span className="text-primary-500">_</span>ADMIN</span>
        </div>
        
        <nav className="flex-1 px-4 py-8 space-y-2">
          {navItems.map((item) => {
            const isActive = pathname === item.href
            return (
              <Link
                key={item.name}
                href={item.href}
                className={`flex items-center px-4 py-3 rounded-lg transition-all duration-300 text-sm tracking-wide ${
                  isActive 
                    ? 'bg-primary-500/10 text-primary-400 font-semibold border border-primary-500/20 shadow-[0_0_10px_rgba(59,130,246,0.05)]' 
                    : 'text-zinc-500 hover:bg-white/5 hover:text-white border border-transparent'
                }`}
              >
                {item.name}
              </Link>
            )
          })}
          
          <div className="pt-8 mt-8 border-t border-white/5">
            <Link
              href="/dashboard"
              className="group flex items-center px-4 py-3 rounded-lg text-sm tracking-wide text-zinc-500 hover:bg-white/5 hover:text-white transition-all duration-300 border border-transparent"
            >
              <svg className="w-4 h-4 mr-3 text-zinc-600 group-hover:-translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path></svg>
              Return to Gateway
            </Link>
          </div>
        </nav>
        
        <div className="p-4 border-t border-white/5 bg-black">
          <div className="flex items-center space-x-3 mb-4 px-2">
            <div className="w-8 h-8 rounded-full bg-white/10 border border-white/10 flex items-center justify-center text-white text-xs font-display font-bold">
              {profile?.email.charAt(0).toUpperCase()}
            </div>
            <div className="flex-1 min-w-0">
              <p className="text-xs font-semibold uppercase tracking-wider text-white truncate">
                {profile?.full_name || 'Admin Dir.'}
              </p>
              <p className="text-[10px] text-primary-500/80 font-medium tracking-widest truncate mt-0.5">
                Clearance: Level 5
              </p>
            </div>
          </div>
          <button
            onClick={handleSignOut}
            className="w-full px-4 py-2.5 text-xs font-semibold uppercase tracking-wider text-center text-zinc-400 hover:text-white bg-white/[0.02] hover:bg-rose-500/10 rounded-lg transition-colors border border-transparent hover:border-rose-500/20"
          >
            End Session
          </button>
        </div>
      </div>

      {/* Main Content Area */}
      <div className="flex-1 flex flex-col min-w-0 relative">
        <div className="absolute top-0 right-0 w-[500px] h-[500px] bg-primary-900/10 blur-[150px] rounded-full pointer-events-none"></div>
        <main className="flex-1 overflow-y-auto relative z-10">
          <div className="max-w-6xl mx-auto px-8 lg:px-12 py-10">
            {children}
          </div>
        </main>
      </div>
    </div>
  )
}
