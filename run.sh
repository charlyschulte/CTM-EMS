#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
set -e

# Check if we're running in Home Assistant environment
if command -v bashio >/dev/null 2>&1; then
    bashio::log.info "Creating configuration file for CTM Energy Management System..."

    # Get configuration values from config.yaml using bashio
    POSTGRES_HOST=$(bashio::config 'POSTGRES_HOST')
    POSTGRES_PORT=$(bashio::config 'POSTGRES_PORT')
    POSTGRES_DB=$(bashio::config 'POSTGRES_DB')
    POSTGRES_USER=$(bashio::config 'POSTGRES_USER')
    POSTGRES_PASSWORD=$(bashio::config 'POSTGRES_PASSWORD')
    TIBBER_API_KEY=$(bashio::config 'tibber_api_key')
    TIBBER_API_URL=$(bashio::config 'tibber_api_url')
    NODE_ENV="production"
else
    # Fallback for Docker environments
    echo "Running in standalone Docker mode"
    
    # Use environment variables with defaults
    POSTGRES_HOST=${POSTGRES_HOST:-localhost}
    POSTGRES_PORT=${POSTGRES_PORT:-5432}
    POSTGRES_DB=${POSTGRES_DB:-ctm_db}
    POSTGRES_USER=${POSTGRES_USER:-postgres}
    POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-password}
    TIBBER_API_KEY=${TIBBER_API_KEY:-""}
    TIBBER_API_URL=${TIBBER_API_URL:-"https://api.tibber.com/v1-beta/gql"}
    NODE_ENV=${NODE_ENV:-production}
fi

# Create .env file for the Node.js application
{
    echo "POSTGRES_HOST=${POSTGRES_HOST}"
    echo "POSTGRES_PORT=${POSTGRES_PORT}"
    echo "POSTGRES_DB=${POSTGRES_DB}"
    echo "POSTGRES_USER=${POSTGRES_USER}"
    echo "POSTGRES_PASSWORD=${POSTGRES_PASSWORD}"
    echo "TIBBER_API_KEY=${TIBBER_API_KEY}"
    echo "TIBBER_API_URL=${TIBBER_API_URL}"
    echo "NODE_ENV=${NODE_ENV}"
} > /app/.env

# Make sure the configuration is accessible
chmod 777 /app/.env
echo "ENV file created:"
cat /app/.env

if command -v bashio >/dev/null 2>&1; then
    bashio::log.info "Starting CTM Energy Management System..."
else
    echo "Starting CTM Energy Management System..."
fi

bun /app/dist/index.js
