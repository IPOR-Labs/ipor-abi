library IAmmPoolsLens {
    struct AmmPoolsLensPoolConfiguration {
        address asset;
        uint256 decimals;
        address ipToken;
        address ammStorage;
        address ammTreasury;
        address assetManagement;
    }
}

library IporTypes {
    struct AmmBalancesMemory {
        uint256 totalCollateralPayFixed;
        uint256 totalCollateralReceiveFixed;
        uint256 liquidityPool;
        uint256 vault;
    }
}

interface AmmPoolsLens {
    error AssetMismatch(address assetOne, address assetTwo);

    function getAmmBalance(address asset) external view returns (IporTypes.AmmBalancesMemory memory balance);
    function getAmmPoolsLensConfiguration(address asset)
        external
        view
        returns (IAmmPoolsLens.AmmPoolsLensPoolConfiguration memory);
    function getIpTokenExchangeRate(address asset) external view returns (uint256);
    function iporOracle() external view returns (address);
}

