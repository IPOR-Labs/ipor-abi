library AmmTypes {
    type SwapDirection is uint8;

    struct IporSwapIndicator {
        uint256 iporIndexValue;
        uint256 ibtPrice;
        uint256 ibtQuantity;
        uint256 fixedInterestRate;
    }

    struct RiskIndicatorsInputs {
        uint256 maxCollateralRatio;
        uint256 maxCollateralRatioPerLeg;
        uint256 maxLeveragePerLeg;
        int256 baseSpreadPerLeg;
        uint256 fixedRateCapPerLeg;
        uint256 demandSpreadFactor;
        uint256 expiration;
        bytes signature;
    }
}

library AmmTypesBaseV1 {
    struct AmmOpenSwapServicePoolConfiguration {
        address asset;
        uint256 decimals;
        address ammStorage;
        address ammTreasury;
        address spread;
        uint256 iporPublicationFee;
        uint256 maxSwapCollateralAmount;
        uint256 liquidationDepositAmount;
        uint256 minLeverage;
        uint256 openingFeeRate;
        uint256 openingFeeTreasuryPortionRate;
    }

    struct OpenSwapAmount {
        uint256 inputAssetTotalAmount;
        uint256 assetTotalAmount;
        uint256 collateral;
        uint256 notional;
        uint256 openingFeeLPAmount;
        uint256 openingFeeTreasuryAmount;
        uint256 iporPublicationFee;
        uint256 liquidationDepositAmount;
    }
}

interface AmmOpenSwapServiceUsdcBaseV1 {
    error InputAssetBalanceTooLow(string errorCode, address inputAsset, uint256 inputAssetBalance, uint256 totalAmount);
    error InputAssetTotalAmountTooLow(string errorCode, uint256 value);
    error UnsupportedAsset(string errorCode, address asset);

    event OpenSwap(
        uint256 indexed swapId,
        address indexed buyer,
        address inputAsset,
        address asset,
        AmmTypes.SwapDirection direction,
        AmmTypesBaseV1.OpenSwapAmount amounts,
        uint256 openTimestamp,
        uint256 endTimestamp,
        AmmTypes.IporSwapIndicator indicator
    );

    function ETH_ADDRESS() external view returns (address);
    function ammStorage() external view returns (address);
    function ammTreasury() external view returns (address);
    function asset() external view returns (address);
    function decimals() external view returns (uint256);
    function iporOracle() external view returns (address);
    function iporPublicationFee() external view returns (uint256);
    function liquidationDepositAmount() external view returns (uint256);
    function maxSwapCollateralAmount() external view returns (uint256);
    function minLeverage() external view returns (uint256);
    function openSwapPayFixed28daysUsdc(
        address beneficiary,
        address inputAsset,
        uint256 inputAssetTotalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        AmmTypes.RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external returns (uint256);
    function openSwapPayFixed60daysUsdc(
        address beneficiary,
        address inputAsset,
        uint256 inputAssetTotalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        AmmTypes.RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external returns (uint256);
    function openSwapPayFixed90daysUsdc(
        address beneficiary,
        address inputAsset,
        uint256 inputAssetTotalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        AmmTypes.RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external returns (uint256);
    function openSwapReceiveFixed28daysUsdc(
        address beneficiary,
        address inputAsset,
        uint256 inputAssetTotalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        AmmTypes.RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external returns (uint256);
    function openSwapReceiveFixed60daysUsdc(
        address beneficiary,
        address inputAsset,
        uint256 inputAssetTotalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        AmmTypes.RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external returns (uint256);
    function openSwapReceiveFixed90daysUsdc(
        address beneficiary,
        address inputAsset,
        uint256 inputAssetTotalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        AmmTypes.RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external returns (uint256);
    function openingFeeRate() external view returns (uint256);
    function openingFeeTreasuryPortionRate() external view returns (uint256);
    function spread() external view returns (address);
    function version() external view returns (uint256);
}

