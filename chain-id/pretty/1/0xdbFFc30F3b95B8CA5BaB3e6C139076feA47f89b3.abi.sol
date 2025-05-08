interface ERC4626PriceFeed {
    error SafeCastOverflowedUintToInt(uint256 value);

    function decimals() external pure returns (uint8);
    function latestRoundData()
        external
        view
        returns (uint80 roundId, int256 price, uint256 startedAt, uint256 time, uint80 answeredInRound);
    function vault() external view returns (address);
}

