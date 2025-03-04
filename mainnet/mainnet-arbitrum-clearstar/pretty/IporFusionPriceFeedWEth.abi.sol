interface WETHPriceFeed {
    error InvalidDecimals();
    error InvalidPrice();
    error StalePrice();
    error ZeroAddress();

    event PriceFeedInitialized(address indexed chainlinkFeed);

    function ETH_USD_CHAINLINK_FEED() external view returns (address);
    function decimals() external pure returns (uint8);
    function latestRoundData()
        external
        view
        returns (uint80 roundId, int256 price, uint256 startedAt, uint256 time, uint80 answeredInRound);
}

