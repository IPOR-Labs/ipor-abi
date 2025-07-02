interface CollateralTokenOnMorphoMarketPriceFeedFactory {
    error AddressEmptyCode(address target);
    error ERC1967InvalidImplementation(address implementation);
    error ERC1967NonPayable();
    error FailedInnerCall();
    error InvalidInitialization();
    error NotInitializing();
    error OwnableInvalidOwner(address owner);
    error OwnableUnauthorizedAccount(address account);
    error PriceFeedAlreadyExists();
    error UUPSUnauthorizedCallContext();
    error UUPSUnsupportedProxiableUUID(bytes32 slot);
    error ZeroAddress();

    event Initialized(uint64 version);
    event OwnershipTransferStarted(address indexed previousOwner, address indexed newOwner);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event PriceFeedCreated(
        address priceFeed,
        address creator,
        address morphoOracle,
        address collateralToken,
        address loanToken,
        address fusionPriceMiddleware
    );
    event Upgraded(address indexed implementation);

    function UPGRADE_INTERFACE_VERSION() external view returns (string memory);
    function acceptOwnership() external;
    function createPriceFeed(
        address morphoOracle_,
        address collateralToken_,
        address loanToken_,
        address priceOracleMiddleware_
    ) external returns (address priceFeed);
    function generateKey(
        address creator_,
        address morphoOracle_,
        address collateralToken_,
        address loanToken_,
        address priceOracleMiddleware_
    ) external pure returns (bytes32);
    function getPriceFeed(
        address creator_,
        address morphoOracle_,
        address collateralToken_,
        address loanToken_,
        address priceOracleMiddleware_
    ) external view returns (address);
    function getPriceFeedAddress(
        address creator_,
        address morphoOracle_,
        address collateralToken_,
        address loanToken_,
        address priceOracleMiddleware_
    ) external view returns (address);
    function initialize(address initialOwner_) external;
    function owner() external view returns (address);
    function pendingOwner() external view returns (address);
    function priceFeeds(uint256) external view returns (address);
    function proxiableUUID() external view returns (bytes32);
    function renounceOwnership() external;
    function transferOwnership(address newOwner) external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
}

