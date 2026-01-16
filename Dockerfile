FROM node:20-slim

# Install system build tools
RUN apt-get update && apt-get install -y python3 make g++ && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy package files and install
COPY package*.json ./
RUN npm install --legacy-peer-deps --ignore-scripts

# Copy code and build
COPY . .
RUN ./node_modules/.bin/tsc -p tsconfig.json

# Expose the default port for SSE
EXPOSE 3000

# Start the server in SSE mode
# Note: If the server doesn't have a specific SSE command, 
# we use the MCP inspector as a gateway or check the specific repo docs.
CMD ["node", "build/index.js", "--transport", "sse", "--port", "3000"]