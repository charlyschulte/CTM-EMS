// filepath: /Users/charlyschulte/Documents/Work/Dev/NodeJs/CTM-EMS/src/services/database.ts

import { DataSource } from 'typeorm';
import { ElectricityPrice } from '../models/ElectricityPrice';
import 'reflect-metadata';
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

/**
 * DatabaseService is a singleton class that provides a connection to the PostgreSQL database
 */
class DatabaseService {
    private static instance: DatabaseService;
    private dataSource: DataSource;
    private initialized: boolean = false;

    private constructor() {
        this.dataSource = new DataSource({
            type: "postgres",
            host: process.env.POSTGRES_HOST || 'localhost',
            port: parseInt(process.env.POSTGRES_PORT || '5432'),
            username: process.env.POSTGRES_USER || 'postgres',
            password: process.env.POSTGRES_PASSWORD || 'postgres',
            database: process.env.POSTGRES_DB || 'electricity_db',
            entities: [ElectricityPrice],
            synchronize: true,
            logging: ["error", "warn"],
            ssl: process.env.POSTGRES_SSL === 'true' ? true : false
        });
    }

    public static getInstance(): DatabaseService {
        if (!DatabaseService.instance) {
            DatabaseService.instance = new DatabaseService();
        }
        return DatabaseService.instance;
    }

    /**
     * Initializes the database connection
     * @returns Promise that resolves when the connection is established
     */
    public async initialize(): Promise<void> {
        if (!this.initialized) {
            try {
                await this.dataSource.initialize();
                this.initialized = true;
                console.log("Database connection established successfully");
            } catch (error) {
                console.error("Error during database initialization:", error);
                throw error;
            }
        }
    }

    /**
     * Gets the DataSource instance
     * @returns The TypeORM DataSource instance
     */
    public getDataSource(): DataSource {
        return this.dataSource;
    }

    /**
     * Checks if the database connection has been initialized
     * @returns boolean indicating if the database is initialized
     */
    public isInitialized(): boolean {
        return this.initialized;
    }
}

// Export as a singleton
const databaseService = DatabaseService.getInstance();
export default databaseService;