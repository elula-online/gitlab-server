FROM node:20-slim

# Install essential build tools (sometimes required for native modules)
RUN apt-get update && apt-get install -y python3 make g++ && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy package files
COPY package*.json ./

# Use clean-install with legacy-peer-deps to bypass version conflicts
RUN npm ci --legacy-peer-deps || npm install --legacy-peer-deps

COPY . .

# Build the TypeScript code
RUN npm run build

# Start the server
CMD ["node", "build/index.js"]