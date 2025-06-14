interface PriceOracleMiddlewareWithRoles {
    error AccessControlBadConfirmation();
    error AccessControlUnauthorizedAccount(address account, bytes32 neededRole);
    error AddressEmptyCode(address target);
    error ArrayLengthMismatch();
    error AssetPriceSourceAlreadySet();
    error AssetsAddressCanNotBeZero();
    error ERC1967InvalidImplementation(address implementation);
    error ERC1967NonPayable();
    error EmptyArrayNotSupported();
    error FailedInnerCall();
    error InvalidExpectedPrice();
    error InvalidInitialization();
    error NotInitializing();
    error PriceDeltaTooHigh();
    error SafeCastOverflowedIntToUint(int256 value);
    error SourceAddressCanNotBeZero();
    error UUPSUnauthorizedCallContext();
    error UUPSUnsupportedProxiableUUID(bytes32 slot);
    error UnexpectedPriceResult();
    error UnsupportedAsset();

    event AssetPriceSourceUpdated(address asset, address source);
    event Initialized(uint64 version);
    event NewPtPriceFeedDeployedEvent(address ptPriceFeed);
    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
    event Upgraded(address indexed implementation);

    function ADD_PT_TOKEN_PRICE() external view returns (bytes32);
    function CHAINLINK_FEED_REGISTRY() external view returns (address);
    function DEFAULT_ADMIN_ROLE() external view returns (bytes32);
    function QUOTE_CURRENCY() external view returns (address);
    function QUOTE_CURRENCY_DECIMALS() external view returns (uint256);
    function SET_ASSETS_PRICES_SOURCES() external view returns (bytes32);
    function UPGRADE_INTERFACE_VERSION() external view returns (string memory);
    function createAndAddPtTokenPriceFeed(
        address pendleOracle_,
        address pendleMarket_,
        uint32 twapWindow_,
        int256 expextedPriceAfterDeployment_,
        uint256 usePendleOracleMethod_
    ) external returns (address ptPriceFeed);
    function getAssetPrice(address asset_) external view returns (uint256 assetPrice, uint256 decimals);
    function getAssetsPrices(address[] memory assets_)
        external
        view
        returns (uint256[] memory assetPrices, uint256[] memory decimalsList);
    function getRoleAdmin(bytes32 role) external view returns (bytes32);
    function getRoleMember(bytes32 role, uint256 index) external view returns (address);
    function getRoleMemberCount(bytes32 role) external view returns (uint256);
    function getSourceOfAssetPrice(address asset_) external view returns (address sourceOfAssetPrice);
    function grantRole(bytes32 role, address account) external;
    function hasRole(bytes32 role, address account) external view returns (bool);
    function initialize(address initialAdmin_) external;
    function proxiableUUID() external view returns (bytes32);
    function renounceRole(bytes32 role, address callerConfirmation) external;
    function revokeRole(bytes32 role, address account) external;
    function setAssetsPricesSources(address[] memory assets_, address[] memory sources_) external;
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
}

