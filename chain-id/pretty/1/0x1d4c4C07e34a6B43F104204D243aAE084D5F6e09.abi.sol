library IAssetManagementLens {
    struct AssetManagementConfiguration {
        address asset;
        uint256 decimals;
        address assetManagement;
        address ammTreasury;
    }
}

interface AssetManagementLens {
    error AssetMismatch(address assetOne, address assetTwo);

    function balanceOfAmmTreasuryInAssetManagement(address asset) external view returns (uint256);
    function getAssetManagementConfiguration(address asset)
        external
        view
        returns (IAssetManagementLens.AssetManagementConfiguration memory);
}

