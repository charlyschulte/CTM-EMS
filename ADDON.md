# Home Assistant Add-on: CTM Energy Management System

## Overview

CTM-EMS is an Energy Management System that integrates with the Tibber API to fetch and store electricity prices. It helps optimize battery usage based on electricity pricing.

## Installation

1. Navigate to your Home Assistant instance
2. Go to Settings → Add-ons → Add-on Store
3. Click on the menu in the top right corner (three dots)
4. Select "Repositories"
5. Add the URL: `https://github.com/charlyschulte/CTM-EMS`
6. Click "Add"
7. Find and install the "CTM Energy Management System" add-on
8. Configure your Tibber API key
9. Start the add-on

## Configuration

### Required Options

| Option | Description |
|--------|-------------|
| `tibber_api_key` | Your Tibber API key |

### Optional Options

| Option | Description | Default |
|--------|-------------|---------|
| `tibber_api_url` | The Tibber API URL | https://api.tibber.com/v1-beta/gql |

## How to use

After starting the add-on, it will automatically fetch electricity prices from the Tibber API and store them in its database.

## Support

If you need assistance or want to report issues, please open an issue on the GitHub repository.
