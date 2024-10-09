interface RamsesClaimFuse {
    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error RamsesClaimFuseRewardsClaimManagerNotSet();
    error RamsesClaimFuseTokenIdsAndTokenRewardsLengthMismatch();
    error SafeERC20FailedOperation(address token);

    event RamsesClaimFuseTransferredReward(uint256 tokenId, address token, uint256 reward);

    function NONFUNGIBLE_POSITION_MANAGER() external view returns (address);
    function VERSION() external view returns (address);
    function claim(uint256[] memory tokenIds, address[][] memory tokenRewards) external;
}

