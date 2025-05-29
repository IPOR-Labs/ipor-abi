interface EulerV2CollateralFuse {
    struct EulerV2CollateralFuseEnterData {
        address eulerVault;
        bytes1 subAccount;
    }

    struct EulerV2CollateralFuseExitData {
        address eulerVault;
        bytes1 subAccount;
    }

    error EulerV2CollateralFuseUnsupportedEnterAction(address vault, bytes1 subAccount);

    event EulerV2DisableCollateralFuse(address version, address eulerVault, address subAccount);
    event EulerV2EnableCollateralFuse(address version, address eulerVault, address subAccount);

    function EVC() external view returns (address);
    function MARKET_ID() external view returns (uint256);
    function VERSION() external view returns (address);
    function enter(EulerV2CollateralFuseEnterData memory data_) external;
    function exit(EulerV2CollateralFuseExitData memory data_) external;
}

