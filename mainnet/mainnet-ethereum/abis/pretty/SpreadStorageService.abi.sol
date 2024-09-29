library SpreadStorageLibs {
    type StorageId is uint8;
}

library SpreadTypes {
    struct TimeWeightedNotionalMemory {
        uint256 timeWeightedNotionalPayFixed;
        uint256 lastUpdateTimePayFixed;
        uint256 timeWeightedNotionalReceiveFixed;
        uint256 lastUpdateTimeReceiveFixed;
        SpreadStorageLibs.StorageId storageId;
    }
}

interface SpreadStorageService {
    event SpreadTimeWeightedNotionalChanged(
        uint256 timeWeightedNotionalPayFixed,
        uint256 lastUpdateTimePayFixed,
        uint256 timeWeightedNotionalReceiveFixed,
        uint256 lastUpdateTimeReceiveFixed,
        uint256 storageId
    );

    function updateTimeWeightedNotional(SpreadTypes.TimeWeightedNotionalMemory[] memory timeWeightedNotionalMemories)
        external;
}

