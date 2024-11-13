library AmmTypes {
    type SwapClosableStatus is uint8;
    type SwapDirection is uint8;

    struct CloseSwapRiskIndicatorsInput {
        RiskIndicatorsInputs payFixed;
        RiskIndicatorsInputs receiveFixed;
    }

    struct ClosingSwapDetails {
        SwapClosableStatus closableStatus;
        bool swapUnwindRequired;
        int256 swapUnwindPnlValue;
        uint256 swapUnwindOpeningFeeAmount;
        uint256 swapUnwindFeeLPAmount;
        uint256 swapUnwindFeeTreasuryAmount;
        int256 pnlValue;
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

library IAmmCloseSwapLens {
    struct AmmCloseSwapServicePoolConfiguration {
        address asset;
        uint256 decimals;
        address ammStorage;
        address ammTreasury;
        address assetManagement;
        address spread;
        uint256 unwindingFeeRate;
        uint256 unwindingFeeTreasuryPortionRate;
        uint256 maxLengthOfLiquidatedSwapsPerLeg;
        uint256 timeBeforeMaturityAllowedToCloseSwapByCommunity;
        uint256 timeBeforeMaturityAllowedToCloseSwapByBuyerTenor28days;
        uint256 timeBeforeMaturityAllowedToCloseSwapByBuyerTenor60days;
        uint256 timeBeforeMaturityAllowedToCloseSwapByBuyerTenor90days;
        uint256 minLiquidationThresholdToCloseBeforeMaturityByCommunity;
        uint256 minLiquidationThresholdToCloseBeforeMaturityByBuyer;
        uint256 minLeverage;
        uint256 timeAfterOpenAllowedToCloseSwapWithUnwindingTenor28days;
        uint256 timeAfterOpenAllowedToCloseSwapWithUnwindingTenor60days;
        uint256 timeAfterOpenAllowedToCloseSwapWithUnwindingTenor90days;
    }
}

interface AmmCloseSwapLensBaseV1 {
    error UnsupportedAsset(string errorCode, address asset);
    error UnsupportedTenor(string errorCode, uint256 tenor);

    function getAmmCloseSwapServicePoolConfiguration(address asset)
        external
        view
        returns (IAmmCloseSwapLens.AmmCloseSwapServicePoolConfiguration memory);
    function getClosingSwapDetails(
        address asset,
        address account,
        AmmTypes.SwapDirection direction,
        uint256 swapId,
        uint256 closeTimestamp,
        AmmTypes.CloseSwapRiskIndicatorsInput memory riskIndicatorsInput
    ) external view returns (AmmTypes.ClosingSwapDetails memory closingSwapDetails);
    function iporOracle() external view returns (address);
}

