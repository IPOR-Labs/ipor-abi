interface WrappedPlasmaVaultFactory {
    error AddressEmptyCode(address target);
    error ERC1967InvalidImplementation(address implementation);
    error ERC1967NonPayable();
    error FailedInnerCall();
    error InvalidAddress();
    error InvalidFeePercentage();
    error InvalidInitialization();
    error NotInitializing();
    error OwnableInvalidOwner(address owner);
    error OwnableUnauthorizedAccount(address account);
    error UUPSUnauthorizedCallContext();
    error UUPSUnsupportedProxiableUUID(bytes32 slot);

    event Initialized(uint64 version);
    event OwnershipTransferStarted(address indexed previousOwner, address indexed newOwner);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Upgraded(address indexed implementation);
    event WrappedPlasmaVaultCreated(
        string name,
        string symbol,
        address plasmaVault,
        address wrappedPlasmaVaultOwner,
        address wrappedPlasmaVault,
        address managementFeeAccount,
        uint256 managementFeePercentage,
        address performanceFeeAccount,
        uint256 performanceFeePercentage
    );

    function UPGRADE_INTERFACE_VERSION() external view returns (string memory);
    function acceptOwnership() external;
    function create(
        string memory name_,
        string memory symbol_,
        address plasmaVault_,
        address wrappedPlasmaVaultOwner_,
        address managementFeeAccount_,
        uint256 managementFeePercentage_,
        address performanceFeeAccount_,
        uint256 performanceFeePercentage_
    ) external returns (address wrappedPlasmaVault);
    function initialize(address initialFactoryAdmin_) external;
    function owner() external view returns (address);
    function pendingOwner() external view returns (address);
    function proxiableUUID() external view returns (bytes32);
    function renounceOwnership() external;
    function transferOwnership(address newOwner) external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
}

