#!/usr/bin/with-contenv bashio
set -e

# Get configuration values from config.yaml
POSTGRES_HOST=$(bashio::config 'POSTGRES_HOST')
POSTGRES_PORT=$(bashio::config 'POSTGRES_PORT')
POSTGRES_DB=$(bashio::config 'POSTGRES_DB')
POSTGRES_USER=$(bashio::config 'POSTGRES_USER')
POSTGRES_PASSWORD=$(bashio::config 'POSTGRES_PASSWORD')
TIBBER_API_KEY=$(bashio::config 'tibber_api_key')
TIBBER_API_URL=$(bashio::config 'tibber_api_url')

bashio::log.info "Creating configuration file for CTM Energy Management System..."

# Create .env file or config.js file for the Node.js application
cat > /app/.env << EOF
POSTGRES_HOST=${POSTGRES_HOST}
POSTGRES_PORT=${POSTGRES_PORT}
POSTGRES_DB=${POSTGRES_DB}
POSTGRES_USER=${POSTGRES_USER}
POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
TIBBER_API_KEY=${TIBBER_API_KEY}
TIBBER_API_URL=${TIBBER_API_URL}
NODE_ENV=production
EOF

# Make sure the configuration is accessible
chmod 644 /app/.env

bashio::log.info "Starting CTM Energy Management System..."

bun /app/dist/index.js
