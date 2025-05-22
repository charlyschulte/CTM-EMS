#!/bin/sh
set -e

# Check if we're running in Home Assistant environment
if [ -f "/usr/bin/bashio" ] && [ -d "/data" ]; then
    echo "Running in Home Assistant environment"
    
    # Load configuration using Home Assistant CLI tool
    echo "Creating configuration file for CTM Energy Management System..."

    # Get configuration values from config.yaml using bashio CLI
    POSTGRES_HOST="$(/usr/bin/bashio config:get POSTGRES_HOST)"
    POSTGRES_PORT="$(/usr/bin/bashio config:get POSTGRES_PORT)"
    POSTGRES_DB="$(/usr/bin/bashio config:get POSTGRES_DB)"
    POSTGRES_USER="$(/usr/bin/bashio config:get POSTGRES_USER)"
    POSTGRES_PASSWORD="$(/usr/bin/bashio config:get POSTGRES_PASSWORD)"
    TIBBER_API_KEY="$(/usr/bin/bashio config:get tibber_api_key)"
    TIBBER_API_URL="$(/usr/bin/bashio config:get tibber_api_url)"
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

echo "Starting CTM Energy Management System..."

bun /app/dist/index.js
