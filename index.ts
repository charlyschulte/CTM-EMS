import { CronJob } from 'cron';
// Import database service
import databaseService from './src/services/database';
import { getTibberPrices } from './src/services/tibberApiService';
import config from './src/config/config';
databaseService.initialize()
    .then(async () => {
        console.log('Database initialized successfully');
        getTibberPrices();
    })
    .catch(error => {
        console.error('Failed to initialize database:', error);
    });