# Battery Charge/Discharge Optimization System

This application optimizes when to charge and discharge your battery based on electricity price forecasts. It analyzes real-time or forecasted electricity prices to determine the most cost-effective times to charge your battery and the most profitable times to discharge it.

## Features

- Fetches and analyzes electricity price forecasts
- Monitors battery status
- Calculates optimal charge and discharge schedules
- Schedules hourly optimization runs
- Provides RESTful API endpoints for accessing data and schedules
- Configurable through environment variables

## Installation

```bash
# Clone the repository
git clone <repository-url>
cd CTM-EMS

# Install dependencies
bun install
```

## Configuration

Create a `.env` file in the root directory with the following variables:

```
# Location information
LOCATION=Berlin,DE

# Battery parameters
BATTERY_LOSS_PERCENTAGE=5.0

# Tibber API configuration
TIBBER_API_KEY=your_tibber_api_key_here
TIBBER_API_URL=https://api.tibber.com/v1-beta/gql

# Battery API configuration
BATTERY_API_BASE_URL=http://localhost:3000/api
```

## Usage

```bash
# Start the application
bun run index.ts
```

The application will:
1. Start an API server on port 3000
2. Run an initial optimization for the next 24 hours
3. Schedule hourly optimization runs

## API Endpoints

- `GET /api/optimize` - Get optimization schedule
  - Query params: `hours` (optional, default: 24)

- `GET /api/prices` - Get electricity price forecasts
  - Query params: `hours` (optional, default: 24)

- `GET /api/battery` - Get current battery status

## Project Structure

```
CTM-EMS/
├── .env                        # Environment variables
├── index.ts                    # Application entry point
├── package.json                # Project metadata and dependencies
├── tsconfig.json               # TypeScript configuration
└── src/
    ├── config/
    │   └── config.ts           # Configuration management
    ├── models/
    │   └── ...                 # Data models and interfaces
    ├── services/
    │   ├── apiService.ts       # API endpoints
    │   ├── batteryService.ts   # Battery management
    │   ├── electricityPriceService.ts  # Price forecast
    │   └── optimizationService.ts      # Optimization logic
    └── utils/
        └── ...                 # Utility functions
```

## Extending the Application

### Adding a New Service

1. Create a new service file in `src/services/`
2. Implement your service logic
3. Update existing services to use your new service if needed

### Customizing the Optimization Logic

Modify `src/services/optimizationService.ts` to implement your own optimization algorithms.

### Using the Tibber API

Replace the mock methods in `electricityPriceService.ts` with actual API calls to your Tibber account by providing a valid API key in the `.env` file.

This project was created using `bun` as the JavaScript runtime. [Bun](https://bun.sh) is a fast all-in-one JavaScript runtime.
