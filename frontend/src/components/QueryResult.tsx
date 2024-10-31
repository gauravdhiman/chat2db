import React from 'react';
import { ChartDisplay } from './ChartDisplay';
import { Alert, AlertDescription } from './ui/alert';
import { Loader2 } from 'lucide-react';
import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';

interface QueryResultProps {
  data: {
    response_type: 'chart' | 'text' | 'markdown';
    text: string | null;
    chart_config: {
      chart_type: 'line' | 'bar' | 'pie' | 'scatter';
      data: any[];
      title: string;
      x_label: string;
      y_label: string;
    } | null;
  } | null;
  error: string | null;
  loading?: boolean;
}

export function QueryResult({ data, error, loading }: QueryResultProps) {
  if (loading) {
    return (
      <div className="flex items-center justify-center w-full p-8">
        <Loader2 className="w-8 h-8 animate-spin text-blue-500" />
      </div>
    );
  }

  if (error) {
    return (
      <Alert variant="destructive" className="max-w-4xl mx-auto">
        <AlertDescription>{error}</AlertDescription>
      </Alert>
    );
  }

  if (data?.response_type === 'text') {
    return <div className="max-w-4xl mx-auto p-4 bg-gray-500/10 border border-gray-500/20 rounded-lg">{data.text}</div>;
  }

  if (data?.response_type === 'markdown') {
    return (
      <ReactMarkdown 
        remarkPlugins={[remarkGfm]}
        className="prose dark:prose-invert max-w-none p-4"
      >
        {data.text || ''}
      </ReactMarkdown>
    );
  }

  if (!data || !data.chart_config) return null;

  if (data?.response_type === 'chart') {
    return <ChartDisplay {...data.chart_config} />;
  }

  return null;
}