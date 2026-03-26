import React, { useState, useCallback } from 'react'
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  TouchableOpacity,
  ActivityIndicator,
  RefreshControl,
} from 'react-native'
import { useFocusEffect } from '@react-navigation/native'
import { router } from 'expo-router'
import { getScans, checkAuth, type ScanResponse } from '../utils/api'
import ResultCard from '../components/result-card'

export default function HistoryScreen() {
  const [scans, setScans] = useState<ScanResponse[]>([])
  const [isLoading, setIsLoading] = useState(true)
  const [isRefreshing, setIsRefreshing] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [page, setPage] = useState(1)
  const [hasMore, setHasMore] = useState(true)

  const fetchScans = useCallback(async (pageNum: number, refresh = false) => {
    try {
      if (refresh) {
        setIsRefreshing(true)
      } else if (pageNum === 1) {
        setIsLoading(true)
      }
      setError(null)

      const data = await getScans(pageNum, 10)
      
      if (refresh || pageNum === 1) {
        setScans(data.scans)
      } else {
        setScans(prev => [...prev, ...data.scans])
      }
      
      setHasMore(data.scans.length === 10)
      setPage(pageNum)
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Failed to load history'
      
      if (message.includes('Not authenticated') || message.includes('Session expired')) {
        router.replace('/(auth)/login')
        return
      }
      
      setError(message)
    } finally {
      setIsLoading(false)
      setIsRefreshing(false)
    }
  }, [])

  useFocusEffect(
    useCallback(() => {
      const init = async () => {
        const hasAuth = await checkAuth()
        if (!hasAuth) {
          router.replace('/(auth)/login')
          return
        }
        fetchScans(1)
      }
      init()
    }, [fetchScans])
  )

  const handleRefresh = () => {
    fetchScans(1, true)
  }

  const handleLoadMore = () => {
    if (!isLoading && !isRefreshing && hasMore) {
      fetchScans(page + 1)
    }
  }

  const renderFooter = () => {
    if (!isLoading || page === 1) return null
    return (
      <View style={styles.footer}>
        <ActivityIndicator size="small" color="#3b82f6" />
      </View>
    )
  }

  const renderEmpty = () => {
    if (isLoading) return null
    
    return (
      <View style={styles.emptyContainer}>
        <Text style={styles.emptyIcon}>📋</Text>
        <Text style={styles.emptyTitle}>No Scan History</Text>
        <Text style={styles.emptySubtitle}>
          Your scanned files will appear here
        </Text>
        <TouchableOpacity
          style={styles.scanButton}
          onPress={() => router.push('/(tabs)/scanner')}
        >
          <Text style={styles.scanButtonText}>Scan a File</Text>
        </TouchableOpacity>
      </View>
    )
  }

  if (isLoading && page === 1) {
    return (
      <View style={styles.loadingContainer}>
        <ActivityIndicator size="large" color="#3b82f6" />
        <Text style={styles.loadingText}>Loading history...</Text>
      </View>
    )
  }

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Scan History</Text>
        <Text style={styles.subtitle}>
          {scans.length} {scans.length === 1 ? 'scan' : 'scans'} found
        </Text>
      </View>

      {error ? (
        <View style={styles.errorContainer}>
          <Text style={styles.errorText}>{error}</Text>
          <TouchableOpacity style={styles.retryButton} onPress={handleRefresh}>
            <Text style={styles.retryButtonText}>Retry</Text>
          </TouchableOpacity>
        </View>
      ) : (
        <FlatList
          data={scans}
          keyExtractor={(item) => item.id}
          renderItem={({ item }) => (
            <View style={styles.cardContainer}>
              <ResultCard scan={item} />
            </View>
          )}
          contentContainerStyle={styles.listContent}
          refreshControl={
            <RefreshControl
              refreshing={isRefreshing}
              onRefresh={handleRefresh}
              tintColor="#3b82f6"
            />
          }
          onEndReached={handleLoadMore}
          onEndReachedThreshold={0.5}
          ListFooterComponent={renderFooter}
          ListEmptyComponent={renderEmpty}
          showsVerticalScrollIndicator={false}
        />
      )}
    </View>
  )
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#0f172a',
  },
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#0f172a',
  },
  loadingText: {
    marginTop: 12,
    color: '#94a3b8',
    fontSize: 16,
  },
  header: {
    padding: 20,
    paddingBottom: 12,
  },
  title: {
    fontSize: 32,
    fontWeight: 'bold',
    color: '#ffffff',
    marginBottom: 4,
  },
  subtitle: {
    fontSize: 14,
    color: '#94a3b8',
  },
  listContent: {
    paddingHorizontal: 20,
    paddingBottom: 20,
  },
  cardContainer: {
    marginBottom: 12,
  },
  footer: {
    paddingVertical: 20,
    alignItems: 'center',
  },
  emptyContainer: {
    flex: 1,
    alignItems: 'center',
    paddingTop: 60,
  },
  emptyIcon: {
    fontSize: 64,
    marginBottom: 16,
  },
  emptyTitle: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#ffffff',
    marginBottom: 8,
  },
  emptySubtitle: {
    fontSize: 16,
    color: '#94a3b8',
    marginBottom: 24,
  },
  scanButton: {
    backgroundColor: '#2563eb',
    paddingHorizontal: 24,
    paddingVertical: 12,
    borderRadius: 12,
  },
  scanButtonText: {
    color: '#ffffff',
    fontSize: 16,
    fontWeight: '600',
  },
  errorContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  errorText: {
    color: '#ef4444',
    fontSize: 16,
    textAlign: 'center',
    marginBottom: 16,
  },
  retryButton: {
    backgroundColor: '#1e293b',
    paddingHorizontal: 24,
    paddingVertical: 12,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: '#334155',
  },
  retryButtonText: {
    color: '#94a3b8',
    fontSize: 16,
    fontWeight: '600',
  },
})
