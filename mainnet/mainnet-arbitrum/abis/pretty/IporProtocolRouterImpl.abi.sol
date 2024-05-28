interface IporProtocolRouterArbitrum {
    struct DeployedContractsArbitrum {
        address ammSwapsLens;
        address ammPoolsLens;
        address ammCloseSwapLens;
        address ammGovernanceService;
        address flowService;
        address stakeService;
        address powerTokenLens;
        address liquidityMiningLens;
        address wstEth;
        address usdc;
        address usdm;
    }

    event AdminChanged(address previousAdmin, address newAdmin);
    event AppointedToTransferOwnership(address indexed appointedOwner);
    event BeaconUpgraded(address indexed beacon);
    event Initialized(uint8 version);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event PauseGuardiansAdded(address[] indexed guardians);
    event PauseGuardiansRemoved(address[] indexed guardians);
    event Upgraded(address indexed implementation);

    fallback() external payable;

    receive() external payable;

    function addPauseGuardians(address[] memory guardians) external;
    function ammCloseSwapLens() external view returns (address);
    function ammGovernanceService() external view returns (address);
    function ammPoolsLens() external view returns (address);
    function ammSwapsLens() external view returns (address);
    function appointToOwnership(address appointedOwner) external;
    function batchExecutor(bytes[] memory calls) external payable returns (bytes[] memory);
    function confirmAppointmentToOwnership() external;
    function flowService() external view returns (address);
    function getConfiguration() external view returns (DeployedContractsArbitrum memory);
    function getImplementation() external view returns (address);
    function initialize(bool pausedInput) external;
    function isPauseGuardian(address account) external view returns (bool);
    function liquidityMiningLens() external view returns (address);
    function owner() external view returns (address);
    function pause(bytes4[] memory functionSigs) external;
    function paused(bytes4 functionSig) external view returns (uint256);
    function powerTokenLens() external view returns (address);
    function proxiableUUID() external view returns (bytes32);
    function removePauseGuardians(address[] memory guardians) external;
    function renounceOwnership() external;
    function stakeService() external view returns (address);
    function unpause(bytes4[] memory functionSigs) external;
    function upgradeTo(address newImplementation) external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
    function usdc() external view returns (address);
    function usdm() external view returns (address);
    function wstEth() external view returns (address);
}

