import React from 'react';
import {
  LineChart, Line, BarChart, Bar, PieChart, Pie, ScatterChart, Scatter,
  XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, Cell
} from 'recharts';

interface ChartData {
  x: string | number;
  y: {
    [series: string]: number;
  };
}

interface ChartConfig {
  chart_type: 'line' | 'bar' | 'pie' | 'scatter';
  data: ChartData[];
  title: string;
  x_label: string;
  y_label: string;
  config?: any;
}

interface Data {
  chart_config: ChartConfig;
  response_type: 'chart' | 'text';
  text: string | null;
}

interface ChartDisplayProps {
  data: Data;
}

const COLORS = [
  '#60A5FA', '#34D399', '#F472B6', '#FBBF24', '#A78BFA', 
  '#F87171', '#4ADE80', '#2DD4BF', '#FB923C', '#818CF8'
];

export function ChartDisplay(chartConfig: ChartConfig) {
  // Validate data before rendering
  if (!chartConfig.data || !Array.isArray(chartConfig.data) || chartConfig.data.length === 0) {
    return (
      <div className="w-full max-w-4xl mx-auto p-4 bg-yellow-500/10 border border-yellow-500/20 rounded-lg">
        <p className="text-yellow-400">No data available to display the chart.</p>
      </div>
    );
  }

  // Validate that data points have required x and y properties
  const isValidData = chartConfig.data.every(point => 
    point.hasOwnProperty('x') && point.hasOwnProperty('y')
  );

  if (!isValidData) {
    return (
      <div className="w-full max-w-4xl mx-auto p-4 bg-red-500/10 border border-red-500/20 rounded-lg">
        <p className="text-red-400">Invalid data format. Each data point must have 'x' and 'y' values.</p>
      </div>
    );
  }

  const renderChart = () => {
    const commonProps = {
      height: 400,
      margin: { top: 20, right: 30, left: 50, bottom: 50 },
    };

    // Calculate min and max values for Y-axis
    const yValues = chartConfig.data.map(point => Object.values(point.y)).flat();
    const minY =  Math.min(...yValues);
    const maxY = Math.max(...yValues);
    
    // Add padding to the domain to make small variations more visible
    const yAxisDomain = [
      minY - Math.max(0.1, minY * 0.1), // Add 10% padding below, but at least 0.1
      maxY + Math.max(0.1, maxY * 0.1)  // Add 10% padding above, but at least 0.1
    ];

    switch (chartConfig.chart_type) {
      case 'line':
        return (
          <LineChart data={chartConfig.data} {...commonProps}>
            <CartesianGrid strokeDasharray="3 3" stroke="#374151" />
            <XAxis 
              dataKey="x" 
              label={{ value: chartConfig.x_label, position: 'bottom', offset: 20 }}
              stroke="#9CA3AF"
              angle={-45}
              textAnchor="end"
              height={60}
              tick={{ fontSize: 12 }}
            />
            <YAxis
              label={{ value: chartConfig.y_label, angle: -90, position: 'left', offset: 10 }}
              stroke="#9CA3AF"
              domain={yAxisDomain}
              tickCount={5} // Force more tick marks
              allowDecimals={true}
              tickFormatter={(value) => Number(value).toFixed(1)}
            />
            <Tooltip 
              contentStyle={{
                backgroundColor: '#1F2937',
                border: '1px solid #374151',
                borderRadius: '0.5rem',
                color: '#fff',
                padding: '8px 12px',
              }}
              formatter={(value, name) => [`${value}`, name]}
              labelFormatter={(label) => `Date: ${label}`}
            />
            <Legend 
              verticalAlign="top" 
              height={36}
              wrapperStyle={{ paddingBottom: '10px' }}
            />
            {Object.keys(chartConfig.data[0].y).map((series, index) => (
              <Line 
                key={series} 
                type="monotone" 
                dataKey={`y.${series}`}
                name={series}
                stroke={COLORS[index % COLORS.length]} 
                strokeWidth={2.5} // Increased line thickness
                dot={{ 
                  fill: COLORS[index % COLORS.length], 
                  r: 5,
                  strokeWidth: 2,
                  stroke: '#1F2937'
                }}
                activeDot={{ 
                  r: 8,
                  stroke: '#ffffff',
                  strokeWidth: 2
                }}
              />
            ))}
          </LineChart>
        );

      case 'bar':
        return (
          <BarChart data={chartConfig.data} {...commonProps}>
            <CartesianGrid strokeDasharray="3 3" stroke="#374151" />
            <XAxis 
              dataKey="x"
              label={{ value: chartConfig.x_label, position: 'bottom' }}
              stroke="#9CA3AF"
            />
            <YAxis
              label={{ value: chartConfig.y_label, angle: -90, position: 'left' }}
              stroke="#9CA3AF"
              domain={[minY, maxY]} // Dynamically set the domain based on min and max Y values
            />
            <Tooltip
              contentStyle={{
                backgroundColor: '#1F2937',
                border: '1px solid #374151',
                borderRadius: '0.5rem',
                color: '#fff'
              }}
            />
            <Legend />
            {Object.keys(chartConfig.data[0].y).map((series, index) => (
              <Bar 
                key={series} 
                dataKey={`y.${series}`}
                name={series}
                fill={COLORS[index % COLORS.length]}
                radius={[4, 4, 0, 0]}
              />
            ))}
          </BarChart>
        );

      case 'pie':
        return (
          <PieChart {...commonProps}>
            <Pie
              data={chartConfig.data}
              dataKey="y"
              nameKey="x"
              cx="50%"
              cy="50%"
              outerRadius={150}
              label={({
                cx,
                cy,
                midAngle,
                innerRadius,
                outerRadius,
                value,
                index
              }) => {
                const RADIAN = Math.PI / 180;
                const radius = 25 + innerRadius + (outerRadius - innerRadius);
                const x = cx + radius * Math.cos(-midAngle * RADIAN);
                const y = cy + radius * Math.sin(-midAngle * RADIAN);
                return (
                  <text
                    x={x}
                    y={y}
                    className="fill-gray-200 text-sm"
                    textAnchor={x > cx ? 'start' : 'end'}
                    dominantBaseline="central"
                  >
                    {`${chartConfig.data[index].x} (${value})`}
                  </text>
                );
              }}
            >
              {chartConfig.data.map((_, index) => (
                <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
              ))}
            </Pie>
            <Tooltip
              contentStyle={{
                backgroundColor: '#1F2937',
                border: '1px solid #374151',
                borderRadius: '0.5rem',
                padding: '8px 12px',
                color: '#ffffff',  // Ensuring text is white
                fontSize: '14px'
              }}
              formatter={(value, name) => [value, name]}
              labelStyle={{
                color: '#ffffff',
                fontWeight: 'bold',
                marginBottom: '4px'
              }}
              itemStyle={{
                color: '#ffffff',  // Making item text white
                padding: '2px 0'
              }}
            />
            <Legend
              formatter={(value) => <span className="text-gray-200">{value}</span>}
            />
          </PieChart>
        );

      case 'scatter':
        return (
          <ScatterChart {...commonProps}>
            <CartesianGrid strokeDasharray="3 3" stroke="#374151" />
            <XAxis 
              dataKey="x"
              label={{ value: chartConfig.x_label, position: 'bottom' }}
              stroke="#9CA3AF"
            />
            <YAxis
              dataKey="y"
              label={{ value: chartConfig.y_label, angle: -90, position: 'left' }}
              stroke="#9CA3AF"
              domain={[minY, maxY]} // Dynamically set the domain based on min and max Y values
            />
            <Tooltip
              contentStyle={{
                backgroundColor: '#1F2937',
                border: '1px solid #374151',
                borderRadius: '0.5rem',
                color: '#fff'
              }}
            />
            <Legend />
            <Scatter name="Data Points" data={chartConfig.data} fill="#3B82F6" />
          </ScatterChart>
        );

      default:
        return null;
    }
  };

  return (
    <div className="w-full">
      <h2 className="text-xl font-semibold mb-4 text-center">{chartConfig.title}</h2>
      <div className="bg-gray-800/50 border border-gray-700 rounded-xl p-6">
        <ResponsiveContainer width="100%" height={500}>
          {renderChart() || (
            <div className="flex items-center justify-center h-full">
              <p className="text-gray-400">Unable to render chart</p>
            </div>
          )}
        </ResponsiveContainer>
      </div>
    </div>
  );
} 