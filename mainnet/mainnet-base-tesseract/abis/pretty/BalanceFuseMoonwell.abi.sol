interface MoonwellBalanceFuse {
    error MoonwellBalanceFuseInvalidPrice();
    error SafeCastOverflowedIntToUint(int256 value);
    error SafeCastOverflowedUintToInt(uint256 value);

    function MARKET_ID() external view returns (uint256);
    function balanceOf() external returns (uint256);
    function balanceOf(bytes32[] memory substrates_, address plasmaVault_) external returns (uint256);
}

