interface AmmPoolsServiceWstEthBaseV2 {
    error AssetMismatch(address assetOne, address assetTwo);

    event ProvideLiquidity(
        address poolAsset,
        address indexed from,
        address indexed beneficiary,
        address indexed to,
        uint256 exchangeRate,
        uint256 assetAmount,
        uint256 ipTokenAmount
    );
    event ProvideLiquidityWstEth(
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
    event RedeemWstEth(
        address indexed ammTreasuryEth,
        address indexed from,
        address indexed beneficiary,
        uint256 exchangeRate,
        uint256 amountStEth,
        uint256 redeemedAmountStEth,
        uint256 ipTokenAmount
    );

    function ammAssetManagement() external view returns (address);
    function ammStorage() external view returns (address);
    function ammTreasury() external view returns (address);
    function asset() external view returns (address);
    function assetDecimals() external view returns (uint256);
    function autoRebalanceThresholdMultiplier() external view returns (uint256);
    function ipToken() external view returns (address);
    function iporOracle() external view returns (address);
    function iporProtocolRouter() external view returns (address);
    function provideLiquidityWstEth(address beneficiary, uint256 assetAmount) external payable;
    function rebalanceBetweenAmmTreasuryAndAssetManagementWstEth() external;
    function redeemFeeRate() external view returns (uint256);
    function redeemFromAmmPoolWstEth(address beneficiary, uint256 ipTokenAmount) external;
}

