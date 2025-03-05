interface MoonwellSupplyFuse {
    struct MoonwellSupplyFuseEnterData {
        address asset;
        uint256 amount;
    }

    struct MoonwellSupplyFuseExitData {
        address asset;
        uint256 amount;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error MoonwellSupplyFuseMintFailed();
    error MoonwellSupplyFuseUnsupportedAsset(address asset);
    error SafeERC20FailedOperation(address token);

    event MoonwellSupplyEnterFuse(address version, address asset, address market, uint256 amount);
    event MoonwellSupplyExitFailed(address version, address asset, address market, uint256 amount);
    event MoonwellSupplyExitFuse(address version, address asset, address market, uint256 amount);

    function MARKET_ID() external view returns (uint256);
    function VERSION() external view returns (address);
    function enter(MoonwellSupplyFuseEnterData memory data_) external;
    function exit(MoonwellSupplyFuseExitData memory data_) external;
    function instantWithdraw(bytes32[] memory params_) external;
}

