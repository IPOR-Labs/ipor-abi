interface StrategyDsrDai {
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

    constructor(address assetInput, address shareTokenInput, address assetManagementInput);

    function addPauseGuardians(address[] memory guardians) external;
    function asset() external view returns (address);
    function assetManagement() external view returns (address);
    function balanceOf() external view returns (uint256);
    function confirmTransferOwnership() external;
    function deposit(uint256 wadAmount) external returns (uint256 depositedAmount);
    function getApy() external view returns (uint256 apy);
    function getImplementation() external view returns (address);
    function getVersion() external view returns (uint256);
    function initialize() external;
    function isPauseGuardian(address account) external view returns (bool);
    function owner() external view returns (address);
    function pause() external;
    function paused() external view returns (bool);
    function pot() external view returns (address);
    function proxiableUUID() external view returns (bytes32);
    function removePauseGuardians(address[] memory guardians) external;
    function renounceOwnership() external;
    function shareToken() external view returns (address);
    function transferOwnership(address appointedOwner) external;
    function unpause() external;
    function upgradeTo(address newImplementation) external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
    function withdraw(uint256 wadAmount) external returns (uint256 withdrawnAmount);
}

