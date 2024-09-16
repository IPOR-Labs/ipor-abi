interface IporProtocolRouter {
    struct DeployedContracts {
        address ammSwapsLens;
        address ammPoolsLens;
        address assetManagementLens;
        address ammOpenSwapService;
        address ammOpenSwapServiceStEth;
        address ammCloseSwapServiceUsdt;
        address ammCloseSwapServiceUsdc;
        address ammCloseSwapServiceDai;
        address ammCloseSwapServiceStEth;
        address ammCloseSwapLens;
        address ammPoolsService;
        address ammGovernanceService;
        address liquidityMiningLens;
        address powerTokenLens;
        address flowService;
        address stakeService;
        address ammPoolsServiceStEth;
        address ammPoolsLensStEth;
        address ammPoolsServiceWeEth;
        address ammPoolsLensWeEth;
        address ammPoolsServiceUsdm;
        address ammPoolsLensUsdm;
    }

    event AdminChanged(address previousAdmin, address newAdmin);
    event AppointedToTransferOwnership(address indexed appointedOwner);
    event BeaconUpgraded(address indexed beacon);
    event Initialized(uint8 version);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event PauseGuardiansAdded(address[] indexed guardians);
    event PauseGuardiansRemoved(address[] indexed guardians);
    event Upgraded(address indexed implementation);

    constructor(DeployedContracts deployedContracts);

    fallback() external payable;

    receive() external payable;

    function addPauseGuardians(address[] memory guardians) external;
    function ammCloseSwapLens() external view returns (address);
    function ammCloseSwapServiceDai() external view returns (address);
    function ammCloseSwapServiceStEth() external view returns (address);
    function ammCloseSwapServiceUsdc() external view returns (address);
    function ammCloseSwapServiceUsdt() external view returns (address);
    function ammGovernanceService() external view returns (address);
    function ammOpenSwapService() external view returns (address);
    function ammOpenSwapServiceStEth() external view returns (address);
    function ammPoolsLens() external view returns (address);
    function ammPoolsLensStEth() external view returns (address);
    function ammPoolsLensUsdm() external view returns (address);
    function ammPoolsLensWeEth() external view returns (address);
    function ammPoolsService() external view returns (address);
    function ammPoolsServiceStEth() external view returns (address);
    function ammPoolsServiceUsdm() external view returns (address);
    function ammPoolsServiceWeEth() external view returns (address);
    function ammSwapsLens() external view returns (address);
    function appointToOwnership(address appointedOwner) external;
    function assetManagementLens() external view returns (address);
    function batchExecutor(bytes[] memory calls) external payable returns (bytes[] memory);
    function confirmAppointmentToOwnership() external;
    function flowService() external view returns (address);
    function getConfiguration() external view returns (DeployedContracts memory);
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
}

