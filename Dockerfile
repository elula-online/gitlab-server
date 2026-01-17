# Use Node.js LTS version
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy source code
COPY . .

# Build the TypeScript code
RUN npm run build

# Expose port for HTTP mode
EXPOSE 3000

# Set environment variables for HTTP mode
ENV USE_HTTP=true
ENV HTTP_PORT=3000

# Run the server
CMD ["node", "build/index.js"]