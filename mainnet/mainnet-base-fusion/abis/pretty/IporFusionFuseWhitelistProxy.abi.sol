interface FuseWhitelist {
    struct ReadResult {
        bytes data;
    }

    error AccessControlBadConfirmation();
    error AccessControlUnauthorizedAccount(address account, bytes32 neededRole);
    error AddressEmptyCode(address target);
    error ERC1967InvalidImplementation(address implementation);
    error ERC1967NonPayable();
    error EmptyFuseState();
    error EmptyFuseType();
    error EmptyMetadataType();
    error FailedInnerCall();
    error FuseNotFound(address fuseAddress);
    error FuseStateAlreadyExists(uint256 stateId);
    error FuseTypeAlreadyExists(uint256 fuseId);
    error FuseWhitelistInvalidInputLength();
    error InvalidFuseState(uint16 fuseState);
    error InvalidFuseTypeForInfo(uint256 fuseTypeId);
    error InvalidFuseTypeId(uint256 fuseTypeId);
    error InvalidInitialization();
    error InvalidMetadataType(uint256 metadataId);
    error MetadataTypeAlreadyExists(uint256 metadataId);
    error NotInitializing();
    error UUPSUnauthorizedCallContext();
    error UUPSUnsupportedProxiableUUID(bytes32 slot);
    error UnauthorizedCaller();
    error ZeroAddress();
    error ZeroAddressFuse();
    error ZeroAddressFuseInfo();
    error ZeroDeploymentTimestamp();

    event FuseAddedToListByType(uint16 fuseTypeId, address fuseAddress);
    event FuseAddedToMarketId(address fuseAddress, uint256 marketId);
    event FuseInfoAdded(address fuseAddress, uint16 fuseType, uint32 timestamp);
    event FuseMetadataUpdated(address fuseAddress, uint256 metadataId, bytes32[] metadata);
    event FuseStateAdded(uint16 stateId, string fuseState);
    event FuseStateUpdated(address fuseAddress, uint16 fuseState, uint16 fuseType);
    event FuseTypeAdded(uint16 fuseId, string fuseType);
    event Initialized(uint64 version);
    event MetadataTypeAdded(uint16 metadataId, string metadataType);
    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
    event Upgraded(address indexed implementation);

    function ADD_FUSE_MANAGER_ROLE() external view returns (bytes32);
    function DEFAULT_ADMIN_ROLE() external view returns (bytes32);
    function FUSE_METADATA_MANAGER_ROLE() external view returns (bytes32);
    function FUSE_STATE_MANAGER_ROLE() external view returns (bytes32);
    function FUSE_TYPE_MANAGER_ROLE() external view returns (bytes32);
    function UPDATE_FUSE_METADATA_MANAGER_ROLE() external view returns (bytes32);
    function UPDATE_FUSE_STATE_MANAGER_ROLE() external view returns (bytes32);
    function UPGRADE_INTERFACE_VERSION() external view returns (string memory);
    function addFuseStates(uint16[] memory fuseStateIds_, string[] memory fuseStateNames_) external returns (bool);
    function addFuseTypes(uint16[] memory fuseTypeIds_, string[] memory fuseTypeNames_) external returns (bool);
    function addFuses(
        address[] memory fuses_,
        uint16[] memory types_,
        uint16[] memory states_,
        uint32[] memory deploymentTimestamps_
    ) external returns (bool);
    function addMetadataTypes(uint16[] memory metadataIds_, string[] memory metadataTypes_) external returns (bool);
    function getFuseByAddress(address fuseAddress_)
        external
        view
        returns (uint16 fuseState, uint16 fuseType, address fuseAddress, uint32 timestamp);
    function getFuseStateName(uint16 fuseStateId_) external view returns (string memory);
    function getFuseStates() external view returns (uint16[] memory, string[] memory);
    function getFuseTypeDescription(uint16 fuseTypeId_) external view returns (string memory);
    function getFuseTypes() external view returns (uint16[] memory, string[] memory);
    function getFusesByMarketId(uint256 marketId_) external view returns (address[] memory);
    function getFusesByType(uint16 fuseTypeId_) external view returns (address[] memory);
    function getFusesByTypeAndMarketIdAndStatus(uint16 type_, uint256 marketId_, uint16 status_)
        external
        view
        returns (address[] memory);
    function getMetadataType(uint16 metadataId_) external view returns (string memory);
    function getMetadataTypes() external view returns (uint16[] memory, string[] memory);
    function getRoleAdmin(bytes32 role) external view returns (bytes32);
    function getRoleMember(bytes32 role, uint256 index) external view returns (address);
    function getRoleMemberCount(bytes32 role) external view returns (uint256);
    function grantRole(bytes32 role, address account) external;
    function hasRole(bytes32 role, address account) external view returns (bool);
    function initialize(address initialAdmin_) external;
    function proxiableUUID() external view returns (bytes32);
    function read(address target, bytes memory data) external view returns (ReadResult memory result);
    function readInternal(address target, bytes memory data) external returns (ReadResult memory result);
    function renounceRole(bytes32 role, address callerConfirmation) external;
    function revokeRole(bytes32 role, address account) external;
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
    function updateFuseMetadata(address fuseAddress_, uint16 metadataId_, bytes32[] memory metadata_)
        external
        returns (bool);
    function updateFuseState(address fuseAddress_, uint16 fuseState_) external returns (bool);
    function updateFusesMetadata(
        address[] memory fuseAddresses_,
        uint16[] memory metadataIds_,
        bytes32[][] memory metadatas_
    ) external returns (bool);
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
}

