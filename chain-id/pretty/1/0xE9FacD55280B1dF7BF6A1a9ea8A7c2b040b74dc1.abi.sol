interface AmmTreasury {
    error AssetMismatch(address assetOne, address assetTwo);

    event AdminChanged(address previousAdmin, address newAdmin);
    event AppointedToTransferOwnership(address indexed appointedOwner);
    event BeaconUpgraded(address indexed beacon);
    event Initialized(uint8 version);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event PauseGuardiansAdded(address[] indexed guardians);
    event PauseGuardiansRemoved(address[] indexed guardians);
    event Paused(address account);
    event Unpaused(address account);
    event Upgraded(address indexed implementation);

    function addPauseGuardians(address[] memory guardians) external;
    function confirmTransferOwnership() external;
    function depositToAssetManagementInternal(uint256 wadAssetAmount) external;
    function getConfiguration()
        external
        view
        returns (address asset, uint256 decimals, address ammStorage, address assetManagement, address router);
    function getImplementation() external view returns (address);
    function getVersion() external pure returns (uint256);
    function grantMaxAllowanceForSpender(address spender) external;
    function initialize(bool paused) external;
    function isPauseGuardian(address account) external view returns (bool);
    function owner() external view returns (address);
    function pause() external;
    function paused() external view returns (bool);
    function proxiableUUID() external view returns (bytes32);
    function removePauseGuardians(address[] memory guardians) external;
    function renounceOwnership() external;
    function revokeAllowanceForSpender(address spender) external;
    function transferOwnership(address appointedOwner) external;
    function unpause() external;
    function upgradeTo(address newImplementation) external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
    function withdrawAllFromAssetManagementInternal() external;
    function withdrawFromAssetManagementInternal(uint256 wadAssetAmount) external;
}

