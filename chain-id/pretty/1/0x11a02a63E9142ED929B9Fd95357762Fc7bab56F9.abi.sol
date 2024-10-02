library AmmTypes {
    struct CloseSwapRiskIndicatorsInput {
        RiskIndicatorsInputs payFixed;
        RiskIndicatorsInputs receiveFixed;
    }

    struct IporSwapClosingResult {
        uint256 swapId;
        bool closed;
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

interface AmmCloseSwapServiceUsdt {
    error AssetMismatch(address assetOne, address assetTwo);
    error UnsupportedTenor(string errorCode, uint256 tenor);

    event CloseSwap(
        uint256 indexed swapId,
        address asset,
        uint256 closeTimestamp,
        address liquidator,
        uint256 transferredToBuyer,
        uint256 transferredToLiquidator
    );
    event SwapUnwind(
        address asset,
        uint256 indexed swapId,
        int256 swapPnlValueToDate,
        int256 swapUnwindAmount,
        uint256 unwindFeeLPAmount,
        uint256 unwindFeeTreasuryAmount
    );

    function closeSwapsUsdt(
        address beneficiary,
        uint256[] memory payFixedSwapIds,
        uint256[] memory receiveFixedSwapIds,
        AmmTypes.CloseSwapRiskIndicatorsInput memory riskIndicatorsInput
    )
        external
        returns (
            AmmTypes.IporSwapClosingResult[] memory closedPayFixedSwaps,
            AmmTypes.IporSwapClosingResult[] memory closedReceiveFixedSwaps
        );
    function emergencyCloseSwapsUsdt(
        uint256[] memory payFixedSwapIds,
        uint256[] memory receiveFixedSwapIds,
        AmmTypes.CloseSwapRiskIndicatorsInput memory riskIndicatorsInput
    )
        external
        returns (
            AmmTypes.IporSwapClosingResult[] memory closedPayFixedSwaps,
            AmmTypes.IporSwapClosingResult[] memory closedReceiveFixedSwaps
        );
    function getPoolConfiguration()
        external
        view
        returns (IAmmCloseSwapLens.AmmCloseSwapServicePoolConfiguration memory);
    function iporOracle() external view returns (address);
    function messageSigner() external view returns (address);
    function spreadRouter() external view returns (address);
}

