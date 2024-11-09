library AmmStorageTypes {
    struct SoapIndicators {
        uint256 hypotheticalInterestCumulative;
        uint256 totalNotional;
        uint256 totalIbtQuantity;
        uint256 averageInterestRate;
        uint256 rebalanceTimestamp;
    }
}

interface SoapIndicatorRebalanceLogic {
    function rebalanceWhenCloseSwap(
        AmmStorageTypes.SoapIndicators memory si,
        uint256 rebalanceTimestamp,
        uint256 swapOpenTimestamp,
        uint256 swapNotional,
        uint256 swapFixedInterestRate,
        uint256 swapIbtQuantity
    ) external pure returns (AmmStorageTypes.SoapIndicators memory);
    function rebalanceWhenOpenSwap(
        AmmStorageTypes.SoapIndicators memory si,
        uint256 rebalanceTimestamp,
        uint256 swapNotional,
        uint256 swapFixedInterestRate,
        uint256 swapIbtQuantity
    ) external pure returns (AmmStorageTypes.SoapIndicators memory);
}

