interface AmmPoolsServiceUsdc {
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

    function ammStorage() external view returns (address);
    function ammTreasury() external view returns (address);
    function asset() external view returns (address);
    function assetDecimals() external view returns (uint256);
    function ipToken() external view returns (address);
    function iporOracle() external view returns (address);
    function iporProtocolRouter() external view returns (address);
    function provideLiquidityUsdcToAmmPoolUsdc(address beneficiary, uint256 assetAmount) external payable;
    function redeemFeeRate() external view returns (uint256);
    function redeemFromAmmPoolUsdc(address beneficiary, uint256 ipTokenAmount) external;
}

