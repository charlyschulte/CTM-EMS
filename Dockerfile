ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:3.18

FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required packages
RUN apk add --no-cache \
    nodejs \
    npm \
    unzip \
    curl

# Install Bun
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/root/.bun/bin:${PATH}"

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
RUN mkdir -p /data

# Copy data from the application's data folder to the persistent directory
COPY data /data

# Copy scripts
COPY run.sh /
RUN chmod a+x /run.sh

CMD ["/run.sh"]
