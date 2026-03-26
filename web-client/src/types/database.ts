/**
 * Database types for Supabase
 */

export interface Database {
  public: {
    Tables: {
      users: {
        Row: {
          id: string
          email: string
          full_name: string | null
          role: string
          created_at: string
          updated_at: string
          is_active: boolean
          last_login: string | null
        }
        Insert: {
          id: string
          email: string
          full_name?: string | null
          role?: string
          created_at?: string
          updated_at?: string
          is_active?: boolean
          last_login?: string | null
        }
        Update: {
          id?: string
          email?: string
          full_name?: string | null
          role?: string
          created_at?: string
          updated_at?: string
          is_active?: boolean
          last_login?: string | null
        }
      }
      scans: {
        Row: {
          id: string
          user_id: string
          file_name: string
          file_hash: string
          threat_score: number | null
          status: string
          media_type: string | null
          file_size: number | null
          result_details: Record<string, unknown> | null
          created_at: string
          completed_at: string | null
        }
        Insert: {
          id?: string
          user_id: string
          file_name: string
          file_hash: string
          threat_score?: number | null
          status?: string
          media_type?: string | null
          file_size?: number | null
          result_details?: Record<string, unknown> | null
          created_at?: string
          completed_at?: string | null
        }
        Update: {
          id?: string
          user_id?: string
          file_name?: string
          file_hash?: string
          threat_score?: number | null
          status?: string
          media_type?: string | null
          file_size?: number | null
          result_details?: Record<string, unknown> | null
          created_at?: string
          completed_at?: string | null
        }
      }
      audit_logs: {
        Row: {
          id: string
          user_id: string | null
          action: string
          table_name: string | null
          record_id: string | null
          old_values: Record<string, unknown> | null
          new_values: Record<string, unknown> | null
          ip_address: string | null
          user_agent: string | null
          created_at: string
        }
        Insert: {
          id?: string
          user_id?: string | null
          action: string
          table_name?: string | null
          record_id?: string | null
          old_values?: Record<string, unknown> | null
          new_values?: Record<string, unknown> | null
          ip_address?: string | null
          user_agent?: string | null
          created_at?: string
        }
        Update: {
          id?: string
          user_id?: string | null
          action?: string
          table_name?: string | null
          record_id?: string | null
          old_values?: Record<string, unknown> | null
          new_values?: Record<string, unknown> | null
          ip_address?: string | null
          user_agent?: string | null
          created_at?: string
        }
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      get_user_scan_stats: {
        Args: { p_user_id: string }
        Returns: {
          total_scans: number
          pending_scans: number
          completed_scans: number
          avg_threat_score: number
        }
      }
      check_file_hash_exists: {
        Args: { p_user_id: string; p_file_hash: string }
        Returns: boolean
      }
    }
    Enums: {
      [_ in never]: never
    }
  }
}
