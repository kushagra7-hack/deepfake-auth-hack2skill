# Deepfake Authentication Gateway - Database Setup Guide

## Overview
This guide provides step-by-step instructions for setting up the Supabase PostgreSQL database with Row Level Security (RLS) for the Deepfake Authentication Gateway.

## Prerequisites
- Supabase account (https://supabase.com)
- A new or existing Supabase project

## Setup Steps

### Step 1: Create a New Supabase Project
1. Go to https://supabase.com and log in
2. Click "New Project"
3. Enter project name: `deepfake-auth-gateway`
4. Set a strong database password (save it securely)
5. Choose a region closest to your users
6. Click "Create new project"

### Step 2: Execute SQL Schema
1. In your Supabase dashboard, go to **SQL Editor**
2. Click "New Query"
3. Copy the entire contents of `schema.sql`
4. Paste into the query editor
5. Click **Run** to execute

### Step 3: Verify Tables Created
1. Go to **Table Editor** in the sidebar
2. Confirm these tables exist:
   - `users` - User profiles (extends auth.users)
   - `scans` - Media scan audit trail
   - `audit_logs` - Security audit logs

### Step 4: Configure Authentication
1. Go to **Authentication** → **Providers**
2. Enable desired auth providers (Email, Google, GitHub, etc.)
3. Configure email templates if needed

### Step 5: Get API Keys
1. Go to **Settings** → **API**
2. Copy these values to your `.env` file:
   ```
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=your-anon-key
   SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
   ```

### Step 6: Test RLS Policies
Use the SQL Editor to verify RLS is working:

```sql
-- Test 1: Verify RLS is enabled
SELECT schemaname, tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public';

-- Test 2: View active policies
SELECT schemaname, tablename, policyname, cmd, qual 
FROM pg_policies 
WHERE schemaname = 'public';
```

## Environment Variables

Add these to your application's `.env` file:

```env
# Supabase Configuration
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key-here

# Database Connection (for direct PostgreSQL access)
DATABASE_URL=postgresql://postgres:[password]@db.[project-id].supabase.co:5432/postgres
```

## API Endpoints Generated

The database schema supports these operations:

### Users
- `POST /auth/signup` - Create new user (Supabase Auth)
- `GET /users/me` - Get current user profile
- `PATCH /users/me` - Update user profile

### Scans
- `POST /scans` - Create new scan entry (user_id auto-set)
- `GET /scans` - List user's scans (auto-filtered by RLS)
- `GET /scans/:id` - Get specific scan (only if owned)

### Admin Only
- `GET /admin/users` - List all users
- `GET /admin/scans` - List all scans
- `GET /admin/audit-logs` - View audit logs

## Security Best Practices

1. **Never expose SERVICE_ROLE_KEY** to client-side code
2. **Use ANON_KEY** for client-side Supabase client
3. **RLS policies** are enforced automatically
4. **Service role** bypasses RLS (backend only)

## Troubleshooting

### Issue: "new row violates row-level security policy"
**Solution**: Ensure `user_id` matches the authenticated user's ID when inserting.

### Issue: Empty results from SELECT queries
**Solution**: RLS is working correctly - you only see your own data.

### Issue: Cannot create user profile
**Solution**: The `handle_new_user()` trigger auto-creates profiles on auth signup.

## Next Steps

1. Configure your application's Supabase client
2. Implement authentication flow
3. Build scan submission API
4. Create admin dashboard
