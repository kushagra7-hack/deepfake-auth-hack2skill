'use client'

import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend,
  ArcElement,
} from 'chart.js'
import { Bar, Doughnut } from 'react-chartjs-2'

ChartJS.register(
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend,
  ArcElement
)

interface ThreatChartProps {
  stats: {
    total_scans: number
    pending_scans: number
    completed_scans: number
    avg_threat_score: number
  }
  threatDistribution?: {
    low: number
    medium: number
    high: number
  }
}

export function ThreatBarChart({ stats }: ThreatChartProps) {
  const data = {
    labels: ['Total Scans', 'Pending', 'Completed', 'Avg Threat %'],
    datasets: [
      {
        label: 'Count',
        data: [stats.total_scans, stats.pending_scans, stats.completed_scans, stats.avg_threat_score],
        backgroundColor: [
          'rgba(59, 130, 246, 0.8)',
          'rgba(234, 179, 8, 0.8)',
          'rgba(34, 197, 94, 0.8)',
          'rgba(239, 68, 68, 0.8)',
        ],
        borderColor: [
          'rgb(59, 130, 246)',
          'rgb(234, 179, 8)',
          'rgb(34, 197, 94)',
          'rgb(239, 68, 68)',
        ],
        borderWidth: 1,
      },
    ],
  }

  const options = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        display: false,
      },
      title: {
        display: true,
        text: 'Scan Statistics',
        color: '#fff',
        font: {
          size: 16,
          weight: 'bold' as const,
        },
      },
    },
    scales: {
      y: {
        beginAtZero: true,
        grid: {
          color: 'rgba(255, 255, 255, 0.1)',
        },
        ticks: {
          color: '#94a3b8',
        },
      },
      x: {
        grid: {
          display: false,
        },
        ticks: {
          color: '#94a3b8',
        },
      },
    },
  }

  return (
    <div className="w-full h-64">
      <Bar data={data} options={options} />
    </div>
  )
}

export function ThreatDoughnutChart({ threatDistribution }: ThreatChartProps) {
  const distribution = threatDistribution || { low: 10, medium: 5, high: 3 }

  const data = {
    labels: ['Low Risk', 'Medium Risk', 'High Risk'],
    datasets: [
      {
        data: [distribution.low, distribution.medium, distribution.high],
        backgroundColor: [
          'rgba(34, 197, 94, 0.8)',
          'rgba(234, 179, 8, 0.8)',
          'rgba(239, 68, 68, 0.8)',
        ],
        borderColor: [
          'rgb(34, 197, 94)',
          'rgb(234, 179, 8)',
          'rgb(239, 68, 68)',
        ],
        borderWidth: 2,
      },
    ],
  }

  const options = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        position: 'bottom' as const,
        labels: {
          color: '#94a3b8',
          padding: 20,
          font: {
            size: 12,
          },
        },
      },
      title: {
        display: true,
        text: 'Threat Distribution',
        color: '#fff',
        font: {
          size: 16,
          weight: 'bold' as const,
        },
      },
    },
    cutout: '60%',
  }

  return (
    <div className="w-full h-64">
      <Doughnut data={data} options={options} />
    </div>
  )
}

export default function ThreatChart({ stats, threatDistribution }: ThreatChartProps) {
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div className="bg-slate-800/50 rounded-xl p-6 border border-slate-700">
        <ThreatBarChart stats={stats} />
      </div>
      <div className="bg-slate-800/50 rounded-xl p-6 border border-slate-700">
        <ThreatDoughnutChart stats={stats} threatDistribution={threatDistribution} />
      </div>
    </div>
  )
}
