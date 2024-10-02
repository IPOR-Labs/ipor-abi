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

    struct TimeWeightedNotionalResponse {
        TimeWeightedNotionalMemory timeWeightedNotional;
        string key;
    }
}

interface SpreadStorageLens {
    function getTimeWeightedNotional()
        external
        view
        returns (SpreadTypes.TimeWeightedNotionalResponse[] memory timeWeightedNotionalResponse);
}

