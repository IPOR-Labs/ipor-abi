library AmmInternalTypes {
    struct OpenSwapItem {
        uint32 swapId;
        uint32 nextSwapId;
        uint32 previousSwapId;
        uint32 openSwapTimestamp;
    }
}

library AmmTypes {
    type SwapDirection is uint8;
}

library ISpreadBaseV1 {
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
        IporTypes.SwapTenor tenor;
    }
}

library IporTypes {
    type SwapTenor is uint8;
}

library SpreadStorageLibsBaseV1 {
    type StorageId is uint8;
}

library SpreadTypesBaseV1 {
    struct TimeWeightedNotionalMemory {
        uint256 timeWeightedNotionalPayFixed;
        uint256 lastUpdateTimePayFixed;
        uint256 timeWeightedNotionalReceiveFixed;
        uint256 lastUpdateTimeReceiveFixed;
        SpreadStorageLibsBaseV1.StorageId storageId;
    }

    struct TimeWeightedNotionalResponse {
        TimeWeightedNotionalMemory timeWeightedNotional;
        string key;
    }
}

interface SpreadBaseV1 {
    error UnknownTenor(IporTypes.SwapTenor tenor, string errorCode, string methodName);
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
    function calculateAndUpdateOfferedRatePayFixed(ISpreadBaseV1.SpreadInputs memory spreadInputs)
        external
        returns (uint256 offeredRate);
    function calculateAndUpdateOfferedRateReceiveFixed(ISpreadBaseV1.SpreadInputs memory spreadInputs)
        external
        returns (uint256 offeredRate);
    function calculateOfferedRate(AmmTypes.SwapDirection direction, ISpreadBaseV1.SpreadInputs memory spreadInputs)
        external
        view
        returns (uint256);
    function calculateOfferedRatePayFixed(ISpreadBaseV1.SpreadInputs memory spreadInputs)
        external
        view
        returns (uint256 offeredRate);
    function calculateOfferedRateReceiveFixed(ISpreadBaseV1.SpreadInputs memory spreadInputs)
        external
        view
        returns (uint256 offeredRate);
    function confirmTransferOwnership() external;
    function getTimeWeightedNotional()
        external
        view
        returns (SpreadTypesBaseV1.TimeWeightedNotionalResponse[] memory timeWeightedNotionalResponse);
    function getVersion() external pure returns (uint256);
    function iporProtocolRouter() external view returns (address);
    function owner() external view returns (address);
    function renounceOwnership() external;
    function spreadFunctionConfig() external pure returns (uint256[] memory);
    function transferOwnership(address appointedOwner) external;
    function updateTimeWeightedNotional(
        SpreadTypesBaseV1.TimeWeightedNotionalMemory[] memory timeWeightedNotionalMemories
    ) external;
    function updateTimeWeightedNotionalOnClose(
        uint256 direction,
        IporTypes.SwapTenor tenor,
        uint256 swapNotional,
        AmmInternalTypes.OpenSwapItem memory closedSwap,
        address ammStorageAddress
    ) external;
}

