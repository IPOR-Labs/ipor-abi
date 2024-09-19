interface AmmPoolsLens {
    struct AmmBalancesMemory {
        uint256 totalCollateralPayFixed;
        uint256 totalCollateralReceiveFixed;
        uint256 liquidityPool;
        uint256 vault;
    }

    struct AmmPoolsLensPoolConfiguration {
        address asset;
        uint256 decimals;
        address ipToken;
        address ammStorage;
        address ammTreasury;
        address assetManagement;
    }

    constructor(
        AmmPoolsLensPoolConfiguration usdtPoolCfg,
        AmmPoolsLensPoolConfiguration usdcPoolCfg,
        AmmPoolsLensPoolConfiguration daiPoolCfg,
        address iporOracleInput
    );

    function getAmmBalance(address asset) external view returns (AmmBalancesMemory memory balance);
    function getAmmPoolsLensConfiguration(address asset) external view returns (AmmPoolsLensPoolConfiguration memory);
    function getIpTokenExchangeRate(address asset) external view returns (uint256);
    function iporOracle() external view returns (address);
}

