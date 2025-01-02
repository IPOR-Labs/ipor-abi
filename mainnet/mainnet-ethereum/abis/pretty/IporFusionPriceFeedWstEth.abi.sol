interface WstETHPriceFeedEthereum {
    error MathOverflowedMulDiv();
    error SafeCastOverflowedIntToUint(int256 value);
    error SafeCastOverflowedUintToInt(uint256 value);
    error WrongDecimals();

    function ST_ETH_CHAINLINK_FEED() external view returns (address);
    function WST_ETH() external view returns (address);
    function decimals() external pure returns (uint8);
    function latestRoundData()
        external
        view
        returns (uint80 roundId, int256 price, uint256 startedAt, uint256 time, uint80 answeredInRound);
}

