interface QueryResultProps {
    data: any;
    error: string | null;
  }
  
  export function QueryResult({ data, error }: QueryResultProps) {
    if (error) {
      return (
        <div className="w-full max-w-3xl p-4 bg-red-500/10 border border-red-500/20 rounded-lg">
          <p className="text-red-400">{error}</p>
        </div>
      );
    }
  
    if (!data) {
      return null;
    }
  
    return (
      <div className="w-full max-w-3xl p-4 bg-white/5 border border-gray-700 rounded-lg">
        <pre className="text-sm overflow-x-auto">
          {JSON.stringify(data, null, 2)}
        </pre>
      </div>
    );
  }