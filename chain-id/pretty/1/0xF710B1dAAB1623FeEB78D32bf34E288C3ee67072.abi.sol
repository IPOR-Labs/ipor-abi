interface GearboxV3FarmDTokenClaimFuse {
    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error GearboxV3FarmDTokenClaimFuseRewardsClaimManagerZeroAddress(address version);
    error SafeERC20FailedOperation(address token);

    event GearboxV3FarmDTokenClaimFuseRewardsClaimed(
        address version, address rewardsToken, uint256 rewardsTokenBalance, address rewardsClaimManager
    );

    function MARKET_ID() external view returns (uint256);
    function VERSION() external view returns (address);
    function claim() external;
}

