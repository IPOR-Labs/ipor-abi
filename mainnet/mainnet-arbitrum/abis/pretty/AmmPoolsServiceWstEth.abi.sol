interface AmmPoolsServiceWstEth {
    event ProvideLiquidityWstEth(
        address indexed from,
        address indexed beneficiary,
        address indexed to,
        uint256 exchangeRate,
        uint256 assetAmount,
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

    constructor(
        address wstEthInput,
        address ipwstEthInput,
        address ammTreasuryWstEthInput,
        address ammStorageWstEthInput,
        address iporOracleInput,
        address iporProtocolRouterInput,
        uint256 redeemFeeRateWstEthInput
    );

    function ammStorageWstEth() external view returns (address);
    function ammTreasuryWstEth() external view returns (address);
    function iporOracle() external view returns (address);
    function iporProtocolRouter() external view returns (address);
    function ipwstEth() external view returns (address);
    function provideLiquidityWstEth(address beneficiary, uint256 wstEthAmount) external payable;
    function redeemFeeRateWstEth() external view returns (uint256);
    function redeemFromAmmPoolWstEth(address beneficiary, uint256 ipTokenAmount) external;
    function wstEth() external view returns (address);
}

