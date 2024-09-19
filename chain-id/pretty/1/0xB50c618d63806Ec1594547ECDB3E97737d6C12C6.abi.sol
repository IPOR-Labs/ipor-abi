interface SpreadStorageLens {
    type StorageId is uint8;

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

    function getTimeWeightedNotional()
        external
        view
        returns (TimeWeightedNotionalResponse[] memory timeWeightedNotionalResponse);
}

