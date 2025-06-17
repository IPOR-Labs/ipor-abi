library FusionFactoryLib {
    struct FusionInstance {
        uint256 index;
        uint256 version;
        string assetName;
        string assetSymbol;
        uint8 assetDecimals;
        address underlyingToken;
        string underlyingTokenSymbol;
        uint8 underlyingTokenDecimals;
        address initialOwner;
        address plasmaVault;
        address plasmaVaultBase;
        address accessManager;
        address feeManager;
        address rewardsManager;
        address withdrawManager;
        address contextManager;
        address priceManager;
    }
}

library FusionFactoryStorageLib {
    struct FactoryAddresses {
        address accessManagerFactory;
        address plasmaVaultFactory;
        address feeManagerFactory;
        address withdrawManagerFactory;
        address rewardsManagerFactory;
        address contextManagerFactory;
        address priceManagerFactory;
    }
}

interface FusionFactory {
    error AccessControlBadConfirmation();
    error AccessControlUnauthorizedAccount(address account, bytes32 neededRole);
    error AddressEmptyCode(address target);
    error ERC1967InvalidImplementation(address implementation);
    error ERC1967NonPayable();
    error EnforcedPause();
    error ExpectedPause();
    error FailedInnerCall();
    error InvalidAddress();
    error InvalidFactoryAddress();
    error InvalidFeeValue();
    error InvalidInitialization();
    error InvalidRedemptionDelay();
    error InvalidWithdrawWindow();
    error NotInitializing();
    error UUPSUnauthorizedCallContext();
    error UUPSUnsupportedProxiableUUID(bytes32 slot);

    event BurnRequestFeeBalanceFuseUpdated(address newBurnRequestFeeBalanceFuse);
    event BurnRequestFeeFuseUpdated(address newBurnRequestFeeFuse);
    event DaoFeeUpdated(address newDaoFeeRecipient, uint256 newDaoManagementFee, uint256 newDaoPerformanceFee);
    event FactoryAddressesUpdated(
        uint256 version,
        address accessManagerFactory,
        address plasmaVaultFactory,
        address feeManagerFactory,
        address withdrawManagerFactory,
        address rewardsManagerFactory,
        address contextManagerFactory,
        address priceManagerFactory
    );
    event Initialized(uint64 version);
    event Paused(address account);
    event PlasmaVaultAdminArrayUpdated(address[] newPlasmaVaultAdminArray);
    event PlasmaVaultBaseUpdated(address newPlasmaVaultBase);
    event PriceOracleMiddlewareUpdated(address newPriceOracleMiddleware);
    event RedemptionDelayInSecondsUpdated(uint256 newRedemptionDelayInSeconds);
    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
    event Unpaused(address account);
    event Upgraded(address indexed implementation);
    event VestingPeriodInSecondsUpdated(uint256 newVestingPeriodInSeconds);
    event WithdrawWindowInSecondsUpdated(uint256 newWithdrawWindowInSeconds);

    function DAO_FEE_MANAGER_ROLE() external view returns (bytes32);
    function DEFAULT_ADMIN_ROLE() external view returns (bytes32);
    function MAINTENANCE_MANAGER_ROLE() external view returns (bytes32);
    function PAUSE_MANAGER_ROLE() external view returns (bytes32);
    function UPGRADE_INTERFACE_VERSION() external view returns (string memory);
    function create(string memory assetName_, string memory assetSymbol_, address underlyingToken_, address owner_)
        external
        returns (FusionFactoryLib.FusionInstance memory);
    function getBurnRequestFeeBalanceFuseAddress() external view returns (address);
    function getBurnRequestFeeFuseAddress() external view returns (address);
    function getDaoFeeRecipientAddress() external view returns (address);
    function getDaoManagementFee() external view returns (uint256);
    function getDaoPerformanceFee() external view returns (uint256);
    function getFactoryAddresses() external view returns (FusionFactoryStorageLib.FactoryAddresses memory);
    function getFusionFactoryIndex() external view returns (uint256);
    function getFusionFactoryVersion() external view returns (uint256);
    function getPlasmaVaultAdminArray() external view returns (address[] memory);
    function getPlasmaVaultBaseAddress() external view returns (address);
    function getPriceOracleMiddleware() external view returns (address);
    function getRedemptionDelayInSeconds() external view returns (uint256);
    function getRoleAdmin(bytes32 role) external view returns (bytes32);
    function getRoleMember(bytes32 role, uint256 index) external view returns (address);
    function getRoleMemberCount(bytes32 role) external view returns (uint256);
    function getVestingPeriodInSeconds() external view returns (uint256);
    function getWithdrawWindowInSeconds() external view returns (uint256);
    function grantRole(bytes32 role, address account) external;
    function hasRole(bytes32 role, address account) external view returns (bool);
    function initialize(
        address initialFactoryAdmin_,
        address[] memory initialPlasmaVaultAdminArray_,
        FusionFactoryStorageLib.FactoryAddresses memory factoryAddresses_,
        address plasmaVaultBase_,
        address priceOracleMiddleware_,
        address burnRequestFeeFuse_,
        address burnRequestFeeBalanceFuse_
    ) external;
    function pause() external;
    function paused() external view returns (bool);
    function proxiableUUID() external view returns (bytes32);
    function renounceRole(bytes32 role, address callerConfirmation) external;
    function revokeRole(bytes32 role, address account) external;
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
    function unpause() external;
    function updateBurnRequestFeeBalanceFuse(address newBurnRequestFeeBalanceFuse_) external;
    function updateBurnRequestFeeFuse(address newBurnRequestFeeFuse_) external;
    function updateDaoFee(address newDaoFeeRecipient_, uint256 newDaoManagementFee_, uint256 newDaoPerformanceFee_)
        external;
    function updateFactoryAddresses(
        uint256 version_,
        FusionFactoryStorageLib.FactoryAddresses memory newFactoryAddresses_
    ) external;
    function updatePlasmaVaultAdminArray(address[] memory newPlasmaVaultAdminArray_) external;
    function updatePlasmaVaultBase(address newPlasmaVaultBase_) external;
    function updatePriceOracleMiddleware(address newPriceOracleMiddleware_) external;
    function updateRedemptionDelayInSeconds(uint256 newRedemptionDelayInSeconds_) external;
    function updateVestingPeriodInSeconds(uint256 newVestingPeriodInSeconds_) external;
    function updateWithdrawWindowInSeconds(uint256 newWithdrawWindowInSeconds_) external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
}

