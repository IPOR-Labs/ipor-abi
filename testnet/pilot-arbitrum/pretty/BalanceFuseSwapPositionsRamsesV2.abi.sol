interface RamsesV2Balance {
    error MathOverflowedMulDiv();
    error SafeCastOverflowedIntToUint(int256 value);

    function MARKET_ID() external view returns (uint256);
    function NONFUNGIBLE_POSITION_MANAGER() external view returns (address);
    function RAMSES_FACTORY() external view returns (address);
    function balanceOf() external view returns (uint256);
}

