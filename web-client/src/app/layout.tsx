import type { Metadata } from 'next'
import { Syne, Outfit } from 'next/font/google'
import './globals.css'
import { Toaster } from 'react-hot-toast'
import { ErrorBoundary } from '@/components/error-boundary'

const syne = Syne({
  subsets: ['latin'],
  variable: '--font-syne',
  display: 'swap',
})

const outfit = Outfit({
  subsets: ['latin'],
  variable: '--font-outfit',
  display: 'swap',
})

export const metadata: Metadata = {
  title: 'Deepfake Authentication Gateway',
  description: 'Enterprise-Grade Deepfake Detection with Zero-Trust Security',
  keywords: ['deepfake', 'detection', 'authentication', 'security', 'AI'],
  authors: [{ name: 'Deepfake Gateway Team' }],
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en" className={`dark ${syne.variable} ${outfit.variable}`}>
      <body className={`${outfit.className} bg-black text-white min-h-screen selection:bg-primary-500/30 selection:text-white antialiased`}>
        <ErrorBoundary>
          {children}
        </ErrorBoundary>
        <Toaster
          position="top-right"
          toastOptions={{
            duration: 4000,
            style: {
              background: '#000000',
              color: '#fff',
              border: '1px solid #18181b',
            },
            success: {
              iconTheme: {
                primary: '#10b981', // emerald
                secondary: '#fff',
              },
            },
            error: {
              iconTheme: {
                primary: '#e11d48', // rose/crimson
                secondary: '#fff',
              },
            },
          }}
        />
      </body>
    </html>
  )
}
