interface AmmPoolsServiceWeEth {
    struct DeployedContracts {
        address ethInput;
        address wEthInput;
        address eEthInput;
        address weEthInput;
        address ipWeEthInput;
        address ammTreasuryWeEthInput;
        address ammStorageWeEthInput;
        address iporOracleInput;
        address iporProtocolRouterInput;
        uint256 redeemFeeRateWeEthInput;
        address eEthLiquidityPoolExternalInput;
        address referralInput;
    }

    error ProvideLiquidityFailed(address poolAsset, string errorCode, string errorMessage);
    error UnsupportedAssetPair(string errorCode, address poolAsset, address inputAsset);
    error WrongAmount(string errorCode, uint256 value);

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

    constructor(DeployedContracts deployedContracts);

    function ammStorageWeEth() external view returns (address);
    function ammTreasuryWeEth() external view returns (address);
    function eEth() external view returns (address);
    function eEthLiquidityPoolExternal() external view returns (address);
    function eth() external view returns (address);
    function ipWeEth() external view returns (address);
    function iporOracle() external view returns (address);
    function iporProtocolRouter() external view returns (address);
    function provideLiquidity(address poolAsset, address inputAsset, address beneficiary, uint256 inputAssetAmount)
        external
        payable
        returns (uint256 ipTokenAmount);
    function provideLiquidityWeEthToAmmPoolWeEth(address beneficiary, uint256 weEthAmount) external;
    function redeemFeeRateWeEth() external view returns (uint256);
    function redeemFromAmmPoolWeEth(address beneficiary, uint256 ipTokenAmount) external;
    function referral() external view returns (address);
    function wEth() external view returns (address);
    function weEth() external view returns (address);
}

