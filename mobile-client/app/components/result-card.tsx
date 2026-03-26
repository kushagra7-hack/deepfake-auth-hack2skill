import React from 'react'
import {
  View,
  Text,
  StyleSheet,
} from 'react-native'
import type { ScanResponse } from '../utils/api'

interface ResultCardProps {
  scan: ScanResponse
}

function getThreatLevel(score: number | null): {
  label: string
  color: string
  bgColor: string
  icon: string
} {
  if (score === null) {
    return {
      label: 'Processing',
      color: '#94a3b8',
      bgColor: '#1e293b',
      icon: '⏳',
    }
  }
  if (score >= 70) {
    return {
      label: 'HIGH RISK - DEEPFAKE DETECTED',
      color: '#ef4444',
      bgColor: '#7f1d1d',
      icon: '🚨',
    }
  }
  if (score >= 30) {
    return {
      label: 'MEDIUM RISK - SUSPICIOUS',
      color: '#f59e0b',
      bgColor: '#78350f',
      icon: '⚠️',
    }
  }
  return {
    label: 'LOW RISK - CLEAN',
    color: '#22c55e',
    bgColor: '#14532d',
    icon: '✅',
  }
}

function getStatusColor(status: string): string {
  const colors: Record<string, string> = {
    pending: '#f59e0b',
    processing: '#3b82f6',
    completed: '#22c55e',
    failed: '#ef4444',
  }
  return colors[status] || '#94a3b8'
}

function formatDate(dateString: string): string {
  return new Date(dateString).toLocaleString()
}

function formatBytes(bytes: number | null): string {
  if (!bytes) return 'N/A'
  if (bytes < 1024) return `${bytes} B`
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`
  if (bytes < 1024 * 1024 * 1024) return `${(bytes / 1024 / 1024).toFixed(1)} MB`
  return `${(bytes / 1024 / 1024 / 1024).toFixed(2)} GB`
}

export default function ResultCard({ scan }: ResultCardProps) {
  const threat = getThreatLevel(scan.threat_score)

  return (
    <View style={styles.container}>
      <View style={[styles.header, { backgroundColor: threat.bgColor }]}>
        <Text style={styles.icon}>{threat.icon}</Text>
        <Text style={[styles.headerTitle, { color: threat.color }]}>
          {threat.label}
        </Text>
      </View>

      <View style={styles.body}>
        <View style={styles.row}>
          <Text style={styles.label}>File Name</Text>
          <Text style={styles.value} numberOfLines={1}>
            {scan.file_name}
          </Text>
        </View>

        <View style={styles.row}>
          <Text style={styles.label}>Threat Score</Text>
          <Text style={[styles.value, { color: threat.color, fontWeight: '700' }]}>
            {scan.threat_score !== null ? `${scan.threat_score.toFixed(1)}%` : 'N/A'}
          </Text>
        </View>

        <View style={styles.row}>
          <Text style={styles.label}>Status</Text>
          <View style={[styles.statusBadge, { backgroundColor: getStatusColor(scan.status) + '20' }]}>
            <Text style={[styles.statusText, { color: getStatusColor(scan.status) }]}>
              {scan.status.toUpperCase()}
            </Text>
          </View>
        </View>

        <View style={styles.row}>
          <Text style={styles.label}>Media Type</Text>
          <Text style={styles.value}>
            {scan.media_type ? scan.media_type.charAt(0).toUpperCase() + scan.media_type.slice(1) : 'Unknown'}
          </Text>
        </View>

        <View style={styles.row}>
          <Text style={styles.label}>File Size</Text>
          <Text style={styles.value}>{formatBytes(scan.file_size)}</Text>
        </View>

        <View style={styles.row}>
          <Text style={styles.label}>Scanned At</Text>
          <Text style={styles.value}>{formatDate(scan.created_at)}</Text>
        </View>

        {scan.result_details && (
          <View style={styles.detailsContainer}>
            <Text style={styles.detailsLabel}>Analysis Details</Text>
            <View style={styles.detailsContent}>
              {scan.result_details.is_deepfake !== undefined && (
                <View style={styles.detailRow}>
                  <Text style={styles.detailKey}>Is Deepfake:</Text>
                  <Text style={[
                    styles.detailValue,
                    { color: scan.result_details.is_deepfake ? '#ef4444' : '#22c55e' }
                  ]}>
                    {scan.result_details.is_deepfake ? 'Yes' : 'No'}
                  </Text>
                </View>
              )}
              {scan.result_details.confidence_level && (
                <View style={styles.detailRow}>
                  <Text style={styles.detailKey}>Confidence:</Text>
                  <Text style={styles.detailValue}>
                    {String(scan.result_details.confidence_level).toUpperCase()}
                  </Text>
                </View>
              )}
              {scan.result_details.model_used && (
                <View style={styles.detailRow}>
                  <Text style={styles.detailKey}>Model:</Text>
                  <Text style={styles.detailValue} numberOfLines={1}>
                    {String(scan.result_details.model_used)}
                  </Text>
                </View>
              )}
            </View>
          </View>
        )}
      </View>
    </View>
  )
}

const styles = StyleSheet.create({
  container: {
    backgroundColor: '#1e293b',
    borderRadius: 16,
    overflow: 'hidden',
  },
  header: {
    padding: 20,
    alignItems: 'center',
  },
  icon: {
    fontSize: 48,
    marginBottom: 8,
  },
  headerTitle: {
    fontSize: 18,
    fontWeight: '700',
    textAlign: 'center',
  },
  body: {
    padding: 20,
  },
  row: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 12,
  },
  label: {
    fontSize: 14,
    color: '#94a3b8',
    flex: 1,
  },
  value: {
    fontSize: 14,
    color: '#ffffff',
    fontWeight: '500',
    flex: 2,
    textAlign: 'right',
  },
  statusBadge: {
    paddingHorizontal: 10,
    paddingVertical: 4,
    borderRadius: 8,
  },
  statusText: {
    fontSize: 12,
    fontWeight: '600',
  },
  detailsContainer: {
    marginTop: 16,
    paddingTop: 16,
    borderTopWidth: 1,
    borderTopColor: '#334155',
  },
  detailsLabel: {
    fontSize: 14,
    fontWeight: '600',
    color: '#e2e8f0',
    marginBottom: 12,
  },
  detailsContent: {
    backgroundColor: '#0f172a',
    borderRadius: 8,
    padding: 12,
  },
  detailRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 8,
  },
  detailKey: {
    fontSize: 13,
    color: '#94a3b8',
  },
  detailValue: {
    fontSize: 13,
    color: '#e2e8f0',
    fontWeight: '500',
  },
})
