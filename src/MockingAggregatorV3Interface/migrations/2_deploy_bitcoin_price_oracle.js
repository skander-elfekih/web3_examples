const BitcoinPriceOracle = artifacts.require("BitcoinPriceOracle");
const MockV3Aggregator = artifacts.require("MockAggregatorV3Interface");
const HDWalletProvider = require('@truffle/hdwallet-provider');

async function deployContracts(deployer, network) {
    let provider;
    let BtcPriceOracleAdress;
    let commissionAddress;

    if(network==='development'){
        provider = new HDWalletProvider('screen modify believe maze clerk kidney patient have attack rent head hurdle', 'http://localhost:8545');
        await deployer.deploy(MockV3Aggregator, 60000, 5000, 1, 8, { from: provider.getAddress(), gas: 600000 , gasPrice: 20000000000 });
        BtcPriceOracleAdress = MockV3Aggregator.address;
    }
    
    await deployer.deploy(BitcoinPriceOracle,BtcPriceOracleAdress, { from: provider.getAddress(), gas: 1000000 , gasPrice: 20000000000 });
    
}

module.exports = deployContracts;