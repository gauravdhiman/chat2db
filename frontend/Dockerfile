# Use Node.js LTS
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
# COPY package*.json ./
# COPY postcss.config.js ./
# COPY tailwind.config.ts ./
# COPY tsconfig.json ./
COPY . /app

# Install dependencies
RUN npm install --legacy-peer-deps
RUN npm install -g next

# Copy the rest of the code
COPY . .

# Build the Next.js application
RUN npm run build

# Expose port
EXPOSE 3000

# Start the app
CMD ["npm", "run", "dev"]