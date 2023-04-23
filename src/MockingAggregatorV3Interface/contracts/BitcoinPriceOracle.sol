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