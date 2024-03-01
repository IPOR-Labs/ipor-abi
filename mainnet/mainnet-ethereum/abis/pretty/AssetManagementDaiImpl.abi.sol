interface AssetManagementDai {
    struct StrategyData {
        address strategy;
        uint256 balance;
        uint256 apy;
    }

    event AdminChanged(address previousAdmin, address newAdmin);
    event AppointedToTransferOwnership(address indexed appointedOwner);
    event BeaconUpgraded(address indexed beacon);
    event Deposit(address from, address to, uint256 amount);
    event Initialized(uint8 version);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event PauseGuardiansAdded(address[] indexed guardians);
    event PauseGuardiansRemoved(address[] indexed guardians);
    event Paused(address account);
    event Unpaused(address account);
    event Upgraded(address indexed implementation);
    event Withdraw(address to, uint256 amount);

    constructor(
        address assetInput,
        address ammTreasuryInput,
        address strategyAaveInput,
        address strategyCompoundInput,
        address strategyDsrInput
    );

    function addPauseGuardians(address[] memory guardians) external;
    function ammTreasury() external view returns (address);
    function asset() external view returns (address);
    function confirmTransferOwnership() external;
    function deposit(uint256 amount) external returns (uint256 vaultBalance, uint256 depositedAmount);
    function getImplementation() external view returns (address);
    function getSortedStrategiesWithApy() external view returns (StrategyData[] memory sortedStrategies);
    function getVersion() external view returns (uint256);
    function grantMaxAllowanceForSpender(address assetInput, address spender) external;
    function initialize() external;
    function isPauseGuardian(address account) external view returns (bool);
    function owner() external view returns (address);
    function pause() external;
    function paused() external view returns (bool);
    function proxiableUUID() external view returns (bytes32);
    function removePauseGuardians(address[] memory guardians) external;
    function renounceOwnership() external;
    function revokeAllowanceForSpender(address assetInput, address spender) external;
    function strategyAave() external view returns (address);
    function strategyCompound() external view returns (address);
    function strategyDsr() external view returns (address);
    function totalBalance() external view returns (uint256);
    function transferOwnership(address appointedOwner) external;
    function unpause() external;
    function upgradeTo(address newImplementation) external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
    function withdraw(uint256 amount) external returns (uint256 withdrawnAmount, uint256 vaultBalance);
    function withdrawAll() external returns (uint256 withdrawnAmount, uint256 vaultBalance);
}

