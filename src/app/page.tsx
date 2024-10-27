'use client';

import { Database } from 'lucide-react';
import { QueryInput } from '@/components/QueryInput';
import { QueryResult } from '@/components/QueryResult';
import { useQuery } from '@/hooks/useQuery';

export default function Home() {
  const { data, error, loading, executeQuery } = useQuery();

  return (
    <main className="min-h-screen w-full">
      <div className="container mx-auto px-4 py-12">
        <div className="flex flex-col items-center gap-8">
          <div className="text-center">
            <div className="flex items-center justify-center gap-3 mb-4">
              <Database className="w-8 h-8 text-blue-500" />
              <h1 className="text-3xl font-bold">Natural Language Query</h1>
            </div>
            <p className="text-gray-400 max-w-xl">
              Ask questions about your data in plain English. The system will analyze your query,
              fetch the relevant data, and display the results.
            </p>
          </div>

          <QueryInput onSubmit={executeQuery} isLoading={loading} />
          <QueryResult data={data} error={error} />

          {!data && !error && (
            <div className="mt-8 grid grid-cols-1 md:grid-cols-2 gap-4 max-w-3xl w-full">
              <ExampleCard
                title="Trend Analysis"
                query="Show me the trend line of orders in the last three months"
              />
              <ExampleCard
                title="Aggregation"
                query="What's the total revenue by product category?"
              />
            </div>
          )}
        </div>
      </div>
    </main>
  );
}

interface ExampleCardProps {
  title: string;
  query: string;
}

const ExampleCard = ({ title, query }: ExampleCardProps) => (
  <div className="p-4 bg-white/5 border border-gray-700 rounded-lg hover:bg-white/10 transition-all cursor-pointer">
    <h3 className="font-semibold mb-2">{title}</h3>
    <p className="text-sm text-gray-400">{query}</p>
  </div>
);