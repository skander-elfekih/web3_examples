# Mocking AggregatorV3Interface in Solidity: A Step-by-Step Guide
When developing smart contracts on the Ethereum blockchain, it is important to thoroughly test your code to ensure its functionality and security. One of the challenges of testing smart contracts is that they rely on external data sources, such as price feeds, for certain functionality. In order to test this functionality, it is necessary to use mock data instead of the real data from the external source.

This article will focus on mocking the AggregatorV3Interface, which is a popular interface used for accessing price feeds from the Chainlink oracle network. We will provide a step-by-step guide for creating a mock of this interface in Solidity, allowing you to test your smart contracts without relying on a live price feed.

##  Presentation of AggregatorV3Interface
AggregatorV3Interface is an interface provided by Chainlink for accessing price feeds from the oracle network. It provides several functions for retrieving price data, including the latest price, the timestamp of the latest price, and the number of decimals for the price.

The importance of AggregatorV3Interface in smart contract development is evident in its widespread use. Many decentralized applications rely on price feeds for their functionality, such as decentralized exchanges or prediction markets. These applications require accurate and reliable price data, making it essential to thoroughly test their interactions with AggregatorV3Interface.

However, using real data from AggregatorV3Interface in testing can be difficult, as it requires a live connection to the Chainlink oracle network. Additionally, relying on live data can introduce unpredictability into the testing process. To address these issues, we can use mock data instead of real data in our tests.

##  Implementation of the AggregatorV3Interface mock

To mock AggregatorV3Interface, we will create a Solidity contract that implements the same functions as the interface. This mock contract will simulate the behavior of AggregatorV3Interface, allowing us to test our smart contracts without relying on a live connection to the Chainlink oracle network.

Here is an example of how we can implement the AggregatorV3Interface mock in Solidity:

```Solidity

contract MockAggregatorV3Interface is AggregatorV3Interface {
    int private _answer;
    uint private _timestamp;
    uint private _roundId;
    uint8 private _decimals;
    
    constructor(int answer, uint timestamp, uint roundId, uint8 decimals) {
        _answer = answer;
        _timestamp = timestamp;
        _roundId = roundId;
        _decimals = decimals;
    }
    
    function latestRoundData() external view returns (uint80, int256, uint256, uint256, uint80) {
        return (uint80(_roundId), _answer, _timestamp, _timestamp, uint80(_roundId));
    }    
    function getRoundData(uint80 _roundId) external view returns (uint80, int256, uint256, uint256, uint80) {
        require(_roundId == uint80(_roundId), "roundId out of range");
        return (uint80(_roundId), _answer, _timestamp, _timestamp, uint80(_roundId));
    }
    function description() external view returns (string memory) {
        return "Mock AggregatorV3 Interface";
    }
    function version() external view returns (uint256) {
        return 1;
    }
    function decimals() external view returns (uint8) {
        return _decimals;
    }
    function latestAnswer() external view returns (int256) {
        return _answer;
    }
    function latestTimestamp() external view returns (uint256) {
        return _timestamp;
    }
    function latestRound() external view returns (uint256) {
        return _roundId;
    }
}
``` 

In this example, we have created a contract called "MockAggregatorV3Interface" that implements the AggregatorV3Interface functions we want to mock. The constructor takes four parameters: the latest price, the timestamp of the latest price, the latest round ID, and the number of decimals for the price.

The "latestRoundData" and "getRoundData" functions return the same values as the AggregatorV3Interface functions of the same names, but instead of retrieving data from the oracle network, they return the values that were passed to the constructor.

The "description", "version", "decimals", "latestAnswer", "latestTimestamp", and "latestRound" functions all return fixed values that do not change. These functions are used by smart contracts to get information about the price feed, and by returning fixed values we can ensure that our tests are consistent and predictable.

##  Testing the mock

Now that we have created the AggregatorV3Interface mock, we can use it to test our smart contracts that rely on price feeds. In this chapter, we will discuss how to test the mock using a simple Solidity contract.

We will use a simple Solidity contract as an example, which we will call BitcoinPriceOracle.
Here's how we define the BitcoinPriceOracle function:
```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract BitcoinPriceOracle {
    AggregatorV3Interface internal priceFeed;
    address internal oracleAddress;
    constructor(address _oracleAddress) {
        oracleAddress = _oracleAddress;
        priceFeed = AggregatorV3Interface(_oracleAddress);
    }
    function getOracleAddress() public view returns (address) {
        return oracleAddress;
    }
    function getDescription() public view returns (string memory) {
        return priceFeed.description();
    }
    /**
     * Returns the latest price.
     */
    function getLatestPrice() public view returns (int) {
        
        (
        uint80 roundId,
        int price,
        uint startedAt,
        uint updatedAt,
        uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return price;
    }
}

```

