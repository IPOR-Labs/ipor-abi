interface SpreadRouter {
    struct DeployedContracts {
        address iporProtocolRouter;
        address spread28Days;
        address spread60Days;
        address spread90Days;
        address storageLens;
        address closeSwapService;
        address storageService;
    }

    event AdminChanged(address previousAdmin, address newAdmin);
    event AppointedToTransferOwnership(address indexed appointedOwner);
    event BeaconUpgraded(address indexed beacon);
    event Initialized(uint8 version);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event PauseGuardiansAdded(address[] indexed guardians);
    event PauseGuardiansRemoved(address[] indexed guardians);
    event Upgraded(address indexed implementation);

    fallback() external;

    function addPauseGuardians(address[] memory guardians) external;
    function confirmTransferOwnership() external;
    function getConfiguration() external view returns (DeployedContracts memory deployedContracts);
    function getImplementation() external view returns (address);
    function getRouterImplementation(bytes4 sig) external view returns (address);
    function initialize(bool pausedInput) external;
    function isPauseGuardian(address account) external view returns (bool);
    function owner() external view returns (address);
    function pause() external;
    function paused() external view returns (uint256);
    function proxiableUUID() external view returns (bytes32);
    function removePauseGuardians(address[] memory guardians) external;
    function renounceOwnership() external;
    function transferOwnership(address newAppointedOwner) external;
    function unpause() external;
    function upgradeTo(address newImplementation) external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
}

