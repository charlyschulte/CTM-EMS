FROM oven/bun:latest

# Set working directory
WORKDIR /app

# Copy package.json first for better layer caching
COPY package.json .
COPY bun.lockb .
COPY tsconfig.json .

# Install dependencies
RUN bun install --production

# Copy application code
COPY . .

# Build the application
RUN bun run build

CMD ["bun ./dist/index.js"]
