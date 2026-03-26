/**
 * Secure Storage Utility for JWT Token Management
 * 
 * Uses expo-secure-store to safely persist authentication tokens
 * in the device's encrypted keychain (iOS Keychain / Android Keystore).
 */

import * as SecureStore from 'expo-secure-store'

const JWT_KEY = 'deepfake_gateway_jwt'
const USER_EMAIL_KEY = 'deepfake_gateway_user_email'

export interface AuthSession {
  accessToken: string
  refreshToken?: string
  expiresAt?: number
  userEmail?: string
}

/**
 * Save JWT token to secure storage
 * 
 * @param token - The JWT access token to store
 */
export async function saveJWT(token: string): Promise<void> {
  try {
    await SecureStore.setItemAsync(JWT_KEY, token)
  } catch (error) {
    console.error('Error saving JWT to secure store:', error)
    throw new Error('Failed to save authentication token')
  }
}

/**
 * Retrieve JWT token from secure storage
 * 
 * @returns The stored JWT token, or null if not found
 */
export async function getJWT(): Promise<string | null> {
  try {
    const token = await SecureStore.getItemAsync(JWT_KEY)
    return token
  } catch (error) {
    console.error('Error retrieving JWT from secure store:', error)
    return null
  }
}

/**
 * Delete JWT token from secure storage
 * Call this on logout to clear the session
 */
export async function deleteJWT(): Promise<void> {
  try {
    await SecureStore.deleteItemAsync(JWT_KEY)
  } catch (error) {
    console.error('Error deleting JWT from secure store:', error)
    throw new Error('Failed to clear authentication token')
  }
}

/**
 * Save user email to secure storage
 * 
 * @param email - The user's email address
 */
export async function saveUserEmail(email: string): Promise<void> {
  try {
    await SecureStore.setItemAsync(USER_EMAIL_KEY, email)
  } catch (error) {
    console.error('Error saving user email:', error)
  }
}

/**
 * Retrieve user email from secure storage
 * 
 * @returns The stored email, or null if not found
 */
export async function getUserEmail(): Promise<string | null> {
  try {
    return await SecureStore.getItemAsync(USER_EMAIL_KEY)
  } catch (error) {
    console.error('Error retrieving user email:', error)
    return null
  }
}

/**
 * Delete user email from secure storage
 */
export async function deleteUserEmail(): Promise<void> {
  try {
    await SecureStore.deleteItemAsync(USER_EMAIL_KEY)
  } catch (error) {
    console.error('Error deleting user email:', error)
  }
}

/**
 * Save complete auth session
 * 
 * @param session - The auth session object containing token and user info
 */
export async function saveAuthSession(session: AuthSession): Promise<void> {
  try {
    await saveJWT(session.accessToken)
    if (session.userEmail) {
      await saveUserEmail(session.userEmail)
    }
  } catch (error) {
    console.error('Error saving auth session:', error)
    throw error
  }
}

/**
 * Clear complete auth session (logout)
 */
export async function clearAuthSession(): Promise<void> {
  try {
    await deleteJWT()
    await deleteUserEmail()
  } catch (error) {
    console.error('Error clearing auth session:', error)
    throw error
  }
}

/**
 * Check if user is authenticated (has valid JWT)
 * 
 * @returns true if JWT exists, false otherwise
 */
export async function isAuthenticated(): Promise<boolean> {
  const token = await getJWT()
  return token !== null
}
