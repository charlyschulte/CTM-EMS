import config from "../config/config";
import { ElectricityPrice } from "../models/ElectricityPrice";

export function getTibberPrices() {
    const axios = require('axios');

    const query = `
        query {
            viewer {
                homes {
                    currentSubscription {
                        priceInfo {

          current{
            total
            energy
            tax
            startsAt
          }
          today {
            total
            energy
            tax
            startsAt
          }
          tomorrow {
            total
            energy
            tax
            startsAt
          }
                        }
                    }
                }
            }
        }
    `;

    return axios.post(config.tibberApiUrl, { query }, {
        headers: {
            'Authorization': `Bearer ${config.tibberApiKey}`,
            'Content-Type': 'application/json'
        }
    })
        .then((response: any) => {
            const todayPrices = response.data.data.viewer.homes[0].currentSubscription.priceInfo.today;
            const tomorrowPrices = response.data.data.viewer.homes[0].currentSubscription.priceInfo.tomorrow;
            const allPrices = [...todayPrices, ...tomorrowPrices];
            return storeTibberPrices(allPrices);
        })
        .catch((error: any) => {
            console.error('Error fetching Tibber prices:', error);
            throw error;
        });
}
async function storeAllTibberPrices(prices: any) {
    prices.forEach(async (price: any) => {
        //check if price already exists
        let existingPrice = await ElectricityPrice.findOne({
            where: { startsAt: new Date(price.startsAt) }
        });
        if (existingPrice) {
            console.log('Price already exists, not storing:', price.startsAt);
            return;
        }
        let priceStore = new ElectricityPrice();
        priceStore.startsAt = new Date(price.startsAt);
        priceStore.totalPrice = price.total;
        priceStore.taxPrice = price.tax;
        priceStore.energyPrice = price.energy;
        await priceStore.save();
    });
}
async function storeTibberPrices(prices: { startsAt: string, total: number, tax: number, energy: number }[]) {
    let latestPrice = await ElectricityPrice.findOne({
        where: {},
        order: { startsAt: 'DESC' }
    });
    if (latestPrice !== null && latestPrice?.startsAt) {
        //check if latest price is older than newest prices
        let latestPriceDate = new Date(latestPrice.startsAt);
        let newPriceDate = prices.sort((a, b) => new Date(b.startsAt).getTime() - new Date(a.startsAt).getTime());
        if (latestPriceDate.getTime() >= new Date(newPriceDate[0].startsAt).getTime()) {
            console.log('Latest price is newer than new price, not storing new price');
            return;
        }
        else {
            console.log('Latest price is older than new price, storing new price');
        }
    }
    //store new price
    console.log('Storing new price');
    await storeAllTibberPrices(prices);

}