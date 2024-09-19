interface AssetManagementLens {
    struct AssetManagementConfiguration {
        address asset;
        uint256 decimals;
        address assetManagement;
        address ammTreasury;
    }

    constructor(
        AssetManagementConfiguration usdtAssetManagementCfg,
        AssetManagementConfiguration usdcAssetManagementCfg,
        AssetManagementConfiguration daiAssetManagementCfg
    );

    function balanceOfAmmTreasuryInAssetManagement(address asset) external view returns (uint256);
    function getAssetManagementConfiguration(address asset)
        external
        view
        returns (AssetManagementConfiguration memory);
}

