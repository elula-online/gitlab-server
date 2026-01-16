FROM node:20-slim

# Install build tools for native dependencies
RUN apt-get update && apt-get install -y python3 make g++ && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy package files
COPY package*.json ./

# Fix the "refusing to install" error by ignoring peer conflicts
RUN npm install --legacy-peer-deps

# Copy the rest of your code
COPY . .

# Explicitly build using the local tsc and point to the config file
# We skip the chmodSync part as Docker handles permissions differently
RUN ./node_modules/.bin/tsc -p tsconfig.json

# Ensure the build directory exists and has correct permissions
RUN chmod +x build/index.js

# Start the server
CMD ["node", "build/index.js"]