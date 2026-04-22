'use client'

import { useCallback, useState } from 'react'
import { useDropzone } from 'react-dropzone'

interface UploadZoneProps {
  onUpload: (file: File, onProgress?: (p: number) => void) => Promise<void>
}

export default function UploadZone({ onUpload }: UploadZoneProps) {
  const [isUploading, setIsUploading] = useState(false)
  const [progress, setProgress] = useState(0)

  const onDrop = useCallback(
    async (acceptedFiles: File[]) => {
      if (acceptedFiles.length > 0) {
        setIsUploading(true)
        setProgress(0)
        try {
          await onUpload(acceptedFiles[0], setProgress)
        } finally {
          setIsUploading(false)
          setProgress(0)
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
        glass-panel relative border-2 border-dashed rounded-2xl p-8 text-center cursor-pointer transition-all duration-300 overflow-hidden group
        ${isDragActive 
          ? 'border-primary-500 bg-primary-500/10 shadow-[0_0_30px_rgba(59,130,246,0.1)]' 
          : 'border-white/10 hover:border-primary-500/50 hover:bg-white/[0.02] hover:shadow-[0_0_20px_rgba(255,255,255,0.02)]'
        }
        ${isUploading ? 'opacity-50 cursor-not-allowed border-primary-500/50' : ''}
      `}
    >
      {/* Subtle scanner line effect when hovering/dragging */}
      <div className={`absolute left-0 right-0 h-[1px] bg-primary-500/50 shadow-[0_0_10px_rgba(59,130,246,0.8)] transition-all duration-1000 -top-[10px]
        ${isDragActive ? 'top-[100%] transition-[top] ease-linear repeat-infinite' : 'group-hover:top-[100%]'}`}></div>

      <input {...getInputProps()} />
      
      <div className="flex flex-col items-center justify-center relative z-10">
        {isUploading ? (
          <div className="w-full max-w-xs text-center py-6">
            <div className="w-16 h-16 mx-auto mb-4 relative flex items-center justify-center">
              <div className="absolute inset-0 border-2 border-primary-500 border-t-transparent rounded-full animate-spin"></div>
              <span className="text-primary-500 font-display font-medium text-xs">{progress}%</span>
            </div>
            <p className="text-sm font-semibold tracking-widest uppercase text-white mb-3">Neural Processing</p>
            <div className="w-full bg-black/50 border border-white/10 rounded-full h-1 overflow-hidden">
              <div 
                className="bg-gradient-to-r from-primary-500 to-primary-300 h-full rounded-full transition-all duration-300 ease-out" 
                style={{ width: `${progress}%` }}
              ></div>
            </div>
          </div>
        ) : isDragActive ? (
          <div className="py-8 animate-fade-up">
            <svg className="w-16 h-16 text-primary-500 mb-6 mx-auto drop-shadow-[0_0_15px_rgba(59,130,246,0.8)] animate-pulse" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12" />
            </svg>
            <p className="text-xl font-display font-medium text-primary-400 tracking-wide text-shadow">Release payload to initialize</p>
          </div>
        ) : (
          <div className="py-4">
            <div className="w-16 h-16 mx-auto bg-black/50 border border-white/5 rounded-2xl flex items-center justify-center mb-5 group-hover:scale-110 group-hover:border-primary-500/30 transition-all duration-500">
              <svg className="w-8 h-8 text-zinc-500 group-hover:text-primary-400 transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1} d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
              </svg>
            </div>
            <p className="text-lg font-display font-medium text-white mb-2">
              Ingest Media Payload
            </p>
            <p className="text-xs text-zinc-500 mb-6 font-medium uppercase tracking-wider">
              Drag & Drop or Click to Browse
            </p>
            <div className="flex flex-wrap justify-center gap-2">
              <span className="px-2 py-1 bg-white/5 text-zinc-400 text-[10px] font-bold tracking-widest uppercase rounded border border-white/5">
                Images
              </span>
              <span className="px-2 py-1 bg-white/5 text-zinc-400 text-[10px] font-bold tracking-widest uppercase rounded border border-white/5">
                Video
              </span>
              <span className="px-2 py-1 bg-white/5 text-zinc-400 text-[10px] font-bold tracking-widest uppercase rounded border border-white/5">
                Audio
              </span>
            </div>
            <p className="text-[10px] text-zinc-600 mt-4 uppercase tracking-widest font-semibold font-display">Max Size: 5GB / File</p>
          </div>
        )}
      </div>
    </div>
  )
}
