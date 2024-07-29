interface AaveV3SupplyFuse {
    struct AaveV3SupplyFuseEnterData {
        address asset;
        uint256 amount;
        uint256 userEModeCategoryId;
    }

    struct AaveV3SupplyFuseExitData {
        address asset;
        uint256 amount;
    }

    error AaveV3SupplyFuseUnsupportedAsset(string action, address asset);
    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error SafeCastOverflowedUintDowncast(uint8 bits, uint256 value);
    error SafeERC20FailedOperation(address token);

    event AaveV3SupplyEnterFuse(address version, address asset, uint256 amount, uint256 userEModeCategoryId);
    event AaveV3SupplyExitFailed(address version, address asset, uint256 amount);
    event AaveV3SupplyExitFuse(address version, address asset, uint256 amount);

    function AAVE_POOL() external view returns (address);
    function AAVE_POOL_DATA_PROVIDER_V3() external view returns (address);
    function MARKET_ID() external view returns (uint256);
    function VERSION() external view returns (address);
    function enter(AaveV3SupplyFuseEnterData memory data_) external;
    function enter(bytes memory data_) external;
    function exit(bytes memory data_) external;
    function exit(AaveV3SupplyFuseExitData memory data_) external;
    function instantWithdraw(bytes32[] memory params_) external;
}

