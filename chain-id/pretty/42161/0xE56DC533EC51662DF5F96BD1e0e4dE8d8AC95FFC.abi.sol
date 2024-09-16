interface FlowsService {
    function claimRewardsFromLiquidityMining(address[] memory lpTokens) external;
    function delegatePwTokensToLiquidityMining(address[] memory lpTokens, uint256[] memory pwTokenAmounts) external;
    function getConfiguration() external view returns (address, address, address);
    function governanceToken() external view returns (address);
    function liquidityMining() external view returns (address);
    function powerToken() external view returns (address);
    function undelegatePwTokensFromLiquidityMining(address[] memory lpTokens, uint256[] memory pwTokenAmounts)
        external;
    function updateIndicatorsInLiquidityMining(address account, address[] memory lpTokens) external;
}

