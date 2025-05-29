interface EulerV2ControllerFuse {
    struct EulerV2ControllerFuseEnterData {
        address eulerVault;
        bytes1 subAccount;
    }

    struct EulerV2ControllerFuseExitData {
        address eulerVault;
        bytes1 subAccount;
    }

    error EulerV2ControllerFuseUnsupportedEnterAction(address vault, bytes1 subAccount);

    event EulerV2DisableControllerFuse(address version, address eulerVault, address subAccount);
    event EulerV2EnableControllerFuse(address version, address eulerVault, address subAccount);

    function EVC() external view returns (address);
    function MARKET_ID() external view returns (uint256);
    function VERSION() external view returns (address);
    function enter(EulerV2ControllerFuseEnterData memory data_) external;
    function exit(EulerV2ControllerFuseExitData memory data_) external;
}

