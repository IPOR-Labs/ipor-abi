interface AssetChainlinkPriceFeed {
    error MathOverflowedMulDiv();
    error SafeCastOverflowedIntToUint(int256 value);
    error SafeCastOverflowedUintToInt(uint256 value);
    error WrongAddress();

    function ASSET_X() external view returns (address);
    function ASSET_X_ASSET_Y_CHAINLINK_FEED() external view returns (address);
    function ASSET_Y_USD_CHAINLINK_FEED() external view returns (address);
    function decimals() external pure returns (uint8);
    function latestRoundData()
        external
        view
        returns (uint80 roundId, int256 price, uint256 startedAt, uint256 time, uint80 answeredInRound);
}

