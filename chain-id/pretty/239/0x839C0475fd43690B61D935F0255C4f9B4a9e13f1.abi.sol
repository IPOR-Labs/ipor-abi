interface TacStakingBalanceFuse {
    error TacStakingBalanceFuseInvalidPriceOracleMiddleware();
    error TacStakingBalanceFuseInvalidStakingAddress();
    error TacStakingBalanceFuseInvalidSubstrateLength();
    error TacStakingBalanceFuseInvalidWtacAddress();

    function MARKET_ID() external view returns (uint256);
    function STAKING() external view returns (address);
    function W_TAC() external view returns (address);
    function balanceOf() external view returns (uint256 balanceInUSD);
}

