interface LiquityBalanceFuse {
    error InvalidMarketId();

    function MARKET_ID() external view returns (uint256);
    function balanceOf() external view returns (uint256);
}

