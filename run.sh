#!/bin/sh
set -e

# Using environment variables directly instead of bashio
# Default values can be specified with ${VAR:-default}
echo "Creating configuration file for CTM Energy Management System..."

# Create .env file for the Node.js application using environment variables
{
  echo "POSTGRES_HOST=${POSTGRES_HOST:-localhost}"
  echo "POSTGRES_PORT=${POSTGRES_PORT:-5432}"
  echo "POSTGRES_DB=${POSTGRES_DB:-ctm_db}"
  echo "POSTGRES_USER=${POSTGRES_USER:-postgres}"
  echo "POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-password}"
  echo "TIBBER_API_KEY=${TIBBER_API_KEY}"
  echo "TIBBER_API_URL=${TIBBER_API_URL:-https://api.tibber.com/v1-beta/gql}"
  echo "NODE_ENV=${NODE_ENV:-production}"
} > /app/.env

# Make sure the configuration is accessible
chmod 644 /app/.env

echo "Starting CTM Energy Management System..."

bun /app/dist/index.js
