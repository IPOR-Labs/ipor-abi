interface MorphoClaimFuse {
    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error MorphoClaimFuseRewardsClaimManagerZeroAddress(address version);
    error MorphoClaimFuseUniversalRewardsDistributorZeroAddress(address version);
    error MorphoClaimFuseUnsupportedDistributor(address distributor);
    error SafeERC20FailedOperation(address token);

    event MorphoClaimFuseRewardsClaimed(
        address version, address rewardsToken, uint256 rewardsTokenAmount, address rewardsClaimManager
    );

    function MARKET_ID() external view returns (uint256);
    function VERSION() external view returns (address);
    function claim(address universalRewardsDistributor, address rewardsToken, uint256 claimable, bytes32[] memory proof)
        external;
}

