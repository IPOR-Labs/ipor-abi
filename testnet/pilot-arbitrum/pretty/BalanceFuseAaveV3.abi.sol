interface AaveV3BalanceFuse {
    error SafeCastOverflowedIntToUint(int256 value);
    error UnsupportedBaseCurrencyFromOracle();

    function AAVE_POOL_DATA_PROVIDER_V3() external view returns (address);
    function AAVE_PRICE_ORACLE() external view returns (address);
    function MARKET_ID() external view returns (uint256);
    function balanceOf(address plasmaVault_) external view returns (uint256);
}

