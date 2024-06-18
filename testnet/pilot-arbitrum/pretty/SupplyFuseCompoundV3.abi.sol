interface CompoundV3SupplyFuse {
    struct CompoundV3SupplyFuseEnterData {
        address asset;
        uint256 amount;
    }

    struct CompoundV3SupplyFuseExitData {
        address asset;
        uint256 amount;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error CompoundV3SupplyFuseUnsupportedAsset(string action, address asset, string errorCode);
    error FailedInnerCall();
    error SafeERC20FailedOperation(address token);

    event CompoundV3SupplyEnterFuse(address version, address asset, address market, uint256 amount);
    event CompoundV3SupplyExitFuse(address version, address asset, address market, uint256 amount);

    function COMET() external view returns (address);
    function COMPOUND_BASE_TOKEN() external view returns (address);
    function MARKET_ID() external view returns (uint256);
    function VERSION() external view returns (address);
    function enter(bytes memory data) external;
    function enter(CompoundV3SupplyFuseEnterData memory data) external;
    function exit(bytes memory data) external;
    function exit(CompoundV3SupplyFuseExitData memory data) external;
    function instantWithdraw(bytes32[] memory params) external;
}

