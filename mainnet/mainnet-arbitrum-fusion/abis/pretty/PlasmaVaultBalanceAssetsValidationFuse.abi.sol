interface PlasmaVaultBalanceAssetsValidationFuse {
    struct PlasmaVaultBalanceAssetsValidationFuseEnterData {
        address[] assets;
        uint256[] minBalanceValues;
        uint256[] maxBalanceValues;
    }

    error PlasmaVaultBalanceAssetsValidationFuseInvalidBalance(
        address asset, uint256 balance, uint256 minBalance, uint256 maxBalance
    );
    error WrongValue();

    function MARKET_ID() external view returns (uint256);
    function VERSION() external view returns (address);
    function enter(PlasmaVaultBalanceAssetsValidationFuseEnterData memory data_) external;
}

