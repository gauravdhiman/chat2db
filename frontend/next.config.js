/** @type {import('next').NextConfig} */
const nextConfig = {
    output: 'standalone',
    reactStrictMode: true,
    experimental: {
      // Enable App Router features
      appDir: true,
    },
    // Optionally, add this to support both /pages and /app directories during migration
    // useFileSystemPublicRoutes: true,
  }
  
  module.exports = nextConfig