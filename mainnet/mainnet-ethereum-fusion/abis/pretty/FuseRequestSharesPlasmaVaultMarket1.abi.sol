interface PlasmaVaultRequestSharesFuse {
    struct PlasmaVaultRequestSharesFuseEnterData {
        uint256 sharesAmount;
        address plasmaVault;
    }

    error PlasmaVaultRequestSharesFuseInvalidWithdrawManager(address vault);
    error PlasmaVaultRequestSharesFuseUnsupportedVault(string action, address vault);

    event PlasmaVaultRequestSharesFuseEnter(address version, address plasmaVault, uint256 sharesAmount);

    function MARKET_ID() external view returns (uint256);
    function VERSION() external view returns (address);
    function enter(PlasmaVaultRequestSharesFuseEnterData memory data_) external;
    function getWithdrawManager() external view returns (address);
}

