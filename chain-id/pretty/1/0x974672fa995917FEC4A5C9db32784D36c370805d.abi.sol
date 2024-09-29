interface SDaiPriceFeedEthereum {
    error MathOverflowedMulDiv();
    error SafeCastOverflowedIntToUint(int256 value);
    error SafeCastOverflowedUintToInt(uint256 value);
    error WrongDecimals();

    function DAI_CHAINLINK_FEED() external view returns (address);
    function SDAI() external view returns (address);
    function decimals() external view returns (uint8);
    function latestRoundData()
        external
        view
        returns (uint80 roundId, int256 price, uint256 startedAt, uint256 time, uint80 answeredInRound);
}

