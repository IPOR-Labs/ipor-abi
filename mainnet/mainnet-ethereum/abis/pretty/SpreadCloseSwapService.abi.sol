library AmmInternalTypes {
    struct OpenSwapItem {
        uint32 swapId;
        uint32 nextSwapId;
        uint32 previousSwapId;
        uint32 openSwapTimestamp;
    }
}

library IporTypes {
    type SwapTenor is uint8;
}

interface SpreadCloseSwapService {
    function getSupportedAssets() external view returns (address[] memory);
    function updateTimeWeightedNotionalOnClose(
        address asset,
        uint256 direction,
        IporTypes.SwapTenor tenor,
        uint256 swapNotional,
        AmmInternalTypes.OpenSwapItem memory closedSwap,
        address ammStorageAddress
    ) external;
}

