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
    error WrongAddress();
    error WrongValue();

    event AaveV3SupplyFuseEnter(address version, address asset, uint256 amount, uint256 userEModeCategoryId);
    event AaveV3SupplyFuseExit(address version, address asset, uint256 amount);
    event AaveV3SupplyFuseExitFailed(address version, address asset, uint256 amount);

    function AAVE_V3_POOL_ADDRESSES_PROVIDER() external view returns (address);
    function MARKET_ID() external view returns (uint256);
    function VERSION() external view returns (address);
    function enter(AaveV3SupplyFuseEnterData memory data_) external;
    function exit(AaveV3SupplyFuseExitData memory data_) external;
    function instantWithdraw(bytes32[] memory params_) external;
}

