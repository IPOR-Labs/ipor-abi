interface VelodromeSuperchainBalanceFuse {
    error InvalidPool();

    function MARKET_ID() external view returns (uint256);
    function balanceOf() external view returns (uint256);
}

