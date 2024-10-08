library IIporOracle {
    struct UpdateIndexParams {
        address asset;
        uint256 indexValue;
        uint256 updateTimestamp;
        uint256 quasiIbtPrice;
    }
}

library IporTypes {
    struct AccruedIpor {
        uint256 indexValue;
        uint256 ibtPrice;
    }
}

interface IporOracle {
    error UpdateIndex(address asset, string errorCode, string methodName);
    error WrongAddress(string errorCode, address wrongAddress, string message);

    event AdminChanged(address previousAdmin, address newAdmin);
    event AppointedToTransferOwnership(address indexed appointedOwner);
    event BeaconUpgraded(address indexed beacon);
    event Initialized(uint8 version);
    event IporIndexAddAsset(address newAsset, uint256 updateTimestamp);
    event IporIndexAddUpdater(address newUpdater);
    event IporIndexRemoveAsset(address asset);
    event IporIndexRemoveUpdater(address updater);
    event IporIndexUpdate(address asset, uint256 indexValue, uint256 quasiIbtPrice, uint256 updateTimestamp);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event PauseGuardiansAdded(address[] indexed guardians);
    event PauseGuardiansRemoved(address[] indexed guardians);
    event Paused(address account);
    event Unpaused(address account);
    event Upgraded(address indexed implementation);

    function addAsset(address asset, uint256 updateTimestamp) external;
    function addPauseGuardians(address[] memory guardians) external;
    function addUpdater(address updater) external;
    function calculateAccruedIbtPrice(address asset, uint256 calculateTimestamp) external view returns (uint256);
    function confirmTransferOwnership() external;
    function getAccruedIndex(uint256 calculateTimestamp, address asset)
        external
        view
        returns (IporTypes.AccruedIpor memory accruedIpor);
    function getConfiguration()
        external
        view
        returns (
            address usdt,
            uint256 usdtInitialIbtPrice,
            address usdc,
            uint256 usdcInitialIbtPrice,
            address dai,
            uint256 daiInitialIbtPrice
        );
    function getImplementation() external view returns (address);
    function getIndex(address asset)
        external
        view
        returns (uint256 indexValue, uint256 ibtPrice, uint256 lastUpdateTimestamp);
    function getVersion() external pure returns (uint256);
    function initialize(address[] memory assets, uint32[] memory updateTimestamps) external;
    function isAssetSupported(address asset) external view returns (bool);
    function isPauseGuardian(address account) external view returns (bool);
    function isUpdater(address updater) external view returns (uint256);
    function owner() external view returns (address);
    function pause() external;
    function paused() external view returns (bool);
    function proxiableUUID() external view returns (bytes32);
    function removeAsset(address asset) external;
    function removePauseGuardians(address[] memory guardians) external;
    function removeUpdater(address updater) external;
    function renounceOwnership() external;
    function transferOwnership(address appointedOwner) external;
    function unpause() external;
    function updateIndexes(IIporOracle.UpdateIndexParams[] memory indexesToUpdate) external;
    function updateIndexesAndQuasiIbtPrice(IIporOracle.UpdateIndexParams[] memory indexesToUpdate) external;
    function upgradeTo(address newImplementation) external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
}

