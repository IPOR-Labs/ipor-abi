interface StakeService {
    function getConfiguration()
        external
        view
        returns (address liquidityMiningAddress, address powerTokenAddress, address governanceTokenAddress);
    function governanceToken() external view returns (address);
    function liquidityMining() external view returns (address);
    function powerToken() external view returns (address);
    function pwTokenCancelCooldown() external;
    function pwTokenCooldown(uint256 pwTokenAmount) external;
    function redeemPwToken(address transferTo) external;
    function stakeGovernanceTokenToPowerToken(address beneficiary, uint256 governanceTokenAmount) external;
    function stakeGovernanceTokenToPowerTokenAndDelegate(
        address beneficiary,
        uint256 governanceTokenAmount,
        address[] memory lpTokens,
        uint256[] memory pwTokenAmounts
    ) external;
    function stakeLpTokensToLiquidityMining(
        address beneficiary,
        address[] memory lpTokens,
        uint256[] memory lpTokenMaxAmounts
    ) external;
    function unstakeGovernanceTokenFromPowerToken(address transferTo, uint256 governanceTokenAmount) external;
    function unstakeLpTokensFromLiquidityMining(
        address transferTo,
        address[] memory lpTokens,
        uint256[] memory lpTokenAmounts
    ) external;
}

