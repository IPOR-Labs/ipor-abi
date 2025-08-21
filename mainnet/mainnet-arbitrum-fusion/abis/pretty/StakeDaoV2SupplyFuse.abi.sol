interface StakeDaoV2SupplyFuse {
    struct StakeDaoV2SupplyFuseEnterData {
        address rewardVault;
        uint256 lpTokenUnderlyingAmount;
        uint256 minLpTokenUnderlyingAmount;
    }

    struct StakeDaoV2SupplyFuseExitData {
        address rewardVault;
        uint256 rewardVaultShares;
        uint256 minRewardVaultShares;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error SafeERC20FailedOperation(address token);
    error StakeDaoV2SupplyFuseInsufficientLpTokenUnderlyingAmount(
        uint256 finalLpTokenUnderlyingAmount, uint256 minLpTokenUnderlyingAmount
    );
    error StakeDaoV2SupplyFuseInsufficientRewardVaultShares(
        uint256 finalRewardVaultShares, uint256 minRewardVaultShares
    );
    error StakeDaoV2SupplyFuseUnsupportedRewardVault(string action, address rewardVault);
    error WrongValue();

    event StakeDaoV2SupplyFuseEnter(
        address version,
        address rewardVault,
        uint256 rewardVaultShares,
        uint256 lpTokenAmount,
        uint256 finalLpTokenUnderlyingAmount
    );
    event StakeDaoV2SupplyFuseExit(
        address version,
        address rewardVault,
        uint256 finalRewardVaultShares,
        uint256 lpTokenAmount,
        uint256 lpTokenUnderlyingAmount
    );

    function MARKET_ID() external view returns (uint256);
    function VERSION() external view returns (address);
    function enter(StakeDaoV2SupplyFuseEnterData memory data_) external;
    function exit(StakeDaoV2SupplyFuseExitData memory data_) external;
}

