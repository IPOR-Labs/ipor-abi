interface PriceOracleMiddlewareManager {
    struct ReadResult {
        bytes data;
    }

    error AccessManagedInvalidAuthority(address authority);
    error AccessManagedRequiredDelay(address caller, uint32 delay);
    error AccessManagedUnauthorized(address caller);
    error AddressEmptyCode(address target);
    error ArrayLengthMismatch();
    error AssetsAddressCanNotBeZero();
    error ContextAlreadySet();
    error ContextNotSet();
    error EmptyArrayNotSupported();
    error FailedInnerCall();
    error InvalidAuthority();
    error InvalidInitialization();
    error InvalidPriceOracleMiddleware();
    error NotInitializing();
    error PriceOracleMiddlewareCanNotBeZero();
    error SafeCastOverflowedIntToUint(int256 value);
    error SourceAddressCanNotBeZero();
    error UnauthorizedCaller();
    error UnauthorizedSender();
    error UnexpectedPriceResult();
    error UnsupportedAsset();
    error ZeroAddress();

    event AssetPriceSourceAdded(address indexed asset, address indexed source);
    event AssetPriceSourceRemoved(address indexed asset);
    event AuthorityUpdated(address authority);
    event ContextCleared(address indexed sender_);
    event ContextSet(address indexed sender_);
    event Initialized(uint64 version);
    event PriceOracleMiddlewareSet(address indexed priceOracleMiddleware);

    function QUOTE_CURRENCY() external view returns (address);
    function QUOTE_CURRENCY_DECIMALS() external view returns (uint256);
    function authority() external view returns (address);
    function clearContext() external;
    function getAssetPrice(address asset_) external view returns (uint256 assetPrice, uint256 decimals);
    function getAssetsPrices(address[] memory assets_)
        external
        view
        returns (uint256[] memory assetPrices, uint256[] memory decimalsList);
    function getConfiguredAssets() external view returns (address[] memory);
    function getPriceOracleMiddleware() external view returns (address);
    function getSourceOfAssetPrice(address asset_) external view returns (address);
    function isConsumingScheduledOp() external view returns (bytes4);
    function proxyInitialize(address initialAuthority_, address priceOracleMiddleware_) external;
    function read(address target, bytes memory data) external view returns (ReadResult memory result);
    function readInternal(address target, bytes memory data) external returns (ReadResult memory result);
    function removeAssetsPriceSources(address[] memory assets_) external;
    function setAssetsPriceSources(address[] memory assets_, address[] memory sources_) external;
    function setAuthority(address newAuthority) external;
    function setPriceOracleMiddleware(address priceOracleMiddleware_) external;
    function setupContext(address sender_) external;
}

