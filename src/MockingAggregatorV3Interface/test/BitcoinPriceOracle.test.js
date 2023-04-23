const BitcoinPriceOracle = artifacts.require("BitcoinPriceOracle");
const Assert = require('assert')

contract("BitcoinPriceOracle", () => {
    let instance;

    before(async () => {
        instance = await BitcoinPriceOracle.deployed();
    });

    it("should get the correct price", async () => {
        const actualPrice = await instance.getLatestPrice();
        const expectedPrice = 60000;
        Assert.equal(actualPrice, expectedPrice, "Price ("+actualPrice+") should match expected value ("+expectedPrice+")");
    });

});