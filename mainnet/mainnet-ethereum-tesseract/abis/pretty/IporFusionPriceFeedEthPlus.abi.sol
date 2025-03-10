interface EthPlusPriceFeed {
    error InvalidPrice();
    error SafeCastOverflowedUintToInt(uint256 value);

    function ETH_PLUS_ORACLE() external view returns (address);
    function decimals() external pure returns (uint8);
    function latestRoundData()
        external
        view
        returns (uint80 roundId, int256 price, uint256 startedAt, uint256 time, uint80 answeredInRound);
}

