interface AaveV3BorrowFuse {
    struct AaveV3BorrowFuseEnterData {
        address asset;
        uint256 amount;
    }

    struct AaveV3BorrowFuseExitData {
        address asset;
        uint256 amount;
    }

    error AaveV3BorrowFuseUnsupportedAsset(string action, address asset);
    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error SafeERC20FailedOperation(address token);
    error WrongAddress();

    event AaveV3BorrowFuseEnter(address version, address asset, uint256 amount, uint256 interestRateMode);
    event AaveV3BorrowFuseExit(address version, address asset, uint256 repaidAmount, uint256 interestRateMode);

    function AAVE_V3_POOL_ADDRESSES_PROVIDER() external view returns (address);
    function INTEREST_RATE_MODE() external view returns (uint256);
    function MARKET_ID() external view returns (uint256);
    function VERSION() external view returns (address);
    function enter(AaveV3BorrowFuseEnterData memory data_) external;
    function exit(AaveV3BorrowFuseExitData memory data_) external;
}

