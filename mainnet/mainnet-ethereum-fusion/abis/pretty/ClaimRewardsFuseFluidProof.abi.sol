interface FluidProofClaimFuse {
    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error FluidProofClaimFuseDistributorZeroAddress(address version);
    error FluidProofClaimFuseRewardsClaimManagerZeroAddress(address version);
    error FluidProofClaimFuseRewardsTokenZeroAddress(address version);
    error FluidProofClaimFuseUnsupportedDistributor(address distributor);
    error SafeERC20FailedOperation(address token);

    event FluidProofClaimFuseRewardsClaimed(
        address version, address rewardsToken, uint256 rewardsTokenAmount, address rewardsClaimManager, uint256 cycle
    );

    function MARKET_ID() external view returns (uint256);
    function VERSION() external view returns (address);
    function claim(
        address distributor_,
        uint256 cumulativeAmount_,
        uint8 positionType_,
        bytes32 positionId_,
        uint256 cycle_,
        bytes32[] memory merkleProof_,
        bytes memory metadata_
    ) external;
}

