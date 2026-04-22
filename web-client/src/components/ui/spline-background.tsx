'use client'

import React from 'react'
import { motion } from 'framer-motion'

export function GlobalAnimatedBackground() {
  return (
    <div className="absolute inset-0 pointer-events-none overflow-hidden bg-black">
      {/* Dark OLED Base */}
      <div className="absolute inset-0 bg-black z-0" />
      
      {/* Animated Aurora / Mesh Gradients */}
      <div className="absolute inset-0 z-0 opacity-40">
        <motion.div
          animate={{
            scale: [1, 1.2, 1],
            opacity: [0.2, 0.4, 0.2],
            x: [0, 100, 0],
            y: [0, -50, 0],
          }}
          transition={{
            duration: 12,
            repeat: Infinity,
            ease: "easeInOut",
          }}
          className="absolute top-[10%] left-[10%] w-[40vw] h-[40vw] bg-indigo-900/40 blur-[120px] rounded-full mix-blend-screen"
        />
        <motion.div
          animate={{
            scale: [1, 1.5, 1],
            opacity: [0.15, 0.3, 0.15],
            x: [0, -100, 0],
            y: [0, 50, 0],
          }}
          transition={{
            duration: 18,
            repeat: Infinity,
            ease: "easeInOut",
          }}
          className="absolute top-[30%] right-[10%] w-[40vw] h-[40vw] bg-purple-900/40 blur-[120px] rounded-full mix-blend-screen"
        />
        <motion.div
          animate={{
            scale: [1, 1.1, 1],
            opacity: [0.1, 0.2, 0.1],
            x: [0, 50, 0],
            y: [0, 100, 0],
          }}
          transition={{
            duration: 15,
            repeat: Infinity,
            ease: "easeInOut",
          }}
          className="absolute bottom-[20%] left-[30%] w-[45vw] h-[45vw] bg-emerald-900/10 blur-[100px] rounded-full mix-blend-screen"
        />
      </div>

      {/* Grid overlay */}
      <div className="absolute inset-0 bg-[url('/noise.png')] opacity-[0.15] mix-blend-overlay z-0" />
      <div className="absolute inset-0 bg-[linear-gradient(to_right,#80808012_1px,transparent_1px),linear-gradient(to_bottom,#80808012_1px,transparent_1px)] bg-[size:32px_32px] z-0" />

      {/* Vignette fade around the edges, no hard cuts */}
      <div className="absolute inset-0 pointer-events-none z-10 bg-[radial-gradient(circle_at_center,transparent_20%,rgba(0,0,0,0.8)_120%)]" />
    </div>
  )
}

