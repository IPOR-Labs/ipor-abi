interface SrUsdPriceFeedEthereum {
    error InvalidSavingModule();
    error SafeCastOverflowedUintToInt(uint256 value);

    function SAVING_MODULE() external view returns (address);
    function decimals() external view returns (uint8);
    function latestRoundData()
        external
        view
        returns (uint80 roundId, int256 price, uint256 startedAt, uint256 time, uint80 answeredInRound);
}

