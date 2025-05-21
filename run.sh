#!/bin/sh
set -e

# Function to read config from config.yaml or environment variable
get_config() {
  local key=$1
  local default_value=$2
  
  # Check if we're running in Home Assistant environment
  if command -v bashio >/dev/null 2>&1; then
    # We're in Home Assistant, use bashio to get config
    bashio::config "$key" 2>/dev/null || echo "$default_value"
  else
    # We're not in Home Assistant, use environment variable
    eval echo \${$key:-$default_value}
  fi
}

echo "Creating configuration file for CTM Energy Management System..."

# Get configuration values with fallbacks
POSTGRES_HOST=$(get_config POSTGRES_HOST localhost)
POSTGRES_PORT=$(get_config POSTGRES_PORT 5432)
POSTGRES_DB=$(get_config POSTGRES_DB ctm_db)
POSTGRES_USER=$(get_config POSTGRES_USER postgres)
POSTGRES_PASSWORD=$(get_config POSTGRES_PASSWORD password)
TIBBER_API_KEY=$(get_config tibber_api_key "")
TIBBER_API_URL=$(get_config tibber_api_url "https://api.tibber.com/v1-beta/gql")
NODE_ENV=${NODE_ENV:-production}

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
cat /app/.env

echo "Starting CTM Energy Management System..."

bun /app/dist/index.js
