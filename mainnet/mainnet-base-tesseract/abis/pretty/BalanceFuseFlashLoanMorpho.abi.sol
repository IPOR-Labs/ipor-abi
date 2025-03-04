interface MorphoBalanceFuse {
    error SafeCastOverflowedIntToUint(int256 value);
    error SafeCastOverflowedUintToInt(uint256 value);

    function MARKET_ID() external view returns (uint256);
    function MORPHO() external view returns (address);
    function balanceOf() external view returns (uint256);
}

