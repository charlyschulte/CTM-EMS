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

# Change the CMD instruction to correctly run the index.js file
CMD ["bun", "./dist/index.js"]
