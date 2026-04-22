-- Enterprise-Grade Deepfake Authentication Gateway Database Schema
-- Hosted on Supabase (PostgreSQL) with Row Level Security

-- ============================================
-- 1. USERS TABLE (Extends Supabase Auth)
-- ============================================
-- Supabase provides auth.users table automatically
-- We create a public.users table for additional profile data

CREATE TABLE IF NOT EXISTS public.users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email VARCHAR(255) NOT NULL,
    full_name VARCHAR(255),
    role VARCHAR(50) DEFAULT 'user' CHECK (role IN ('user', 'admin', 'analyst')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    is_active BOOLEAN DEFAULT TRUE,
    last_login TIMESTAMP WITH TIME ZONE
);

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_users_email ON public.users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON public.users(role);

-- Trigger to automatically create user profile on auth signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.users (id, email, full_name)
    VALUES (NEW.id, NEW.email, NEW.raw_user_meta_data->>'full_name');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop existing trigger if exists
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- Create trigger
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ============================================
-- 2. SCANS TABLE (Audit Trail for Media Scans)
-- ============================================

CREATE TABLE IF NOT EXISTS public.scans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    file_name VARCHAR(500) NOT NULL,
    file_hash VARCHAR(64) NOT NULL, -- SHA-256 hash (64 hex characters)
    threat_score DECIMAL(5,2) CHECK (threat_score >= 0 AND threat_score <= 100),
    status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'failed')),
    result_details JSONB, -- Stores detailed analysis results
    media_type VARCHAR(50) CHECK (media_type IN ('image', 'video', 'audio')),
    file_size BIGINT, -- File size in bytes
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    completed_at TIMESTAMP WITH TIME ZONE
);

