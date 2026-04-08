'use client'

import React from 'react'
import Link from 'next/link'
import { ArrowRight, Shield } from 'lucide-react'
import { GlobalAnimatedBackground } from '@/components/ui/spline-background'
import { ParallaxScrollFeatureSection } from '@/components/ui/parallax-scroll-feature-section'
import AnimatedLoginPage from '@/components/ui/animated-characters-login-page'

export default function Home() {
  return (
    <main className="relative min-h-screen font-body antialiased bg-black text-white selection:bg-indigo-500/30">
      {/* ── Global Seamless Background ── */}
      <div className="fixed inset-0 z-0 pointer-events-none">
        <GlobalAnimatedBackground />
      </div>

      {/* ── Navbar ── */}
      <nav className="fixed top-0 left-0 right-0 z-50 flex items-center justify-between px-6 py-4 backdrop-blur-md border-b border-white/5 bg-black/30">
        <Link href="/" className="flex items-center gap-3 group">
          <div className="size-8 rounded-xl bg-gradient-to-br from-indigo-500 to-purple-700 flex items-center justify-center shadow-lg shadow-indigo-500/20">
            <Shield className="size-4 text-white" />
          </div>
          <span className="font-display font-bold text-base tracking-widest text-white uppercase">
            Nexus<span className="text-indigo-400">_</span>Gateway
          </span>
        </Link>

        <div className="flex items-center gap-4">
          <Link
            href="/login"
            className="hidden sm:block text-xs font-semibold uppercase tracking-widest text-zinc-400 hover:text-white transition-colors"
          >
            Sign In
          </Link>
          <Link
            href="/register"
            className="text-xs font-bold uppercase tracking-widest bg-white text-black px-5 py-2 rounded-full hover:bg-zinc-200 transition-all hover:scale-105 active:scale-95"
          >
            Access Port
          </Link>
        </div>
      </nav>

      {/* ── Hero ── */}
      <div className="relative w-full min-h-screen flex flex-col items-center justify-center px-6 text-center pt-20 z-10">
          <div className="mb-6 inline-flex items-center gap-2 px-4 py-1.5 rounded-full border border-indigo-500/30 bg-indigo-500/10 text-[11px] font-bold uppercase tracking-widest text-indigo-400">
            <span className="relative flex h-2 w-2">
              <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-indigo-400 opacity-75" />
              <span className="relative inline-flex rounded-full h-2 w-2 bg-indigo-500" />
            </span>
            Neural Gateway Online
          </div>

          <h1 className="font-display text-5xl md:text-7xl lg:text-8xl font-bold tracking-tight text-white mb-6 leading-[0.9]">
            Detect The <br />
            <span className="text-transparent bg-clip-text bg-gradient-to-r from-indigo-400 via-purple-400 to-indigo-500">
              Undetectable
            </span>
          </h1>

          <p className="text-base md:text-lg text-zinc-400 max-w-xl mx-auto mb-10 font-medium leading-relaxed">
            Military-grade deepfake authentication gateway powered by next-generation behavioral acoustics and biometric topography.
          </p>

          <div className="flex flex-col sm:flex-row items-center gap-4">
            <Link
              href="/register"
              className="w-full sm:w-auto inline-flex items-center justify-center gap-2 bg-white text-black px-8 py-4 rounded-full font-bold text-sm uppercase tracking-widest hover:bg-zinc-200 transition-all hover:scale-105 active:scale-95 group shadow-[0_0_30px_rgba(255,255,255,0.15)]"
            >
              Authenticate Now
              <ArrowRight className="size-4 group-hover:translate-x-1 transition-transform" />
            </Link>
            <Link
              href="/login"
              className="w-full sm:w-auto inline-flex items-center justify-center gap-2 bg-white/5 backdrop-blur-xl text-white border border-white/10 px-8 py-4 rounded-full font-bold text-sm uppercase tracking-widest hover:bg-white/10 transition-all active:scale-95"
            >
              Sign In
            </Link>
          </div>
        </div>

      {/* ── Core Capabilities (parallax scroll) ── */}
      <div className="relative z-10">
        <ParallaxScrollFeatureSection />
      </div>

      {/* ── Login Panel Module (at the bottom) ── */}
      <div className="relative z-10">
        <AnimatedLoginPage />
      </div>

      {/* ── Footer ── */}
      <footer className="relative z-10 py-10 px-6 border-t border-white/5">
        <div className="max-w-7xl mx-auto flex flex-col md:flex-row justify-between items-center gap-6 text-zinc-600 text-xs font-bold uppercase tracking-widest">
          <div className="flex items-center gap-2">
            <Shield className="size-4" />
            <span>Nexus Gateway // v1.0.4 — Production</span>
          </div>
          <div className="flex gap-8">
            <a href="#" className="hover:text-zinc-400 transition-colors">Neural Policy</a>
            <a href="#" className="hover:text-zinc-400 transition-colors">Protocol API</a>
            <a href="#" className="hover:text-zinc-400 transition-colors">Terminal Log</a>
          </div>
        </div>
      </footer>
    </main>
  )
}

