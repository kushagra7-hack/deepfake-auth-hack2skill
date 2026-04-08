"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "./button";
import { Input } from "./input";
import { Label } from "./label";
import { Mail, ArrowRight, Shield, User, Eye, EyeOff } from "lucide-react";
import { signInWithEmail, supabase } from "@/lib/supabase";

export function LoginCinematic() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    setIsLoading(true);

    try {
      await signInWithEmail(email, password);
      router.push("/dashboard");
    } catch (err: any) {
      setError(err.message || "Failed to sign in. Please check your credentials.");
      setIsLoading(false);
    }
  };

  const handleGoogleLogin = async () => {
    try {
      setIsLoading(true);
      const { error } = await supabase.auth.signInWithOAuth({
        provider: 'google',
        options: {
          redirectTo: `${window.location.origin}/dashboard`
        }
      });
      if (error) {
        setError(error.message);
        setIsLoading(false);
      }
    } catch (err: any) {
      setError(err.message);
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-black text-neutral-200 flex flex-col lg:flex-row font-['Outfit',sans-serif]">
      {/* Left Form Section */}
      <div className="w-full lg:w-[45%] flex flex-col justify-center p-8 lg:p-16 2xl:p-24 relative z-10">
        <div className="max-w-md w-full mx-auto animate-cinematic-entrance" style={{ animationDelay: '0.1s' }}>
          <Link href="/" className="mb-10 flex items-center gap-3 w-fit hover:opacity-80 transition-opacity">
            <div className="size-10 rounded-xl bg-gradient-to-br from-indigo-500 to-primary-600 flex items-center justify-center shadow-lg shadow-primary-500/20 relative overflow-hidden">
              <div className="absolute inset-0 bg-white/10 animate-pulse-slow"></div>
              <Shield className="size-5 text-white relative z-10" />
            </div>
            <span className="font-syne font-bold text-xl tracking-wider text-white">NEXUS<span className="text-primary-500">_</span>GATEWAY</span>
          </Link>

          <div className="mb-12">
            <h1 className="font-syne text-3xl lg:text-4xl font-bold tracking-tight text-white mb-4 leading-tight">
              Access your<br/>terminal.
            </h1>
            <p className="text-neutral-400 text-lg font-light leading-relaxed">
              Authenticate to securely monitor and analyze synthetic media anomalies.
            </p>
          </div>

          <form onSubmit={handleSubmit} className="space-y-6">
            <div className="space-y-2">
              <Label htmlFor="email" className="text-xs font-semibold uppercase tracking-wider text-neutral-500">Email Address</Label>
              <Input
                id="email"
                type="email"
                placeholder="operator@nexus.io"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
                autoFocus
                className="h-14 !bg-white/5 !border-white/10 !text-white !ring-offset-0 focus-visible:!ring-1 focus-visible:!ring-white/30 rounded-xl px-5"
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="password" className="text-xs font-semibold uppercase tracking-wider text-neutral-500">Password</Label>
              <div className="relative">
                <Input
                  id="password"
                  type={showPassword ? "text" : "password"}
                  placeholder="••••••••"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                  className="h-14 !bg-white/5 !border-white/10 !text-white !ring-offset-0 focus-visible:!ring-1 focus-visible:!ring-white/30 rounded-xl px-5 pr-10"
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-4 top-1/2 -translate-y-1/2 text-neutral-500 hover:text-white transition-colors"
                >
                  {showPassword ? <EyeOff className="size-5" /> : <Eye className="size-5" />}
                </button>
              </div>
            </div>

            <div className="flex justify-end">
              <a href="#" className="text-xs font-medium text-primary-400 hover:text-white transition-colors">
                Recover authorization code
              </a>
            </div>

            {error && (
              <div className="p-4 text-sm font-medium text-white bg-red-500/20 border border-red-500/50 rounded-xl animate-fade-up">
                {error}
              </div>
            )}

            <Button
              type="submit"
              className="w-full h-14 btn-luxury rounded-xl text-base font-semibold tracking-wide flex items-center justify-center gap-2 group mt-8 relative overflow-hidden"
              disabled={isLoading}
            >
              {isLoading ? (
                <>
                  <svg className="animate-spin -ml-1 mr-2 h-5 w-5 text-current" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                    <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                    <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                  </svg>
                  <span>Authenticating...</span>
                </>
              ) : (
                <span className="flex items-center gap-2">
                  Initiate Handshake
                  <ArrowRight className="size-4 group-hover:translate-x-1 transition-transform" />
                </span>
              )}
            </Button>
          </form>

          <div className="mt-8">
            <div className="relative">
              <div className="absolute inset-0 flex items-center">
                <span className="w-full border-t border-white/10" />
              </div>
              <div className="relative flex justify-center text-xs uppercase">
                <span className="bg-black px-4 text-neutral-500 font-semibold tracking-widest">Or authenticate via</span>
              </div>
            </div>

            <Button
              variant="default" // use default or ghostLight based on existing components, adapting it
              className="w-full mt-8 flex items-center justify-center h-14 bg-white/5 border border-white/10 hover:bg-white/10 text-white rounded-xl transition-all"
              type="button"
              onClick={handleGoogleLogin}
              disabled={isLoading}
            >
              {isLoading ? (
                <svg className="animate-spin h-5 w-5 text-neutral-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                  <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                  <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
              ) : (
                <>
                  <svg className="w-5 h-5 mr-3" viewBox="0 0 24 24">
                    <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4" />
                    <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853" />
                    <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05" />
                    <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335" />
                  </svg>
                  <span>Google</span>
                </>
              )}
            </Button>
          </div>

          <div className="text-center text-sm text-neutral-500 mt-12 mb-8">
            Unregistered operator?{" "}
            <Link href="/register" className="text-white font-medium hover:text-neutral-300 transition-colors underline decoration-white/30 underline-offset-4">
              Request Access
            </Link>
          </div>
        </div>
      </div>

      {/* Right Image Section */}
      <div className="hidden lg:block lg:w-[55%] relative overflow-hidden bg-neutral-900 animate-cinematic-entrance" style={{ animationDelay: '0.3s' }}>
        <div className="absolute inset-0 bg-gradient-to-r from-black via-black/80 to-transparent z-10 w-48"></div>
        <img 
          src="https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&q=80&w=1920" 
          alt="Cyberpunk retro-futuristic console interface" 
          className="absolute inset-0 w-full h-full object-cover object-center opacity-50"
        />
        <div className="absolute inset-0 bg-gradient-to-t from-black via-transparent to-black opacity-60 z-10"></div>
        
        {/* Decorative floating panels for "Zero-Trust" vibe */}
        <div className="absolute bottom-1/4 right-32 glass-panel p-6 rounded-2xl w-72 z-20 shadow-2xl -skew-y-2 transform-gpu">
          <div className="flex items-center gap-3 mb-4">
            <div className="size-10 rounded-full bg-rose-500/20 flex items-center justify-center">
              <Shield className="size-5 text-rose-400" />
            </div>
            <div>
              <p className="text-white font-medium text-sm">Deepfake Vector Scans</p>
              <p className="text-xs text-rose-400 font-mono">Status: Active Monitoring</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
