interface AmmTreasuryBaseV2 {
    error AssetMismatch(address assetOne, address assetTwo);
    error CallerNotPauseGuardian(string errorCode, address caller);

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
    function ammAssetManagement() external view returns (address);
    function ammStorage() external view returns (address);
    function asset() external view returns (address);
    function assetDecimals() external view returns (uint256);
    function confirmTransferOwnership() external;
    function depositToAssetManagementInternal(uint256 wadAssetAmount) external;
    function getImplementation() external view returns (address);
    function getLiquidityPoolBalance() external view returns (uint256);
    function getVersion() external pure returns (uint256);
    function initialize(bool paused) external;
    function isPauseGuardian(address account) external view returns (bool);
    function owner() external view returns (address);
    function pause() external;
    function paused() external view returns (bool);
    function proxiableUUID() external view returns (bytes32);
    function removePauseGuardians(address[] memory guardians) external;
    function renounceOwnership() external;
    function router() external view returns (address);
    function transferOwnership(address appointedOwner) external;
    function unpause() external;
    function upgradeTo(address newImplementation) external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
    function withdrawAllFromAssetManagementInternal() external;
    function withdrawFromAssetManagementInternal(uint256 wadAssetAmount) external;
}

