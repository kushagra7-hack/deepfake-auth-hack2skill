import { Redirect } from 'expo-router'
import { ActivityIndicator, View } from 'react-native'
import { useEffect, useState } from 'react'
import { isAuthenticated } from './utils/secure-store'

export default function Index() {
  const [isLoading, setIsLoading] = useState(true)
  const [hasAuth, setHasAuth] = useState(false)

  useEffect(() => {
    const checkAuthStatus = async () => {
      const auth = await isAuthenticated()
      setHasAuth(auth)
      setIsLoading(false)
    }
    checkAuthStatus()
  }, [])

  if (isLoading) {
    return (
      <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center', backgroundColor: '#0f172a' }}>
        <ActivityIndicator size="large" color="#3b82f6" />
      </View>
    )
  }

  if (hasAuth) {
    return <Redirect href="/(tabs)/scanner" />
  }

  return <Redirect href="/(auth)/login" />
}
