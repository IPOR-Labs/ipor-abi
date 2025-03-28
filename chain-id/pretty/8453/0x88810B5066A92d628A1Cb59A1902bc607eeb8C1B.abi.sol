interface CompoundV3BalanceFuse {
    error SafeCastOverflowedIntToUint(int256 value);
    error SafeCastOverflowedUintToInt(uint256 value);

    function BASE_TOKEN_PRICE_FEED() external view returns (address);
    function COMET() external view returns (address);
    function COMPOUND_BASE_TOKEN() external view returns (address);
    function COMPOUND_BASE_TOKEN_DECIMALS() external view returns (uint256);
    function MARKET_ID() external view returns (uint256);
    function balanceOf() external view returns (uint256);
}

