interface VelodromeSuperchainSlipstreamGaugeClaimFuse {
    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error SafeERC20FailedOperation(address token);
    error VelodromeSuperchainSlipstreamGaugeClaimFuseEmptyArray();
    error VelodromeSuperchainSlipstreamGaugeClaimFuseRewardsClaimManagerZeroAddress();
    error VelodromeSuperchainSlipstreamGaugeClaimFuseUnsupportedGauge(address gauge);

    event VelodromeSuperchainSlipstreamGaugeClaimFuseRewardsClaimed(
        address version, address gauge, address rewardToken, uint256 amount, address rewardsClaimManager
    );

    function MARKET_ID() external view returns (uint256);
    function VERSION() external view returns (address);
    function claim(address[] memory gauges_) external;
}

