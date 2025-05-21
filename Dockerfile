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

# Set up persistent data directory
RUN mkdir -p /app

# Copy data from the application's data folder to the persistent directory
COPY ./ /app

# Copy scripts
COPY run.sh /
RUN chmod a+x /run.sh

CMD ["/run.sh"]
