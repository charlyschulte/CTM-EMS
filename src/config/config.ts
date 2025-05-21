import dotenv from 'dotenv';

// Load environment variables from .env file
dotenv.config();

export class Config {
  private static instance: Config;
  
  // Location information
  private _location: string;
  
  // Battery parameters
  private _batteryLossPercentage: number;
  
  // Tibber API configuration
  private _tibberApiKey: string;
  private _tibberApiUrl: string;
  
  // Battery API configuration
  private _batteryApiBaseUrl: string;
  
  private constructor() {
    this._location = process.env.LOCATION || 'Berlin,DE';
    this._batteryLossPercentage = parseFloat(process.env.BATTERY_LOSS_PERCENTAGE || '5.0');
    this._tibberApiKey = process.env.TIBBER_API_KEY || '';
    this._tibberApiUrl = process.env.TIBBER_API_URL || 'https://api.tibber.com/v1-beta/gql';
    this._batteryApiBaseUrl = process.env.BATTERY_API_BASE_URL || 'http://localhost:3000/api';
  }
  
  public static getInstance(): Config {
    if (!Config.instance) {
      Config.instance = new Config();
    }
    return Config.instance;
  }
  
  get location(): string {
    return this._location;
  }
  
  get batteryLossPercentage(): number {
    return this._batteryLossPercentage;
  }
  
  get tibberApiKey(): string {
    return this._tibberApiKey;
  }
  
  get tibberApiUrl(): string {
    return this._tibberApiUrl;
  }
  
  get batteryApiBaseUrl(): string {
    return this._batteryApiBaseUrl;
  }
}

export default Config.getInstance();
