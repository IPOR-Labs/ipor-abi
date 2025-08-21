interface VelodromeSuperchainGaugeClaimFuse {
    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error SafeERC20FailedOperation(address token);
    error VelodromeSuperchainGaugeClaimFuseEmptyArray();
    error VelodromeSuperchainGaugeClaimFuseRewardsClaimManagerZeroAddress();
    error VelodromeSuperchainGaugeClaimFuseUnsupportedGauge(address gauge);

    event VelodromeSuperchainGaugeClaimFuseRewardsClaimed(
        address version, address gauge, address rewardToken, uint256 amount, address rewardsClaimManager
    );

    function MARKET_ID() external view returns (uint256);
    function VERSION() external view returns (address);
    function claim(address[] memory gauges_) external;
}

