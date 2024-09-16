interface SpreadBaseV1 {
    type StorageId is uint8;
    type SwapDirection is uint8;
    type SwapTenor is uint8;

    struct OpenSwapItem {
        uint32 swapId;
        uint32 nextSwapId;
        uint32 previousSwapId;
        uint32 openSwapTimestamp;
    }

    struct SpreadInputs {
        address asset;
        uint256 swapNotional;
        uint256 demandSpreadFactor;
        int256 baseSpreadPerLeg;
        uint256 totalCollateralPayFixed;
        uint256 totalCollateralReceiveFixed;
        uint256 liquidityPoolBalance;
        uint256 iporIndexValue;
        uint256 fixedRateCapPerLeg;
        SwapTenor tenor;
    }

    struct TimeWeightedNotionalMemory {
        uint256 timeWeightedNotionalPayFixed;
        uint256 lastUpdateTimePayFixed;
        uint256 timeWeightedNotionalReceiveFixed;
        uint256 lastUpdateTimeReceiveFixed;
        StorageId storageId;
    }

    struct TimeWeightedNotionalResponse {
        TimeWeightedNotionalMemory timeWeightedNotional;
        string key;
    }

    error UnknownTenor(SwapTenor tenor, string errorCode, string methodName);
    error UnsupportedDirection(string errorCode, uint256 direction);

    event AppointedToTransferOwnership(address indexed appointedOwner);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event SpreadTimeWeightedNotionalChanged(
        uint256 timeWeightedNotionalPayFixed,
        uint256 lastUpdateTimePayFixed,
        uint256 timeWeightedNotionalReceiveFixed,
        uint256 lastUpdateTimeReceiveFixed,
        uint256 storageId
    );

    function asset() external view returns (address);
    function calculateAndUpdateOfferedRatePayFixed(SpreadInputs memory spreadInputs)
        external
        returns (uint256 offeredRate);
    function calculateAndUpdateOfferedRateReceiveFixed(SpreadInputs memory spreadInputs)
        external
        returns (uint256 offeredRate);
    function calculateOfferedRate(SwapDirection direction, SpreadInputs memory spreadInputs)
        external
        view
        returns (uint256);
    function calculateOfferedRatePayFixed(SpreadInputs memory spreadInputs)
        external
        view
        returns (uint256 offeredRate);
    function calculateOfferedRateReceiveFixed(SpreadInputs memory spreadInputs)
        external
        view
        returns (uint256 offeredRate);
    function confirmTransferOwnership() external;
    function getTimeWeightedNotional()
        external
        view
        returns (TimeWeightedNotionalResponse[] memory timeWeightedNotionalResponse);
    function getVersion() external pure returns (uint256);
    function iporProtocolRouter() external view returns (address);
    function owner() external view returns (address);
    function renounceOwnership() external;
    function spreadFunctionConfig() external pure returns (uint256[] memory);
    function transferOwnership(address appointedOwner) external;
    function updateTimeWeightedNotional(TimeWeightedNotionalMemory[] memory timeWeightedNotionalMemories) external;
    function updateTimeWeightedNotionalOnClose(
        uint256 direction,
        SwapTenor tenor,
        uint256 swapNotional,
        OpenSwapItem memory closedSwap,
        address ammStorageAddress
    ) external;
}

