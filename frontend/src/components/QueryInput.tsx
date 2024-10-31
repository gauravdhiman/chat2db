'use client';
import React, { useState } from 'react'
import { Search, SendHorizontal } from 'lucide-react';
interface QueryInputProps {
  onSubmit: (query: string) => Promise<void>
  isLoading: boolean
}

export default function QueryInput({ onSubmit, isLoading }: QueryInputProps) {
  const [query, setQuery] = useState('')

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    onSubmit(query)
  }

  const handleKeyDown = (e: React.KeyboardEvent<HTMLTextAreaElement>) => {
    if ((e.metaKey || e.ctrlKey) && e.key === 'Enter') {
      e.preventDefault();
      if (query.trim()) {
        onSubmit(query);
      }
    }
  };

  return (
    <form onSubmit={handleSubmit} className="w-full max-w-3xl">
      <div className="relative flex items-center gap-2">
        <div className="relative flex-1">
          <textarea
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            onKeyDown={handleKeyDown}
            placeholder="Chat with your data in natural language..."
            className="w-full px-4 py-3 pl-3 bg-white/5 border border-gray-700 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none max-h-[200px] min-h-[44px] overflow-y-auto"
            disabled={isLoading}
            rows={1}
            onInput={(e) => {
              const target = e.target as HTMLTextAreaElement;
              target.style.height = 'auto';
              const newHeight = Math.min(target.scrollHeight, 200); // Limit to 200px
              target.style.height = `${newHeight}px`;
            }}
          >
            <Search className="absolute left-3 top-3.5 w-5 h-5 text-gray-400" />
          </textarea>
        </div>
        <button
          type="submit"
          disabled={isLoading || !query.trim()}
          className="p-2 bg-blue-500 text-white rounded-md hover:bg-blue-600 disabled:opacity-50 disabled:cursor-not-allowed flex-shrink-0"
        >
          <SendHorizontal className="w-5 h-5" />
        </button>
      </div>
    </form>
  )
}
