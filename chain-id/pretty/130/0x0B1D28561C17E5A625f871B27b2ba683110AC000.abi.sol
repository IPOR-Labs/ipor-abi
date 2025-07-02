interface DualCrossReferencePriceFeedFactory {
    error AddressEmptyCode(address target);
    error ERC1967InvalidImplementation(address implementation);
    error ERC1967NonPayable();
    error FailedInnerCall();
    error InvalidAddress();
    error InvalidInitialization();
    error NotInitializing();
    error OwnableInvalidOwner(address owner);
    error OwnableUnauthorizedAccount(address account);
    error UUPSUnauthorizedCallContext();
    error UUPSUnsupportedProxiableUUID(bytes32 slot);

    event DualCrossReferencePriceFeedCreated(
        address priceFeed, address assetX, address assetXAssetYOracleFeed, address assetYUsdOracleFeed
    );
    event Initialized(uint64 version);
    event OwnershipTransferStarted(address indexed previousOwner, address indexed newOwner);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Upgraded(address indexed implementation);

    function UPGRADE_INTERFACE_VERSION() external view returns (string memory);
    function acceptOwnership() external;
    function create(address assetX_, address assetXAssetYOracleFeed_, address assetYUsdOracleFeed_)
        external
        returns (address priceFeed);
    function initialize(address initialFactoryAdmin_) external;
    function owner() external view returns (address);
    function pendingOwner() external view returns (address);
    function proxiableUUID() external view returns (bytes32);
    function renounceOwnership() external;
    function transferOwnership(address newOwner) external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
}

