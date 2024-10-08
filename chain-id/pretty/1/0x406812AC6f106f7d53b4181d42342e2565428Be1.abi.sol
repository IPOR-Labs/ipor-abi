interface AmmPoolsServiceStEth {
    error StEthSubmitFailed(uint256 amount, string errorCode);

    event ProvideLiquidityEth(
        address indexed from,
        address indexed beneficiary,
        address indexed to,
        uint256 exchangeRate,
        uint256 amountEth,
        uint256 amountStEth,
        uint256 ipTokenAmount
    );
    event ProvideLiquidityStEth(
        address indexed from,
        address indexed beneficiary,
        address indexed to,
        uint256 exchangeRate,
        uint256 assetAmount,
        uint256 ipTokenAmount
    );
    event RedeemStEth(
        address indexed ammTreasuryEth,
        address indexed from,
        address indexed beneficiary,
        uint256 exchangeRate,
        uint256 amountStEth,
        uint256 redeemedAmountStEth,
        uint256 ipTokenAmount
    );

    function ammStorageStEth() external view returns (address);
    function ammTreasuryStEth() external view returns (address);
    function iporOracle() external view returns (address);
    function iporProtocolRouter() external view returns (address);
    function ipstEth() external view returns (address);
    function provideLiquidityEth(address beneficiary, uint256 ethAmount) external payable;
    function provideLiquidityStEth(address beneficiary, uint256 stEthAmount) external payable;
    function provideLiquidityWEth(address beneficiary, uint256 wEthAmount) external payable;
    function redeemFeeRateStEth() external view returns (uint256);
    function redeemFromAmmPoolStEth(address beneficiary, uint256 ipTokenAmount) external;
    function stEth() external view returns (address);
    function wEth() external view returns (address);
}

