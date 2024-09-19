interface AmmPoolsServiceUsdm {
    event ProvideLiquidity(
        address poolAsset,
        address indexed from,
        address indexed beneficiary,
        address indexed to,
        uint256 exchangeRate,
        uint256 assetAmount,
        uint256 ipTokenAmount
    );
    event Redeem(
        address poolAsset,
        address indexed ammTreasury,
        address indexed from,
        address indexed beneficiary,
        uint256 exchangeRate,
        uint256 amount,
        uint256 redeemedAmount,
        uint256 ipTokenAmount
    );

    constructor(
        address usdmInput,
        address ipUsdmInput,
        address ammTreasuryUsdmInput,
        address ammStorageUsdmInput,
        address iporOracleInput,
        address iporProtocolRouterInput,
        uint256 redeemFeeRateUsdmInput
    );

    function ammStorageUsdm() external view returns (address);
    function ammTreasuryUsdm() external view returns (address);
    function ipUsdm() external view returns (address);
    function iporOracle() external view returns (address);
    function iporProtocolRouter() external view returns (address);
    function provideLiquidityUsdmToAmmPoolUsdm(address beneficiary, uint256 usdmAmount) external payable;
    function redeemFeeRateUsdm() external view returns (uint256);
    function redeemFromAmmPoolUsdm(address beneficiary, uint256 ipTokenAmount) external;
    function usdm() external view returns (address);
}

