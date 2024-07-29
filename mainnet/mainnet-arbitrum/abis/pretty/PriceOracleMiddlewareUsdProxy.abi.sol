interface PriceOracleMiddleware {
    error AddressEmptyCode(address target);
    error ArrayLengthMismatch();
    error AssetsAddressCanNotBeZero();
    error ERC1967InvalidImplementation(address implementation);
    error ERC1967NonPayable();
    error EmptyArrayNotSupported();
    error FailedInnerCall();
    error InvalidInitialization();
    error NotInitializing();
    error OwnableInvalidOwner(address owner);
    error OwnableUnauthorizedAccount(address account);
    error SafeCastOverflowedIntToUint(int256 value);
    error SourceAddressCanNotBeZero();
    error UUPSUnauthorizedCallContext();
    error UUPSUnsupportedProxiableUUID(bytes32 slot);
    error UnexpectedPriceResult();
    error UnsupportedAsset();
    error WrongDecimals();
    error ZeroAddress(string variableName);

    event AssetPriceSourceUpdated(address asset, address source);
    event Initialized(uint64 version);
    event OwnershipTransferStarted(address indexed previousOwner, address indexed newOwner);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Upgraded(address indexed implementation);

    function BASE_CURRENCY() external view returns (address);
    function BASE_CURRENCY_DECIMALS() external view returns (uint256);
    function CHAINLINK_FEED_REGISTRY() external view returns (address);
    function UPGRADE_INTERFACE_VERSION() external view returns (string memory);
    function acceptOwnership() external;
    function getAssetPrice(address asset_) external view returns (uint256);
    function getAssetsPrices(address[] memory assets_) external view returns (uint256[] memory);
    function getSourceOfAssetPrice(address asset_) external view returns (address);
    function initialize(address initialOwner_) external;
    function owner() external view returns (address);
    function pendingOwner() external view returns (address);
    function proxiableUUID() external view returns (bytes32);
    function renounceOwnership() external;
    function setAssetsPricesSources(address[] memory assets_, address[] memory sources_) external;
    function transferOwnership(address newOwner) external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
}

