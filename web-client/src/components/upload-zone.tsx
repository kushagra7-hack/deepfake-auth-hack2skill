'use client'

import { useCallback, useState } from 'react'
import { useDropzone } from 'react-dropzone'

interface UploadZoneProps {
  onUpload: (file: File) => Promise<void>
}

export default function UploadZone({ onUpload }: UploadZoneProps) {
  const [isUploading, setIsUploading] = useState(false)

  const onDrop = useCallback(
    async (acceptedFiles: File[]) => {
      if (acceptedFiles.length > 0) {
        setIsUploading(true)
        try {
          await onUpload(acceptedFiles[0])
        } finally {
          setIsUploading(false)
        }
      }
    },
    [onUpload]
  )

  const { getRootProps, getInputProps, isDragActive } = useDropzone({
    onDrop,
    accept: {
      'image/*': ['.png', '.jpg', '.jpeg', '.gif', '.webp', '.bmp'],
      'video/*': ['.mp4', '.avi', '.mov', '.webm', '.mkv'],
      'audio/*': ['.wav', '.mp3', '.flac', '.ogg'],
    },
    maxFiles: 1,
    maxSize: 5 * 1024 * 1024 * 1024, // 5GB
    disabled: isUploading,
  })

  return (
    <div
      {...getRootProps()}
      className={`
        relative border-2 border-dashed rounded-xl p-8 text-center cursor-pointer transition-all
        ${isDragActive 
          ? 'border-primary-500 bg-primary-500/5' 
          : 'border-slate-600 hover:border-slate-500 hover:bg-slate-800/30'
        }
        ${isUploading ? 'opacity-50 cursor-not-allowed' : ''}
      `}
    >
      <input {...getInputProps()} />
      
      <div className="flex flex-col items-center justify-center">
        {isUploading ? (
          <>
            <svg className="animate-spin h-12 w-12 text-primary-500 mb-4" fill="none" viewBox="0 0 24 24">
              <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
              <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" />
            </svg>
            <p className="text-lg font-medium text-slate-300">Uploading...</p>
          </>
        ) : isDragActive ? (
          <>
            <svg className="w-12 h-12 text-primary-500 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
            </svg>
            <p className="text-lg font-medium text-primary-400">Drop your file here</p>
          </>
        ) : (
          <>
            <svg className="w-12 h-12 text-slate-500 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
            </svg>
            <p className="text-lg font-medium text-slate-300 mb-1">
              Drag and drop your file here, or click to browse
            </p>
            <p className="text-sm text-slate-500 mb-4">
              Supports images, videos, and audio files (max 5GB)
            </p>
            <div className="flex flex-wrap justify-center gap-2">
              <span className="px-2 py-1 bg-purple-500/10 text-purple-400 text-xs rounded-md border border-purple-500/20">
                PNG, JPG, GIF, WebP
              </span>
              <span className="px-2 py-1 bg-blue-500/10 text-blue-400 text-xs rounded-md border border-blue-500/20">
                MP4, AVI, MOV, WebM
              </span>
              <span className="px-2 py-1 bg-green-500/10 text-green-400 text-xs rounded-md border border-green-500/20">
                WAV, MP3, FLAC, OGG
              </span>
            </div>
          </>
        )}
      </div>

      <div className="absolute bottom-3 left-0 right-0 flex justify-center">
        <div className="flex items-center space-x-2 text-xs text-slate-600">
          <svg className="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
            <path fillRule="evenodd" d="M2.166 4.26A2.028 2.028 0 004 2h12a2.028 2.028 0 001.834 2.26c.246.063.42.27.42.52v.06c0 .706-.194 1.375-.537 1.946a4.01 4.01 0 00-1.18 2.874c0 1.178.509 2.24 1.32 2.97a.5.5 0 01.087.695A8.972 8.972 0 0110 18a8.972 8.972 0 01-7.944-4.67.5.5 0 01.087-.695A3.998 3.998 0 003.637 9.66c0-1.1-.437-2.1-1.18-2.874A3.01 3.01 0 011.92 4.84v-.06c0-.25.174-.457.42-.52z" clipRule="evenodd" />
          </svg>
          <span>Files are scanned for malicious content before processing</span>
        </div>
      </div>
    </div>
  )
}
