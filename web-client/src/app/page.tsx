'use client'

import React from 'react'
import MagneticButton from '@/components/ui/magnetic-button'
import Link from 'next/link'
import { ArrowRight, Shield } from 'lucide-react'
import { GlobalAnimatedBackground } from '@/components/ui/spline-background'
import { ParallaxScrollFeatureSection } from '@/components/ui/parallax-scroll-feature-section'
import AnimatedLoginPage from '@/components/ui/animated-characters-login-page'

export default function Home() {
  return (
    <main className="relative min-h-screen font-body antialiased bg-black text-white selection:bg-white/20">
      {/* ── Background Layer ── */}
      <div className="fixed inset-0 z-0 bg-black" />

      {/* ── Navbar ── */}
      <nav className="fixed top-0 left-0 right-0 z-50 flex items-center justify-between px-6 py-4 backdrop-blur-md border-b border-white/5 bg-black/30">
        <Link href="/" className="flex items-center gap-3 group">
          <div className="size-8 rounded-xl bg-white flex items-center justify-center shadow-lg shadow-white/10">
            <Shield className="size-4 text-black" />
          </div>
          <span className="font-display font-bold text-base tracking-widest text-white uppercase">
            Nexus<span className="text-zinc-500">_</span>Gateway
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
      <div className="relative w-full min-h-screen flex items-center justify-center px-6 lg:px-20 pt-20 z-10 max-w-7xl mx-auto">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center w-full">
          {/* Left Side: Content */}
          <div className="flex flex-col items-start text-left">
            <div className="mb-6 inline-flex items-center gap-2 px-4 py-1.5 rounded-full border border-white/10 bg-white/5 text-[11px] font-bold uppercase tracking-widest text-white">
              <span className="relative flex h-2 w-2">
                <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-white/40 opacity-75" />
                <span className="relative inline-flex rounded-full h-2 w-2 bg-white" />
              </span>
              Neural Gateway Online
            </div>

            <h1 className="font-display text-5xl md:text-7xl lg:text-8xl font-bold tracking-tight text-white mb-6 leading-[0.9]">
              Detect The <br />
              <span className="text-white">
                Undetectable
              </span>
            </h1>

            <p className="text-base md:text-lg text-zinc-400 max-w-xl mb-10 font-medium leading-relaxed">
              Military-grade deepfake authentication gateway powered by next-generation behavioral acoustics and biometric topography.
            </p>

            <div className="flex flex-col sm:flex-row items-center gap-4 w-full sm:w-auto">
              <Link href="/register" className="w-full sm:w-auto inline-block">
                 <MagneticButton className="w-full inline-flex items-center justify-center gap-2 bg-white text-black px-8 py-4 rounded-full font-bold text-sm uppercase tracking-widest hover:bg-zinc-200 transition-all hover:scale-105 active:scale-95 group">
                   Authenticate Now
                   <ArrowRight className="size-4 group-hover:translate-x-1 transition-transform" />
                 </MagneticButton>
               </Link>
              <Link
                href="/login"
                className="w-full sm:w-auto inline-flex items-center justify-center gap-2 bg-white/5 backdrop-blur-xl text-white border border-white/10 px-8 py-4 rounded-full font-bold text-sm uppercase tracking-widest hover:bg-white/10 transition-all active:scale-95"
              >
                Sign In
              </Link>
            </div>
          </div>

          {/* Right Side: Feature Card */}
          <div className="flex items-center justify-center lg:justify-end">
            <div className="relative group perspective-1000">
              <div className="relative overflow-hidden rounded-2xl border border-white/10 bg-white/[0.03] backdrop-blur-xl p-4 transition-all duration-300 ease-out hover:scale-[1.02] hover:border-white/20 hover:shadow-[0_0_40px_rgba(255,255,255,0.05)] w-full max-w-[500px]">
                {/* AI POWERED Label */}
                <div className="absolute top-6 left-6 z-20 flex items-center gap-2 px-3 py-1 rounded-lg border border-white/10 bg-black/40 backdrop-blur-md">
                   <div className="size-1.5 rounded-full bg-white animate-pulse" />
                   <span className="text-[10px] font-bold uppercase tracking-[0.2em] text-white/70">AI POWERED</span>
                </div>
                
                {/* Image Content */}
                <div className="relative aspect-[4/3] rounded-xl overflow-hidden grayscale contrast-125">
                   <img 
                     src="/images/hero-feature.png" 
                     alt="AI Face Authentication" 
                     className="w-full h-full object-cover opacity-80 group-hover:opacity-100 transition-opacity duration-300"
                   />
                </div>
              </div>
            </div>
          </div>
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

