interface MoonwellClaimFuse {
    struct MoonwellClaimFuseData {
        address[] mTokens;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error MoonwellClaimFuseEmptyArray();
    error MoonwellClaimFuseRewardDistributorZeroAddress();
    error MoonwellClaimFuseRewardsClaimManagerZeroAddress();
    error SafeERC20FailedOperation(address token);

    event MoonwellClaimFuseRewardsClaimed(
        address version, address rewardToken, uint256 amount, address rewardsClaimManager
    );

    function COMPTROLLER() external view returns (address);
    function MARKET_ID() external view returns (uint256);
    function VERSION() external view returns (address);
    function claim(MoonwellClaimFuseData memory data_) external;
}

