FROM ghcr.io/hassio-addons/base-nodejs:stable
#FROM oven/bun:latest

# Set working directory
WORKDIR /app
curl -fsSL https://bun.sh/install | bash

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

# Make the run script executable
RUN chmod +x run.sh

# Use shell to execute the run script
CMD ["/bin/sh", "run.sh"]
