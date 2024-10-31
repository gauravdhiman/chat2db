'use client';

import { useState, useCallback, useRef } from 'react';

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

type ExecuteQueryFunction = {
  (query: string): Promise<void>;
  cancel: () => void;
};

interface QueryHistoryItem {
  query: string;
  response: QueryResponse;
  timestamp: number;
}

export function useQuery() {
  const [responses, setResponses] = useState<QueryHistoryItem[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [isActive, setIsActive] = useState(false);
  const abortController = useRef<AbortController | null>(null);

  const executeQuery = useCallback(async (query: string) => {
    if (isActive) {
      abortController.current?.abort();
    }

    abortController.current = new AbortController();
    setIsActive(true);
    setLoading(true);
    setError(null);
    
    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_BACKEND_API_BASE_URL}/api/query`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: JSON.stringify({ query }),
        signal: abortController.current.signal
      });

      if (!response.ok) {
        throw new Error('Failed to fetch data');
      }

      const responseData: QueryResponse = await response.json();
      setResponses(prev => [{
        query,
        response: responseData,
        timestamp: Date.now()
      }, ...prev]);
    } catch (err) {
      if (err instanceof Error && err.name === 'AbortError') {
        return;
      }
      console.error('Error:', err);
      setError(err instanceof Error ? err.message : 'An error occurred while processing your query');
    } finally {
      setIsActive(false);
      setLoading(false);
    }
  }, [isActive]) as ExecuteQueryFunction;

  executeQuery.cancel = () => {
    if (isActive) {
      abortController.current?.abort();
      setIsActive(false);
      setLoading(false);
    }
  };

  return { 
    responses, 
    error, 
    loading, 
    executeQuery,
    currentResponse: responses[0]?.response || null
  };
}