import React from 'react';
import { ChartDisplay } from './ChartDisplay';
import { Alert, AlertDescription } from './ui/alert';
import { Loader2 } from 'lucide-react';
import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';

interface QueryResultProps {
  responses?: {
    query: string;
    response: {
      response_type: 'chart' | 'text' | 'markdown';
      text: string | null;
      chart_config: {
        chart_type: 'line' | 'bar' | 'pie' | 'scatter';
        data: any[];
        title: string;
        x_label: string;
        y_label: string;
      } | null;
    };
    timestamp: number;
  }[];
  error: string | null;
  loading?: boolean;
}

export function QueryResult({ responses = [], error, loading }: QueryResultProps) {
  return (
    <div className="space-y-8 w-full max-w-6xl mx-auto">
      {loading && (
        <div className="border rounded-lg p-4 bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60 flex items-center justify-center w-full">
          <Loader2 className="w-8 h-8 animate-spin text-blue-500" />
        </div>
      )}

      {error && (
        <Alert variant="destructive" className="w-full">
          <AlertDescription>{error}</AlertDescription>
        </Alert>
      )}

      {responses.map((item) => (
        <div 
          key={item.timestamp} 
          className="border rounded-lg p-4 bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60 w-full"
        >
          <div className="text-sm text-muted-foreground mb-2">
            Query: {item.query}
          </div>
          {renderResponse(item.response)}
        </div>
      ))}
    </div>
  );
}

function renderResponse(data: {
  response_type: 'chart' | 'text' | 'markdown';
  text: string | null;
  chart_config: {
    chart_type: 'line' | 'bar' | 'pie' | 'scatter';
    data: any[];
    title: string;
    x_label: string;
    y_label: string;
  } | null;
}) {
  if (data.response_type === 'text' && data.text?.includes('**')) {
    data.response_type = 'markdown';
  }

  if (data.response_type === 'text') {
    return <div className="w-full p-4 bg-gray-500/10 border border-gray-500/20 rounded-lg">{data.text}</div>;
  }

  if (data.response_type === 'markdown') {
    return (
      <ReactMarkdown 
        remarkPlugins={[remarkGfm]}
        className="prose dark:prose-invert w-full p-4"
      >
        {data.text || ''}
      </ReactMarkdown>
    );
  }

  if (data.response_type === 'chart' && data.chart_config) {
    return <ChartDisplay {...data.chart_config} />;
  }

  return null;
}