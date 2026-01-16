FROM node:20-slim

# Install system build tools for any native modules
RUN apt-get update && apt-get install -y python3 make g++ && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy package files first
COPY package*.json ./

# 1. Install dependencies WITHOUT running automatic build scripts
RUN npm install --legacy-peer-deps --ignore-scripts

# Copy the rest of the application code (including tsconfig.json and src/)
COPY . .

# 2. Run the build manually using the local tsc binary
RUN ./node_modules/.bin/tsc -p tsconfig.json

# 3. Ensure the output file is executable for the MCP protocol
RUN chmod +x build/index.js

# Start the server using node
CMD ["node", "build/index.js"]