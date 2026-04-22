'use client'

import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer, PieChart, Pie, Cell, Legend } from 'recharts'

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

const COLORS = {
  primary: '#3b82f6',
  amber: '#f59e0b',
  emerald: '#22c55e',
  rose: '#e11d48',
  zinc: '#71717a',
  white: '#ffffff',
}

export function ThreatBarChart({ stats }: ThreatChartProps) {
  const data = [
    { name: 'Total', value: stats.total_scans, fill: COLORS.primary },
    { name: 'Pending', value: stats.pending_scans, fill: COLORS.amber },
    { name: 'Safe', value: stats.completed_scans, fill: COLORS.emerald },
    { name: 'Threat %', value: stats.avg_threat_score, fill: COLORS.rose },
  ]

  return (
    <div className="w-full h-64">
      <h3 className="text-base font-normal text-white mb-4" style={{ fontFamily: 'var(--font-syne), sans-serif' }}>
        System Throughput
      </h3>
      <ResponsiveContainer width="100%" height="85%">
        <BarChart data={data} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
          <XAxis 
            dataKey="name" 
            axisLine={false} 
            tickLine={false} 
            tick={{ fill: COLORS.zinc, fontSize: 11, fontFamily: 'var(--font-outfit), sans-serif' }}
          />
          <YAxis 
            axisLine={false} 
            tickLine={false} 
            tick={{ fill: '#52525b', fontSize: 11, fontFamily: 'var(--font-outfit), sans-serif' }}
          />
          <Tooltip
            contentStyle={{
              backgroundColor: 'rgba(0,0,0,0.9)',
              border: '1px solid rgba(255,255,255,0.1)',
              borderRadius: '8px',
              padding: '12px',
            }}
            labelStyle={{ color: COLORS.white, fontFamily: 'var(--font-outfit), sans-serif' }}
            itemStyle={{ color: COLORS.zinc, fontFamily: 'var(--font-outfit), sans-serif' }}
          />
          <Bar 
            dataKey="value" 
            radius={[4, 4, 0, 0]} 
            maxBarSize={32}
          >
            {data.map((entry, index) => (
              <Cell key={`cell-${index}`} fill={entry.fill} />
            ))}
          </Bar>
        </BarChart>
      </ResponsiveContainer>
    </div>
  )
}

export function ThreatDoughnutChart({ threatDistribution }: ThreatChartProps) {
  const distribution = threatDistribution || { low: 10, medium: 5, high: 3 }
  
  const data = [
    { name: 'Secure', value: distribution.low, fill: COLORS.emerald },
    { name: 'Elevated', value: distribution.medium, fill: COLORS.amber },
    { name: 'Critical', value: distribution.high, fill: COLORS.rose },
  ]

  const renderLegend = (props: any) => {
    const { payload } = props
    return (
      <ul className="flex justify-center gap-6 mt-4">
        {payload.map((entry: any, index: number) => (
          <li key={`item-${index}`} className="flex items-center gap-2">
            <span 
              className="w-3 h-3 rounded-full" 
              style={{ backgroundColor: entry.color }}
            />
            <span className="text-xs text-zinc-500 font-bold" style={{ fontFamily: 'var(--font-outfit), sans-serif' }}>
              {entry.value}
            </span>
          </li>
        ))}
      </ul>
    )
  }

  return (
    <div className="w-full h-64 relative">
      <h3 className="text-base font-normal text-white mb-4" style={{ fontFamily: 'var(--font-syne), sans-serif' }}>
        Threat Distribution
      </h3>
      <div className="absolute inset-0 mt-8 m-auto w-24 h-24 bg-white/5 rounded-full blur-xl pointer-events-none" style={{ top: '50%', left: '50%', transform: 'translate(-50%, -50%)' }}></div>
      <ResponsiveContainer width="100%" height="85%">
        <PieChart>
          <Pie
            data={data}
            cx="50%"
            cy="50%"
            innerRadius="60%"
            outerRadius="80%"
            paddingAngle={4}
            dataKey="value"
          >
            {data.map((entry, index) => (
              <Cell key={`cell-${index}`} fill={entry.fill} stroke="#09090b" strokeWidth={4} />
            ))}
          </Pie>
          <Tooltip
            contentStyle={{
              backgroundColor: 'rgba(0,0,0,0.9)',
              border: '1px solid rgba(255,255,255,0.1)',
              borderRadius: '8px',
              padding: '12px',
            }}
            labelStyle={{ color: COLORS.white, fontFamily: 'var(--font-outfit), sans-serif' }}
            itemStyle={{ color: COLORS.zinc, fontFamily: 'var(--font-outfit), sans-serif' }}
          />
          <Legend content={renderLegend} />
        </PieChart>
      </ResponsiveContainer>
    </div>
  )
}

export default function ThreatChart({ stats, threatDistribution }: ThreatChartProps) {
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 gap-8 divide-y md:divide-y-0 md:divide-x divide-white/10">
      <div className="p-2">
        <ThreatBarChart stats={stats} />
      </div>
      <div className="p-2 md:pl-8 pt-8 md:pt-2">
        <ThreatDoughnutChart stats={stats} threatDistribution={threatDistribution} />
      </div>
    </div>
  )
}
