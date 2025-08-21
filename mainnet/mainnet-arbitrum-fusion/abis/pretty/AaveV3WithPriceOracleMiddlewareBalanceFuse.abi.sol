interface AaveV3WithPriceOracleMiddlewareBalanceFuse {
    error SafeCastOverflowedIntToUint(int256 value);
    error UnsupportedQuoteCurrencyFromOracle();
    error WrongAddress();
    error WrongValue();

    function AAVE_V3_POOL_ADDRESSES_PROVIDER() external view returns (address);
    function MARKET_ID() external view returns (uint256);
    function balanceOf() external view returns (uint256);
}

