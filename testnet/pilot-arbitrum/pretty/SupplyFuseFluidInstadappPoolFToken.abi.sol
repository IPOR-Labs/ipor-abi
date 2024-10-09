interface Erc4626SupplyFuse {
    struct Erc4626SupplyFuseEnterData {
        address vault;
        uint256 vaultAssetAmount;
    }

    struct Erc4626SupplyFuseExitData {
        address vault;
        uint256 vaultAssetAmount;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error Erc4626SupplyFuseUnsupportedVault(string action, address asset);
    error FailedInnerCall();
    error SafeERC20FailedOperation(address token);

    event Erc4626SupplyFuseEnter(address version, address asset, address vault, uint256 vaultAssetAmount);
    event Erc4626SupplyFuseExit(
        address version, address asset, address vault, uint256 vaultAssetAmount, uint256 shares
    );
    event Erc4626SupplyFuseExitFailed(address version, address asset, address vault, uint256 vaultAssetAmount);

    function MARKET_ID() external view returns (uint256);
    function VERSION() external view returns (address);
    function enter(Erc4626SupplyFuseEnterData memory data_) external;
    function exit(Erc4626SupplyFuseExitData memory data_) external;
    function instantWithdraw(bytes32[] memory params_) external;
}

