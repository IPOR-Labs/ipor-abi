interface EulerV2SupplyFuse {
    struct EulerV2SupplyFuseEnterData {
        address eulerVault;
        uint256 maxAmount;
        bytes1 subAccount;
    }

    struct EulerV2SupplyFuseExitData {
        address eulerVault;
        uint256 maxAmount;
        bytes1 subAccount;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error EulerV2SupplyFuseUnsupportedEnterAction(address vault, bytes1 subAccount);
    error FailedInnerCall();
    error SafeERC20FailedOperation(address token);

    event EulerV2SupplyEnterFuse(address version, address eulerVault, uint256 supplyAmount, address subAccount);
    event EulerV2SupplyExitFuse(address version, address eulerVault, uint256 withdrawnAmount, address subAccount);

    function EVC() external view returns (address);
    function MARKET_ID() external view returns (uint256);
    function VERSION() external view returns (address);
    function enter(EulerV2SupplyFuseEnterData memory data_) external;
    function exit(EulerV2SupplyFuseExitData memory data_) external;
}

