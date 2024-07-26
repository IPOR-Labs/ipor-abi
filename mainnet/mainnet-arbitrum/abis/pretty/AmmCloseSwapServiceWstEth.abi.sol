interface AmmCloseSwapServiceWstEth {
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

    function ammAssetManagement() external view returns (address);
    function ammStorage() external view returns (address);
    function ammTreasury() external view returns (address);
    function asset() external view returns (address);
    function closeSwapsWstEth(
        address beneficiary,
        uint256[] memory payFixedSwapIds,
        uint256[] memory receiveFixedSwapIds,
        CloseSwapRiskIndicatorsInput memory riskIndicatorsInput
    )
        external
        returns (
            IporSwapClosingResult[] memory closedPayFixedSwaps,
            IporSwapClosingResult[] memory closedReceiveFixedSwaps
        );
    function decimals() external view returns (uint256);
    function emergencyCloseSwapsWstEth(
        uint256[] memory payFixedSwapIds,
        uint256[] memory receiveFixedSwapIds,
        CloseSwapRiskIndicatorsInput memory riskIndicatorsInput
    )
        external
        returns (
            IporSwapClosingResult[] memory closedPayFixedSwaps,
            IporSwapClosingResult[] memory closedReceiveFixedSwaps
        );
    function getPoolConfiguration() external view returns (AmmCloseSwapServicePoolConfiguration memory);
    function iporOracle() external view returns (address);
    function liquidationLegLimit() external view returns (uint256);
    function minLeverage() external view returns (uint256);
    function minLiquidationThresholdToCloseBeforeMaturityByBuyer() external view returns (uint256);
    function minLiquidationThresholdToCloseBeforeMaturityByCommunity() external view returns (uint256);
    function spread() external view returns (address);
    function timeAfterOpenAllowedToCloseSwapWithUnwindingTenor28days() external view returns (uint256);
    function timeAfterOpenAllowedToCloseSwapWithUnwindingTenor60days() external view returns (uint256);
    function timeAfterOpenAllowedToCloseSwapWithUnwindingTenor90days() external view returns (uint256);
    function timeBeforeMaturityAllowedToCloseSwapByBuyerTenor28days() external view returns (uint256);
    function timeBeforeMaturityAllowedToCloseSwapByBuyerTenor60days() external view returns (uint256);
    function timeBeforeMaturityAllowedToCloseSwapByBuyerTenor90days() external view returns (uint256);
    function timeBeforeMaturityAllowedToCloseSwapByCommunity() external view returns (uint256);
    function unwindingFeeRate() external view returns (uint256);
    function unwindingFeeTreasuryPortionRate() external view returns (uint256);
    function version() external pure returns (uint256);
}

