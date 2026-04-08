"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "./button";
import { Input } from "./input";
import { Label } from "./label";
import { Mail, Sparkles, ArrowRight, CheckCircle2, Shield, User } from "lucide-react";
import { signUpWithEmail, supabase } from "@/lib/supabase";

export function RegisterPage() {
  const router = useRouter();
  const [fullName, setFullName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const [isSuccess, setIsSuccess] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    setIsLoading(true);

    try {
      await signUpWithEmail(email, password, fullName);
      console.log("✅ Registration successful!");
      setIsSuccess(true);
      setTimeout(() => {
        router.push("/dashboard");
      }, 2000);
    } catch (err: any) {
      setError(err.message || "Failed to create account. Please try again.");
      console.log("❌ Registration failed:", err.message);
      setIsLoading(false);
    }
  };

  const handleGoogleSignup = async () => {
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

if (isSuccess) {
  return (
  <div className="min-h-screen bg-black text-neutral-200 flex flex-col items-center justify-center p-8 font-['Outfit',sans-serif]">
  <div className="size-16 rounded-full bg-emerald-500/20 flex items-center justify-center mb-6 animate-pulse">
          <CheckCircle2 className="size-8 text-emerald-400" />
        </div>
        <h2 className="font-syne text-4xl font-bold tracking-tight text-white mb-4">Account Created</h2>
        <p className="text-neutral-400 max-w-md text-center text-lg">
          Welcome aboard, {fullName}. We're routing you to the dashboard now.
        </p>
      </div>
    );
  }

return (
  <div className="min-h-screen bg-black text-neutral-200 flex flex-col lg:flex-row font-['Outfit',sans-serif]">
  {/* Left Form Section */}
      <div className="w-full lg:w-[45%] flex flex-col justify-center p-8 lg:p-16 2xl:p-24 relative z-10">
        <div className="max-w-md w-full mx-auto animate-cinematic-entrance" style={{ animationDelay: '0.1s' }}>
          <Link href="/" className="mb-10 flex items-center gap-3 w-fit hover:opacity-80 transition-opacity">
            <div className="size-10 rounded-xl bg-gradient-to-br from-indigo-500 to-purple-600 flex items-center justify-center shadow-lg shadow-indigo-500/20 relative overflow-hidden">
              <div className="absolute inset-0 bg-white/10 animate-pulse-slow"></div>
              <Shield className="size-5 text-white relative z-10" />
            </div>
            <span className="font-syne font-bold text-xl tracking-wider text-white">NEXUS<span className="text-primary-500">_</span>GATEWAY</span>
          </Link>

          <div className="mb-12">
            <h1 className="font-syne text-3xl lg:text-4xl font-bold tracking-tight text-white mb-4 leading-tight">
              Begin your<br/>journey.
            </h1>
            <p className="text-neutral-400 text-lg font-light leading-relaxed">
              Create an account to access our suite of advanced security tools and analytics.
            </p>
          </div>

          <form onSubmit={handleSubmit} className="space-y-6">
            <div className="space-y-2">
              <Label htmlFor="fullName" className="text-xs font-semibold uppercase tracking-wider text-neutral-500">Full Name</Label>
              <Input
                id="fullName"
                type="text"
                placeholder="John Doe"
                value={fullName}
                onChange={(e) => setFullName(e.target.value)}
                required
                autoFocus
                className="h-14 !bg-white/5 !border-white/10 !text-white !ring-offset-0 focus-visible:!ring-1 focus-visible:!ring-white/30 rounded-xl px-5"
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="email" className="text-xs font-semibold uppercase tracking-wider text-neutral-500">Email Address</Label>
              <Input
                id="email"
                type="email"
                placeholder="john@example.com"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
                className="h-14 !bg-white/5 !border-white/10 !text-white !ring-offset-0 focus-visible:!ring-1 focus-visible:!ring-white/30 rounded-xl px-5"
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="password" className="text-xs font-semibold uppercase tracking-wider text-neutral-500">Password</Label>
              <Input
                id="password"
                type="password"
                placeholder="••••••••"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
                className="h-14 !bg-white/5 !border-white/10 !text-white !ring-offset-0 focus-visible:!ring-1 focus-visible:!ring-white/30 rounded-xl px-5"
              />
            </div>

            {error && (
              <div className="p-4 text-sm font-medium text-white bg-red-500/20 border border-red-500/50 rounded-xl">
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
      <span>Creating account...</span>
    </>
  ) : (
    <span className="flex items-center gap-2">
      Create Account
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
                <span className="bg-black px-4 text-neutral-500 font-semibold tracking-widest">Or continue with</span>
              </div>
            </div>

<Button
  variant="ghostLight"
  size="xl"
  className="w-full mt-8 flex items-center justify-center"
  type="button"
  onClick={handleGoogleSignup}
  disabled={isLoading}
>
  {isLoading ? (
    <svg className="animate-spin h-5 w-5 text-neutral-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
      <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
      <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
    </svg>
  ) : (
    <>
      <Mail className="mr-3 size-5 text-neutral-400" />
      <span>Google</span>
    </>
  )}
</Button>
          </div>

          <div className="text-center text-sm text-neutral-500 mt-12 mb-8">
            Already have an account?{" "}
            <Link href="/login" className="text-white font-medium hover:text-neutral-300 transition-colors underline decoration-white/30 underline-offset-4">
              Sign In
            </Link>
          </div>
        </div>
      </div>

      {/* Right Image Section */}
      <div className="hidden lg:block lg:w-[55%] relative overflow-hidden bg-neutral-900 animate-cinematic-entrance" style={{ animationDelay: '0.3s' }}>
        <div className="absolute inset-0 bg-gradient-to-r from-black to-transparent z-10 w-24"></div>
        <img 
          src="https://images.unsplash.com/photo-1550751827-4bd374c3f58b?auto=format&fit=crop&q=80&w=1920" 
          alt="Abstract dark liquid flow with cinematic lighting" 
          className="absolute inset-0 w-full h-full object-cover object-center opacity-40 blur-[2px]"
        />
        
        {/* Decorative glass panels floating on the image */}
        <div className="absolute top-1/4 right-32 glass-panel p-6 rounded-2xl w-64 z-20 shadow-2xl skew-y-3 skew-x-3 transform-gpu">
          <Shield className="size-8 text-neutral-300 mb-4" />
          <h3 className="font-syne text-white font-semibold text-lg mb-2">Enterprise Grade</h3>
          <p className="text-sm text-neutral-400">Military-level deepfake detection protecting your assets.</p>
        </div>

        <div className="absolute bottom-1/3 right-16 glass-panel p-6 rounded-2xl w-72 z-20 shadow-2xl -skew-y-3 -skew-x-3 transform-gpu">
          <div className="flex items-center gap-3 mb-4">
            <div className="size-10 rounded-full bg-indigo-500/20 flex items-center justify-center">
              <User className="size-5 text-indigo-400" />
            </div>
            <div>
              <p className="text-white font-medium text-sm">Identity Verification</p>
              <p className="text-xs text-emerald-400 font-mono">Status: Secure</p>
            </div>
          </div>
          <div className="w-full h-1 bg-white/10 rounded-full overflow-hidden">
            <div className="w-3/4 h-full bg-gradient-to-r from-indigo-500 to-purple-500 rounded-full"></div>
          </div>
        </div>
      </div>
    </div>
  );
}
