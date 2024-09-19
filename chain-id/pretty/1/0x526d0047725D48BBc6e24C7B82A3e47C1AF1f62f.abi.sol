interface StrategyAave {
    event AdminChanged(address previousAdmin, address newAdmin);
    event AppointedToTransferOwnership(address indexed appointedOwner);
    event BeaconUpgraded(address indexed beacon);
    event DoBeforeClaim(address indexed executedBy, address[] shareTokens);
    event DoClaim(
        address indexed claimedBy, address indexed shareTokenAddress, address indexed treasury, uint256 amount
    );
    event Initialized(uint8 version);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event PauseGuardiansAdded(address[] indexed guardians);
    event PauseGuardiansRemoved(address[] indexed guardians);
    event Paused(address account);
    event TreasuryChanged(address newTreasury);
    event TreasuryManagerChanged(address newTreasuryManager);
    event Unpaused(address account);
    event Upgraded(address indexed implementation);

    constructor(
        address assetInput,
        uint256 assetDecimalsInput,
        address shareTokenInput,
        address assetManagementInput,
        address aaveInput,
        address stkAaveInput,
        address providerInput,
        address aaaveIncentiveInput
    );

    function aave() external view returns (address);
    function aaveIncentive() external view returns (address);
    function addPauseGuardians(address[] memory guardians) external;
    function asset() external view returns (address);
    function assetDecimals() external view returns (uint256);
    function assetManagement() external view returns (address);
    function balanceOf() external view returns (uint256);
    function beforeClaim() external;
    function confirmTransferOwnership() external;
    function deposit(uint256 wadAmount) external returns (uint256 depositedAmount);
    function doClaim() external;
    function getApy() external view returns (uint256 apy);
    function getImplementation() external view returns (address);
    function getTreasury() external view returns (address);
    function getTreasuryManager() external view returns (address);
    function getVersion() external view returns (uint256);
    function initialize() external;
    function isPauseGuardian(address account) external view returns (bool);
    function owner() external view returns (address);
    function pause() external;
    function paused() external view returns (bool);
    function provider() external view returns (address);
    function proxiableUUID() external view returns (bytes32);
    function removePauseGuardians(address[] memory guardians) external;
    function renounceOwnership() external;
    function setTreasury(address newTreasury) external;
    function setTreasuryManager(address manager) external;
    function shareToken() external view returns (address);
    function stakedAaveInterface() external view returns (address);
    function stkAave() external view returns (address);
    function transferOwnership(address appointedOwner) external;
    function unpause() external;
    function upgradeTo(address newImplementation) external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
    function withdraw(uint256 wadAmount) external returns (uint256 withdrawnAmount);
}

