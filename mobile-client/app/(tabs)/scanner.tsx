import React, { useState, useCallback } from 'react'
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  Alert,
  ActivityIndicator,
  ScrollView,
  RefreshControl,
} from 'react-native'
import * as DocumentPicker from 'expo-document-picker'
import { useFocusEffect } from '@react-navigation/native'
import { checkAuth, uploadScan, type ScanResponse } from '../utils/api'
import { router } from 'expo-router'
import ResultCard from '../components/result-card'
import ActionButton from '../components/action-button'

type ScanState = {
  status: 'idle' | 'uploading' | 'success' | 'error'
  result: ScanResponse | null
  error: string | null
}

export default function ScannerScreen() {
  const [scanState, setScanState] = useState<ScanState>({
    status: 'idle',
    result: null,
    error: null,
  })
  const [isCheckingAuth, setIsCheckingAuth] = useState(true)

  useFocusEffect(
    useCallback(() => {
      const verifyAuth = async () => {
        const hasAuth = await checkAuth()
        if (!hasAuth) {
          router.replace('/(auth)/login')
        }
        setIsCheckingAuth(false)
      }
      verifyAuth()
    }, [])
  )

  const pickDocument = async () => {
    try {
      const result = await DocumentPicker.getDocumentAsync({
        type: [
          'video/*',
          'audio/*',
          'image/*',
        ],
        copyToCacheDirectory: true,
      })

      if (result.canceled) {
        return
      }

      const file = result.assets[0]
      
      if (!file.uri || !file.name) {
        Alert.alert('Error', 'Could not select file')
        return
      }

      setScanState({
        status: 'uploading',
        result: null,
        error: null,
      })

      const scanResult = await uploadScan(file.uri, file.name)
      
      setScanState({
        status: 'success',
        result: scanResult,
        error: null,
      })
    } catch (error) {
      const message = error instanceof Error ? error.message : 'Upload failed'
      
      if (message.includes('Not authenticated') || message.includes('Session expired')) {
        router.replace('/(auth)/login')
        return
      }
      
      setScanState({
        status: 'error',
        result: null,
        error: message,
      })
      
      Alert.alert('Upload Failed', message)
    }
  }

  const handleScanAnother = () => {
    setScanState({
      status: 'idle',
      result: null,
      error: null,
    })
  }

  if (isCheckingAuth) {
    return (
      <View style={styles.loadingContainer}>
        <ActivityIndicator size="large" color="#3b82f6" />
        <Text style={styles.loadingText}>Verifying authentication...</Text>
      </View>
    )
  }

  return (
    <ScrollView
      style={styles.container}
      contentContainerStyle={styles.scrollContent}
      refreshControl={
        <RefreshControl
          refreshing={false}
          onRefresh={() => {
            setScanState({ status: 'idle', result: null, error: null })
          }}
          tintColor="#3b82f6"
        />
      }
    >
      <View style={styles.header}>
        <Text style={styles.title}>Media Scanner</Text>
        <Text style={styles.subtitle}>
          Select a video, audio, or image file to analyze for deepfakes
        </Text>
      </View>

      {scanState.status === 'idle' && (
        <View style={styles.idleContainer}>
          <TouchableOpacity style={styles.uploadButton} onPress={pickDocument}>
            <Text style={styles.uploadIcon}>📁</Text>
            <Text style={styles.uploadText}>Select File to Scan</Text>
            <Text style={styles.uploadSubtext}>
              MP4, AVI, MOV, WAV, MP3, PNG, JPG, etc.
            </Text>
          </TouchableOpacity>

          <View style={styles.infoContainer}>
            <View style={styles.infoRow}>
              <Text style={styles.infoIcon}>🔒</Text>
              <Text style={styles.infoText}>Files verified by magic byte signature</Text>
            </View>
            <View style={styles.infoRow}>
              <Text style={styles.infoIcon}>🔐</Text>
              <Text style={styles.infoText}>Protected by Row Level Security</Text>
            </View>
            <View style={styles.infoRow}>
              <Text style={styles.infoIcon}>⚡</Text>
              <Text style={styles.infoText}>Cryptographic deduplication enabled</Text>
            </View>
          </View>
        </View>
      )}

      {scanState.status === 'uploading' && (
        <View style={styles.uploadingContainer}>
          <ActivityIndicator size="large" color="#3b82f6" />
          <Text style={styles.uploadingText}>Analyzing file...</Text>
          <Text style={styles.uploadingSubtext}>
            This may take a moment for large files
          </Text>
        </View>
      )}

      {scanState.status === 'error' && (
        <View style={styles.errorContainer}>
          <Text style={styles.errorIcon}>❌</Text>
          <Text style={styles.errorTitle}>Analysis Failed</Text>
          <Text style={styles.errorMessage}>{scanState.error}</Text>
          <ActionButton
            title="Try Again"
            onPress={pickDocument}
            variant="secondary"
          />
        </View>
      )}

      {scanState.status === 'success' && scanState.result && (
        <View style={styles.resultContainer}>
          <ResultCard scan={scanState.result} />
          
          <View style={styles.actionButtons}>
            <ActionButton
              title="Scan Another File"
              onPress={handleScanAnother}
              variant="primary"
            />
            <ActionButton
              title="View History"
              onPress={() => router.push('/(tabs)/history')}
              variant="secondary"
            />
          </View>
        </View>
      )}
    </ScrollView>
  )
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#0f172a',
  },
  scrollContent: {
    flexGrow: 1,
    padding: 20,
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
    marginBottom: 32,
  },
  title: {
    fontSize: 32,
    fontWeight: 'bold',
    color: '#ffffff',
    marginBottom: 8,
  },
  subtitle: {
    fontSize: 16,
    color: '#94a3b8',
    lineHeight: 22,
  },
  idleContainer: {
    flex: 1,
  },
  uploadButton: {
    backgroundColor: '#1e293b',
    borderRadius: 16,
    padding: 40,
    alignItems: 'center',
    marginBottom: 24,
    borderWidth: 2,
    borderColor: '#334155',
    borderStyle: 'dashed',
  },
  uploadIcon: {
    fontSize: 48,
    marginBottom: 16,
  },
  uploadText: {
    fontSize: 18,
    fontWeight: '600',
    color: '#ffffff',
    marginBottom: 8,
  },
  uploadSubtext: {
    fontSize: 14,
    color: '#64748b',
  },
  infoContainer: {
    backgroundColor: '#1e293b',
    borderRadius: 12,
    padding: 16,
  },
  infoRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 12,
  },
  infoIcon: {
    fontSize: 20,
    marginRight: 12,
  },
  infoText: {
    fontSize: 14,
    color: '#94a3b8',
    flex: 1,
  },
  uploadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingVertical: 80,
  },
  uploadingText: {
    fontSize: 18,
    fontWeight: '600',
    color: '#ffffff',
    marginTop: 16,
    marginBottom: 8,
  },
  uploadingSubtext: {
    fontSize: 14,
    color: '#94a3b8',
  },
  errorContainer: {
    flex: 1,
    alignItems: 'center',
    paddingVertical: 40,
  },
  errorIcon: {
    fontSize: 64,
    marginBottom: 16,
  },
  errorTitle: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#ef4444',
    marginBottom: 8,
  },
  errorMessage: {
    fontSize: 14,
    color: '#94a3b8',
    textAlign: 'center',
    marginBottom: 24,
    paddingHorizontal: 20,
  },
  resultContainer: {
    flex: 1,
  },
  actionButtons: {
    marginTop: 24,
    gap: 12,
  },
})
