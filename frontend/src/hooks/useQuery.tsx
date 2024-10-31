'use client';

import { useState } from 'react';

interface ChartConfig {
  chart_type: 'line' | 'bar' | 'pie' | 'scatter';
  data: any[];
  title: string;
  x_label: string;
  y_label: string;
  config?: any;
}

interface QueryResponse {
  response_type: 'chart' | 'text' | 'markdown';
  text: string | null;
  chart_config: ChartConfig | null;
}

export function useQuery() {
  const [data, setData] = useState<QueryResponse | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const executeQuery = async (query: string) => {
    setLoading(true);
    setError(null);
    console.log('NEXT_PUBLIC_BACKEND_API_BASE_URL > ', process.env.NEXT_PUBLIC_BACKEND_API_BASE_URL);
    
    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_BACKEND_API_BASE_URL}/api/query`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: JSON.stringify({ query }),
      });

      console.log('response > ', response);
      if (!response.ok) {
        console.log('response not ok > ', response.statusText);
        throw new Error('Failed to fetch data');
      }

      const responseData: QueryResponse = await response.json();
      console.log('response JSON > ', responseData);
      setData(responseData);
    } catch (err) {
      console.error('Error:', err);
      setError(err instanceof Error ? err.message : 'An error occurred while processing your query');
    } finally {
      setLoading(false);
    }
  };

  return { data, error, loading, executeQuery };
}