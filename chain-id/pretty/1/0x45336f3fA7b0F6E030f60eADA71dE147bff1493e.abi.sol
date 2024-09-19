interface SpreadStorageService {
    type StorageId is uint8;

    struct TimeWeightedNotionalMemory {
        uint256 timeWeightedNotionalPayFixed;
        uint256 lastUpdateTimePayFixed;
        uint256 timeWeightedNotionalReceiveFixed;
        uint256 lastUpdateTimeReceiveFixed;
        StorageId storageId;
    }

    event SpreadTimeWeightedNotionalChanged(
        uint256 timeWeightedNotionalPayFixed,
        uint256 lastUpdateTimePayFixed,
        uint256 timeWeightedNotionalReceiveFixed,
        uint256 lastUpdateTimeReceiveFixed,
        uint256 storageId
    );

    function updateTimeWeightedNotional(TimeWeightedNotionalMemory[] memory timeWeightedNotionalMemories) external;
}

