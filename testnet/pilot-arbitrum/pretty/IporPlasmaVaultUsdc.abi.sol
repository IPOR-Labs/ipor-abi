interface PlasmaVault {
    struct FeeConfig {
        address performanceFeeManager;
        uint256 performanceFeeInPercentage;
        address managementFeeManager;
        uint256 managementFeeInPercentage;
    }

    struct FuseAction {
        address fuse;
        bytes data;
    }

    struct MarketBalanceFuseConfig {
        uint256 marketId;
        address fuse;
    }

    struct MarketSubstratesConfig {
        uint256 marketId;
        bytes32[] substrates;
    }

    struct PlasmaVaultInitData {
        string assetName;
        string assetSymbol;
        address underlyingToken;
        address priceOracleMiddleware;
        address[] alphas;
        MarketSubstratesConfig[] marketSubstratesConfigs;
        address[] fuses;
        MarketBalanceFuseConfig[] balanceFuses;
        FeeConfig feeConfig;
        address accessManager;
        address plasmaVaultBase;
        uint256 totalSupplyCap;
    }

    error AccessManagedInvalidAuthority(address authority);
    error AccessManagedRequiredDelay(address caller, uint32 delay);
    error AccessManagedUnauthorized(address caller);
    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error ERC20InsufficientAllowance(address spender, uint256 allowance, uint256 needed);
    error ERC20InsufficientBalance(address sender, uint256 balance, uint256 needed);
    error ERC20InvalidApprover(address approver);
    error ERC20InvalidReceiver(address receiver);
    error ERC20InvalidSender(address sender);
    error ERC20InvalidSpender(address spender);
    error ERC4626ExceededMaxDeposit(address receiver, uint256 assets, uint256 max);
    error ERC4626ExceededMaxMint(address receiver, uint256 shares, uint256 max);
    error ERC4626ExceededMaxRedeem(address owner, uint256 shares, uint256 max);
    error ERC4626ExceededMaxWithdraw(address owner, uint256 assets, uint256 max);
    error FailedInnerCall();
    error HandlerNotFound();
    error InvalidInitialization();
    error InvalidPerformanceFee(uint256 feeInPercentage);
    error MarketLimitExceeded(uint256 marketId, uint256 balanceInMarket, uint256 limit);
    error MathOverflowedMulDiv();
    error NoAssetsToDeposit();
    error NoAssetsToWithdraw();
    error NoSharesToMint();
    error NoSharesToRedeem();
    error NotInitializing();
    error ReentrancyGuardReentrantCall();
    error SafeCastOverflowedIntToUint(int256 value);
    error SafeCastOverflowedUintDowncast(uint8 bits, uint256 value);
    error SafeCastOverflowedUintToInt(uint256 value);
    error SafeERC20FailedOperation(address token);
    error UnsupportedFuse();
    error UnsupportedMethod();
    error UnsupportedQuoteCurrencyFromOracle();
    error WrongAddress();
    error WrongCaller(address caller);

    event Approval(address indexed owner, address indexed spender, uint256 value);
    event AuthorityUpdated(address authority);
    event Deposit(address indexed sender, address indexed owner, uint256 assets, uint256 shares);
    event Initialized(uint64 version);
    event ManagementFeeDataConfigured(address feeManager, uint256 feeInPercentage);
    event ManagementFeeRealized(uint256 unrealizedFeeInUnderlying, uint256 unrealizedFeeInShares);
    event MarketBalancesUpdated(uint256[] marketIds, int256 deltaInUnderlying);
    event MarketSubstratesGranted(uint256 marketId, bytes32[] substrates);
    event PerformanceFeeDataConfigured(address feeManager, uint256 feeInPercentage);
    event PriceOracleMiddlewareChanged(address newPriceOracleMiddleware);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Withdraw(
        address indexed sender, address indexed receiver, address indexed owner, uint256 assets, uint256 shares
    );

    fallback() external;

    function DEFAULT_SLIPPAGE_IN_PERCENTAGE() external view returns (uint256);
    function PLASMA_VAULT_BASE() external view returns (address);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
    function asset() external view returns (address);
    function authority() external view returns (address);
    function balanceOf(address account) external view returns (uint256);
    function claimRewards(FuseAction[] memory calls_) external;
    function convertToAssets(uint256 shares) external view returns (uint256);
    function convertToShares(uint256 assets) external view returns (uint256);
    function decimals() external view returns (uint8);
    function deposit(uint256 assets_, address receiver_) external returns (uint256);
    function depositWithPermit(
        uint256 assets_,
        address owner_,
        address receiver_,
        uint256 deadline_,
        uint8 v_,
        bytes32 r_,
        bytes32 s_
    ) external returns (uint256);
    function execute(FuseAction[] memory calls_) external;
    function executeInternal(FuseAction[] memory calls_) external;
    function getUnrealizedManagementFee() external view returns (uint256);
    function isConsumingScheduledOp() external view returns (bytes4);
    function maxDeposit(address) external view returns (uint256);
    function maxMint(address) external view returns (uint256);
    function maxRedeem(address owner) external view returns (uint256);
    function maxWithdraw(address owner) external view returns (uint256);
    function mint(uint256 shares_, address receiver_) external returns (uint256);
    function name() external view returns (string memory);
    function previewDeposit(uint256 assets) external view returns (uint256);
    function previewMint(uint256 shares) external view returns (uint256);
    function previewRedeem(uint256 shares) external view returns (uint256);
    function previewWithdraw(uint256 assets) external view returns (uint256);
    function redeem(uint256 shares_, address receiver_, address owner_) external returns (uint256);
    function setAuthority(address newAuthority) external;
    function symbol() external view returns (string memory);
    function totalAssets() external view returns (uint256);
    function totalAssetsInMarket(uint256 marketId_) external view returns (uint256);
    function totalSupply() external view returns (uint256);
    function transfer(address to_, uint256 value_) external returns (bool);
    function transferFrom(address from_, address to_, uint256 value_) external returns (bool);
    function updateInternal(address, address, uint256) external;
    function withdraw(uint256 assets_, address receiver_, address owner_) external returns (uint256);
}

