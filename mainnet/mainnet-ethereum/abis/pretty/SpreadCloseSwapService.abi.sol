interface SpreadCloseSwapService {
    type SwapTenor is uint8;

    struct OpenSwapItem {
        uint32 swapId;
        uint32 nextSwapId;
        uint32 previousSwapId;
        uint32 openSwapTimestamp;
    }

    constructor(address dai, address usdc, address usdt);

    function getSupportedAssets() external view returns (address[] memory);
    function updateTimeWeightedNotionalOnClose(
        address asset,
        uint256 direction,
        SwapTenor tenor,
        uint256 swapNotional,
        OpenSwapItem memory closedSwap,
        address ammStorageAddress
    ) external;
}

