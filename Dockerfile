FROM ghcr.io/hassio-addons/base:latest

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Set S6 wait time
ENV S6_CMD_WAIT_FOR_SERVICES=1 \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
    S6_SERVICES_GRACETIME=0

# Install required packages
RUN \
    apk add --no-cache \
        nodejs \
        npm \
        curl \
        unzip \
        git \
    && npm install -g npm@latest

# Set working directory
WORKDIR /app

# Install Bun
RUN curl -fsSL https://bun.sh/install | bash && \
    mv /root/.bun/bin/bun /usr/local/bin/bun && \
    chmod +x /usr/local/bin/bun

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

# Use bashio to execute the run script
CMD ["/bin/bash", "run.sh"]