-- Create indexes for common queries
CREATE INDEX IF NOT EXISTS idx_scans_user_id ON public.scans(user_id);
CREATE INDEX IF NOT EXISTS idx_scans_status ON public.scans(status);
CREATE INDEX IF NOT EXISTS idx_scans_created_at ON public.scans(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_scans_file_hash ON public.scans(file_hash);
CREATE INDEX IF NOT EXISTS idx_scans_user_hash ON public.scans(user_id, file_hash);
CREATE INDEX IF NOT EXISTS idx_scans_threat_score ON public.scans(threat_score DESC);

-- ============================================
-- 3. ENABLE ROW LEVEL SECURITY (RLS)
-- ============================================

-- Enable RLS on users table
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- Enable RLS on scans table
ALTER TABLE public.scans ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 4. RLS POLICIES FOR USERS TABLE
-- ============================================

-- Users can only view their own profile
CREATE POLICY "users_select_own" ON public.users
    FOR SELECT
    USING (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY "users_update_own" ON public.users
    FOR UPDATE
    USING (auth.uid() = id);

-- Admins can view all users (optional)
CREATE POLICY "admins_select_all" ON public.users
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.users
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- Users can delete their own profile (account deletion)
CREATE POLICY "users_delete_own" ON public.users
    FOR DELETE
    USING (auth.uid() = id);

-- ============================================
-- 5. RLS POLICIES FOR SCANS TABLE
-- ============================================

-- Users can only INSERT their own scans
CREATE POLICY "scans_insert_own" ON public.scans
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Users can only SELECT their own scans
CREATE POLICY "scans_select_own" ON public.scans
    FOR SELECT
    USING (auth.uid() = user_id);

-- Admins can view all scans (optional)
CREATE POLICY "admins_select_all_scans" ON public.scans
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.users
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- System can update scan status (using service role bypass)
-- Regular users cannot UPDATE or DELETE scans (audit trail integrity)

-- ============================================
-- 6. ADDITIONAL SECURITY: FUNCTIONS AND TRIGGERS
-- ============================================

-- Function to update timestamps
CREATE OR REPLACE FUNCTION public.update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for users table
CREATE TRIGGER users_update_timestamp
    BEFORE UPDATE ON public.users
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

-- ============================================
-- 7. AUDIT LOG TABLE (for security tracking)
-- ============================================

CREATE TABLE IF NOT EXISTS public.audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    action VARCHAR(100) NOT NULL,
    table_name VARCHAR(50),
    record_id UUID,
    old_values JSONB,
    new_values JSONB,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_audit_logs_user_id ON public.audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_action ON public.audit_logs(action);
CREATE INDEX IF NOT EXISTS idx_audit_logs_created_at ON public.audit_logs(created_at DESC);

-- Enable RLS on audit_logs
ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;

-- Only admins can view audit logs
CREATE POLICY "admins_select_audit_logs" ON public.audit_logs
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.users
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- ============================================
-- 8. HELPER FUNCTIONS FOR APPLICATION
-- ============================================

-- Function to get user's scan statistics
CREATE OR REPLACE FUNCTION public.get_user_scan_stats(p_user_id UUID)
RETURNS TABLE (
    total_scans BIGINT,
    pending_scans BIGINT,
    completed_scans BIGINT,
    avg_threat_score DECIMAL(5,2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        COUNT(*)::BIGINT as total_scans,
        COUNT(*) FILTER (WHERE status = 'pending')::BIGINT as pending_scans,
        COUNT(*) FILTER (WHERE status = 'completed')::BIGINT as completed_scans,
        COALESCE(AVG(threat_score), 0)::DECIMAL(5,2) as avg_threat_score
    FROM public.scans
    WHERE user_id = p_user_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to check if file hash exists for user
CREATE OR REPLACE FUNCTION public.check_file_hash_exists(
    p_user_id UUID,
    p_file_hash VARCHAR(64)
)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM public.scans
        WHERE user_id = p_user_id AND file_hash = p_file_hash
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- 9. GRANT PERMISSIONS
-- ============================================

-- Grant usage on schemas
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO anon;

-- Grant permissions on tables
GRANT SELECT, UPDATE ON public.users TO authenticated;
GRANT SELECT, INSERT ON public.scans TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_user_scan_stats(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.check_file_hash_exists(UUID, VARCHAR(64)) TO authenticated;

-- ============================================
-- EXPLANATION: HOW RLS PREVENTS HORIZONTAL PRIVILEGE ESCALATION
-- ============================================
/*
ROW LEVEL SECURITY (RLS) PREVENTION OF HORIZONTAL PRIVILEGE ESCALATION:

Horizontal privilege escalation occurs when a user gains access to resources 
belonging to other users at the same privilege level (e.g., User A accessing 
User B's scans).

HOW RLS PREVENTS THIS:

1. POLICY ENFORCEMENT AT DATABASE LEVEL:
   - The policy "scans_select_own" uses the expression: auth.uid() = user_id
   - This condition is evaluated for EVERY row before returning results
   - If user_id doesn't match the authenticated user's ID, the row is invisible

2. NO APPLICATION-LEVEL TRUST:
   - Even if the application code has bugs or vulnerabilities
   - Even if an attacker manipulates API requests
   - The database itself enforces access control
   - SQL like "SELECT * FROM scans" automatically filters to only user's data

3. INSERT PROTECTION:
   - The policy "scans_insert_own" with WITH CHECK prevents users from 
     inserting scans with a different user_id
   - This prevents malicious users from creating fake audit entries

4. BYPASS REQUIRES SUPERUSER ACCESS:
   - To bypass RLS, an attacker would need:
     - Database superuser privileges, OR
     - Service role key (backend only)
   - Regular authenticated users cannot disable or bypass RLS

EXAMPLE ATTACK PREVENTED:
   User A (auth.uid() = 'aaa-111') tries:
   SELECT * FROM scans WHERE user_id = 'bbb-222';
   
   Result: Returns empty set because RLS filters:
   WHERE auth.uid() = user_id  -- 'aaa-111' != 'bbb-222' → FALSE
*/
