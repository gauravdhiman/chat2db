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
  console.log('Responses:', responses);

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

  if (!responses.length) return null;

  return (
    <div className="space-y-8">
      {responses.map((item, index) => {
        console.log('Rendering item:', item);
        return (
          <div key={item.timestamp} className="border rounded-lg p-4 bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
            <div className="text-sm text-muted-foreground mb-2">
              Query: {item.query}
            </div>
            {renderResponse(item.response)}
          </div>
        );
      })}
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
    return <div className="max-w-4xl mx-auto p-4 bg-gray-500/10 border border-gray-500/20 rounded-lg">{data.text}</div>;
  }

  if (data.response_type === 'markdown') {
    return (
      <ReactMarkdown 
        remarkPlugins={[remarkGfm]}
        className="prose dark:prose-invert max-w-none p-4"
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