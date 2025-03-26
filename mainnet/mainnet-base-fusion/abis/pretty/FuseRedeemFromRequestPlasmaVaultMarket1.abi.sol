interface PlasmaVaultRedeemFromRequestFuse {
    struct PlasmaVaultRedeemFromRequestFuseEnterData {
        uint256 sharesAmount;
        address plasmaVault;
    }

    error PlasmaVaultRedeemFromRequestFuseUnsupportedVault(string action, address vault);

    event PlasmaVaultRedeemFromRequestFuseEnter(address version, address plasmaVault, uint256 sharesAmount);

    function MARKET_ID() external view returns (uint256);
    function VERSION() external view returns (address);
    function enter(PlasmaVaultRedeemFromRequestFuseEnterData memory data_) external;
}