In this example, we have defined the BitcoinPriceOracle contract to use the AggregatorV3Interface mock we created earlier. We pass the address of the mock as a parameter to the constructor, and use it to set the "priceFeed" variable. The "getOracleAddress" and "getDescription" functions return the oracle's address and description respectively. The "getLatestPrice" function returns the latest price from the oracle.

To test the BitcoinPriceOracle contract, we will use the Truffle framework. Truffle provides a suite of testing tools, including the ability to run automated tests against a local blockchain.

Here's an example test case for the BitcoinPriceOracle contract:

```
contract BitcoinPriceOracleTest {
    BitcoinPriceOracle internal priceOracle;   
    constructor(BitcoinPriceOracle _priceOracle) {
        priceOracle = _priceOracle;
    }   
    function testGetLatestPrice() public {
        int expectedPrice = 60000;
        int actualPrice = priceOracle.getLatestPrice();
        Assert.equal(actualPrice, expectedPrice, "Price should match expected value");
    }
}
``` 
We will use the "deployContracts" function in our deployment script to deploy the mock AggregatorV3Interface and the BitcoinPriceOracle contract. We will then test the "getLatestPrice" function of the BitcoinPriceOracle contract to ensure that it returns the expected value.

Here is our deployment script:

```
const BitcoinPriceOracle = artifacts.require("BitcoinPriceOracle");  
const MockV3Aggregator = artifacts.require("MockAggregatorV3Interface");  
const HDWalletProvider = require('@truffle/hdwallet-provider');  
  
async function deployContracts(deployer, network) {  
let provider;  
let BtcPriceOracleAdress;  
let commissionAddress;  
  
if(network==='development'){  
provider = new HDWalletProvider('hour update hungry bacon figure polar link find jungle victory million rich', 'http://localhost:8545');  
await deployer.deploy(MockV3Aggregator, 60000, 5000, 1, 8, { from: provider.getAddress(), gas: 600000 , gasPrice: 20000000000 });  
BtcPriceOracleAdress = MockV3Aggregator.address;  
}  
  
await deployer.deploy(BitcoinPriceOracle,BtcPriceOracleAdress, { from: provider.getAddress(), gas: 1000000 , gasPrice: 20000000000 });  
  
}  
  
module.exports = deployContracts;
``` 
We have deployed the mock AggregatorV3Interface using the "deployer.deploy(MockV3Aggregator)" function, passing in the latest price, timestamp, round ID, and decimals. We have then deployed the BitcoinPriceOracle contract using the "deployer.deploy(BitcoinPriceOracle, MockV3Aggregator.address)" function, passing in the address of the mock AggregatorV3Interface.

By using the mock AggregatorV3Interface in our tests and deploying it alongside our contracts, we can ensure that our tests are predictable and consistent, even if the real price feed changes over time.

# Prerequisites and tests

Before executing the tests for the mock AggregatorV3Interface, there are a few rerequisites that must be installed on your system.

Firstly, you will need to install Truffle, a development framework for Ethereum, by running the command :
``` 
npm install -g truffle. 
``` 
Additionally, you will need to install Ganache CLI, a command-line version of the Ganache blockchain emulator, by running the command :
``` 
npm install -g ganache-cli. 
``` 
Finally, you will need to install the HDWalletProvider library by running the command :
``` 
npm install @truffle/hdwallet-provider. 
``` 
These commands will ensure that your environment is set up correctly and that the tests are run against a local blockchain.

Once you have the prerequisites installed, you can run the tests by starting a local blockchain with Ganache CLI using the following command:

`ganache-cli -p 8545 --mnemonic "screen modify believe maze clerk kidney patient have attack rent head hurdle"`

After that, you can compile your contracts using the following command:
`truffle compile`

And then deploy the contracts to the local blockchain:
`truffle migrate --network development`

Finally, you can run the tests using the following command:
`truffle test`

## Conclusion : Let's Mock It Up!

So, if you've got a technique for mocking in Solidity that you think is even better, share it with the community! Let's continue to explore different ways to mock external contracts and enhance our smart contract testing.

Until then, happy mocking!

_For more information on Solidity and smart contract testing, check out the official Solidity documentation and the OpenZeppelin smart contract library :_
-   [Chainlink Documentation](https://docs.chain.link/)
-   [Chainlink Price Feeds Documentation](https://docs.chain.link/docs/get-the-latest-price/)