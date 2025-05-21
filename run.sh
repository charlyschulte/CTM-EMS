#!/usr/bin/with-contenv bashio

# Get config values
export TIBBER_API_KEY=$(bashio::config 'tibber_api_key')
export TIBBER_API_URL=$(bashio::config 'tibber_api_url')

# Make sure our database is in the persistent data directory
if [ ! -d "/data/sqlite" ]; then
  mkdir -p /data/sqlite
fi

# Copy database to data directory if it doesn't exist
if [ ! -f "/data/sqlite/electricity_prices.sqlite" ] && [ -f "/app/data/electricity_prices.sqlite" ]; then
  cp /app/data/electricity_prices.sqlite /data/sqlite/
fi

# Set database path in environment
export DB_PATH="/data/sqlite/electricity_prices.sqlite"

# Print info
bashio::log.info "Starting CTM Energy Management System..."
bashio::log.info "Database path: $DB_PATH"

# Start the application
cd /app
bashio::log.info "Running the application..."
node dist/index.js
