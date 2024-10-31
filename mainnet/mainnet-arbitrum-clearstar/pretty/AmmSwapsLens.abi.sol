library AmmTypes {
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

library IAmmSwapsLens {
    struct IporSwap {
        uint256 id;
        address asset;
        address buyer;
        uint256 collateral;
        uint256 notional;
        uint256 leverage;
        uint256 direction;
        uint256 ibtQuantity;
        uint256 fixedInterestRate;
        int256 pnlValue;
        uint256 openTimestamp;
        uint256 endTimestamp;
        uint256 liquidationDepositAmount;
        uint256 state;
    }

    struct SwapLensPoolConfiguration {
        address asset;
        address ammStorage;
        address ammTreasury;
        address spread;
    }
}

library IporTypes {
    type SwapTenor is uint8;

    struct AmmBalancesForOpenSwapMemory {
        uint256 totalCollateralPayFixed;
        uint256 totalNotionalPayFixed;
        uint256 totalCollateralReceiveFixed;
        uint256 totalNotionalReceiveFixed;
        uint256 liquidityPool;
    }
}

interface AmmSwapsLensArbitrum {
    function getBalancesForOpenSwap(address asset)
        external
        view
        returns (IporTypes.AmmBalancesForOpenSwapMemory memory);
    function getOfferedRate(
        address asset,
        IporTypes.SwapTenor tenor,
        uint256 notional,
        AmmTypes.RiskIndicatorsInputs memory payFixedRiskIndicatorsInputs,
        AmmTypes.RiskIndicatorsInputs memory receiveFixedRiskIndicatorsInputs
    ) external view returns (uint256 offeredRatePayFixed, uint256 offeredRateReceiveFixed);
    function getPnlPayFixed(address asset, uint256 swapId) external view returns (int256);
    function getPnlReceiveFixed(address asset, uint256 swapId) external view returns (int256);
    function getSoap(address asset) external view returns (int256 soapPayFixed, int256 soapReceiveFixed, int256 soap);
    function getSwapLensPoolConfiguration(address asset)
        external
        view
        returns (IAmmSwapsLens.SwapLensPoolConfiguration memory);
    function getSwaps(address asset, address account, uint256 offset, uint256 chunkSize)
        external
        view
        returns (uint256 totalCount, IAmmSwapsLens.IporSwap[] memory swaps);
    function iporOracle() external view returns (address);
}

