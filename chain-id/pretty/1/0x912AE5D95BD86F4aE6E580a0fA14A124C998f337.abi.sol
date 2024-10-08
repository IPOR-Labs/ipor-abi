library IAmmPoolsService {
    struct AmmPoolsServicePoolConfiguration {
        address asset;
        uint256 decimals;
        address ipToken;
        address ammStorage;
        address ammTreasury;
        address assetManagement;
        uint256 redeemFeeRate;
        uint256 redeemLpMaxCollateralRatio;
    }
}

interface AmmPoolsService {
    error AssetMismatch(address assetOne, address assetTwo);

    event ProvideLiquidity(
        address indexed from,
        address indexed beneficiary,
        address indexed to,
        uint256 exchangeRate,
        uint256 assetAmount,
        uint256 ipTokenAmount
    );
    event Redeem(
        address indexed ammTreasury,
        address indexed from,
        address indexed beneficiary,
        uint256 exchangeRate,
        uint256 assetAmount,
        uint256 ipTokenAmount,
        uint256 redeemFee,
        uint256 redeemAmount
    );

    function getAmmPoolServiceConfiguration(address asset)
        external
        view
        returns (IAmmPoolsService.AmmPoolsServicePoolConfiguration memory);
    function iporOracle() external view returns (address);
    function provideLiquidityDai(address beneficiary, uint256 assetAmount) external;
    function provideLiquidityUsdc(address beneficiary, uint256 assetAmount) external;
    function provideLiquidityUsdt(address beneficiary, uint256 assetAmount) external;
    function rebalanceBetweenAmmTreasuryAndAssetManagement(address asset) external;
    function redeemFromAmmPoolDai(address beneficiary, uint256 ipTokenAmount) external;
    function redeemFromAmmPoolUsdc(address beneficiary, uint256 ipTokenAmount) external;
    function redeemFromAmmPoolUsdt(address beneficiary, uint256 ipTokenAmount) external;
}

