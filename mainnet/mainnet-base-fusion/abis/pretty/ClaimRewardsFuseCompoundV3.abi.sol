interface CompoundV3ClaimFuse {
    error ClaimManagerZeroAddress();
    error CometRewardsZeroAddress();

    event CompoundV3ClaimFuseRewardsClaimed(address version, address comet, address rewardsClaimManager);

    function COMET_REWARDS() external view returns (address);
    function VERSION() external view returns (address);
    function claim(address comet_) external;
}

