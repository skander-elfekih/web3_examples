// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

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
    function description() external view override returns (string memory) {
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