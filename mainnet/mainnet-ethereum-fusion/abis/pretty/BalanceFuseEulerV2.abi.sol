interface EulerV2BalanceFuse {
    error SafeCastOverflowedIntToUint(int256 value);
    error SafeCastOverflowedUintToInt(uint256 value);
    error UnsupportedQuoteCurrencyFromOracle();
    error WrongAddress();

    function EVC() external view returns (address);
    function MARKET_ID() external view returns (uint256);
    function balanceOf() external view returns (uint256);
}

