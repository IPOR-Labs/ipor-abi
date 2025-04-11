interface FluidInstadappClaimFuse {
    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error FluidInstadappClaimFuseRewardsClaimManagerZeroAddress(address version);
    error SafeERC20FailedOperation(address token);

    event FluidInstadappClaimFuseRewardsClaimed(
        address version, address rewardsToken, uint256 rewardsTokenBalance, address rewardsClaimManager
    );

    function MARKET_ID() external view returns (uint256);
    function VERSION() external view returns (address);
    function claim() external;
}

