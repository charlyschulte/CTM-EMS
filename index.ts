import { CronJob } from 'cron';
// Import database service
import databaseService from './src/services/database';
import { getTibberPrices } from './src/services/tibberApiService';
import config from './src/config/config';

databaseService.initialize()
    .then(async () => {
        console.log('Database initialized successfully');

        // Create a cron job to run getTibberPrices every hour
        const tibberPriceJob = new CronJob(
            '0 * * * *', // Cron pattern for running every hour at minute 0
            function () {
                console.log('Running scheduled Tibber price update...');
                getTibberPrices();
            },
            null, // onComplete
            true, // start immediately
            'UTC' // timezone
        );

        console.log('Cron job scheduled for Tibber price updates');

        // Run once immediately upon startup
        getTibberPrices();
    })
    .catch(error => {
        console.error('Failed to initialize database:', error);
    });