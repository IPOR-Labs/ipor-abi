interface MoonwellBorrowFuse {
    struct MoonwellBorrowFuseEnterData {
        address asset;
        uint256 amount;
    }

    struct MoonwellBorrowFuseExitData {
        address asset;
        uint256 amount;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error MoonwellBorrowFuseBorrowFailed();
    error MoonwellBorrowFuseNoAssetsFound();
    error MoonwellBorrowFuseRepayFailed();
    error MoonwellBorrowFuseUnsupportedAsset(address asset);
    error MoonwellSupplyFuseUnsupportedAsset(address asset);
    error SafeERC20FailedOperation(address token);

    event MoonwellBorrowEntered(address version, address asset, address market, uint256 amount);
    event MoonwellBorrowExited(address version, address asset, address market, uint256 amount);

    function MARKET_ID() external view returns (uint256);
    function VERSION() external view returns (address);
    function enter(MoonwellBorrowFuseEnterData memory data_) external;
    function exit(MoonwellBorrowFuseExitData memory data_) external;
}

