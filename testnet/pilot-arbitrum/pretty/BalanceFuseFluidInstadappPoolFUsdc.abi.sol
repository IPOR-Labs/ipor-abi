interface ERC4626BalanceFuse {
    function MARKET_ID() external view returns (uint256);
    function PRICE_ORACLE() external view returns (address);
    function balanceOf(address plasmaVault_) external view returns (uint256);
}

