interface IporPlasmaVault {
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

    struct InstantWithdrawalFusesParamsStruct {
        address fuse;
        bytes32[] params;
    }

    struct ManagementFeeData {
        address feeManager;
        uint16 feeInPercentage;
        uint32 lastUpdateTimestamp;
    }

    struct MarketBalanceFuseConfig {
        uint256 marketId;
        address fuse;
    }

    struct MarketLimit {
        uint256 marketId;
        uint256 limitInPercentage;
    }

    struct MarketSubstratesConfig {
        uint256 marketId;
        bytes32[] substrates;
    }

    struct PerformanceFeeData {
        address feeManager;
        uint16 feeInPercentage;
    }

    struct PlasmaVaultInitData {
        string assetName;
        string assetSymbol;
        address underlyingToken;
        address priceOracle;
        address[] alphas;
        MarketSubstratesConfig[] marketSubstratesConfigs;
        address[] fuses;
        MarketBalanceFuseConfig[] balanceFuses;
        FeeConfig feeConfig;
        address accessManager;
    }

    error AccessManagedInvalidAuthority(address authority);
    error AccessManagedRequiredDelay(address caller, uint32 delay);
    error AccessManagedUnauthorized(address caller);
    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error BalanceFuseAlreadyExists(uint256 marketId, address fuse);
    error BalanceFuseDoesNotExist(uint256 marketId, address fuse);
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
    error FuseAlreadyExists();
    error FuseDoesNotExist();
    error InvalidPerformanceFee(uint256 feeInPercentage);
    error MarketLimitExceeded(uint256 marketId, uint256 balanceInMarket, uint256 limit);
    error MathOverflowedMulDiv();
    error NoAssetsToDeposit();
    error NoAssetsToWithdraw();
    error NoSharesToMint();
    error NoSharesToRedeem();
    error ReentrancyGuardReentrantCall();
    error SafeCastOverflowedIntToUint(int256 value);
    error SafeCastOverflowedUintDowncast(uint8 bits, uint256 value);
    error SafeCastOverflowedUintToInt(uint256 value);
    error SafeERC20FailedOperation(address token);
    error UnsupportedBaseCurrencyFromOracle();
    error UnsupportedFuse();
    error UnsupportedPriceOracle();
    error WrongAddress();
    error WrongArrayLength();
    error WrongMarketId(uint256 marketId);

    event Approval(address indexed owner, address indexed spender, uint256 value);
    event AuthorityUpdated(address authority);
    event BalanceFuseAdded(uint256 marketId, address fuse);
    event BalanceFuseRemoved(uint256 marketId, address fuse);
    event Deposit(address indexed sender, address indexed owner, uint256 assets, uint256 shares);
    event FuseAdded(address fuse);
    event FuseRemoved(address fuse);
    event InstantWithdrawalFusesConfigured(InstantWithdrawalFusesParamsStruct[] fuses);
    event ManagementFeeDataConfigured(address feeManager, uint256 feeInPercentage);
    event ManagementFeeRealized(uint256 unrealizedFeeInUnderlying, uint256 unrealizedFeeInShares);
    event MarketBalancesUpdated(uint256[] marketIds, int256 deltaInUnderlying);
    event MarketLimitUpdated(uint256 marketId, uint256 newLimit);
    event MarketSubstratesGranted(uint256 marketId, bytes32[] substrates);
    event MarketsLimitsActivated();
    event MarketsLimitsDeactivated();
    event PerformanceFeeDataConfigured(address feeManager, uint256 feeInPercentage);
    event PriceOracleChanged(address newPriceOracle);
    event RewardsClaimManagerAddressChanged(address newRewardsClaimManagerAddress);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Withdraw(
        address indexed sender, address indexed receiver, address indexed owner, uint256 assets, uint256 shares
    );

    fallback() external;

    function BASE_CURRENCY_DECIMALS() external view returns (uint256);
    function DEFAULT_SLIPPAGE_IN_PERCENTAGE() external view returns (uint256);
    function activateMarketsLimits() external;
    function addBalanceFuse(uint256 marketId_, address fuse_) external;
    function addFuses(address[] memory fuses_) external;
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
    function asset() external view returns (address);
    function authority() external view returns (address);
    function balanceOf(address account) external view returns (uint256);
    function claimRewards(FuseAction[] memory calls_) external;
    function configureInstantWithdrawalFuses(InstantWithdrawalFusesParamsStruct[] memory fuses_) external;
    function configureManagementFee(address feeManager_, uint256 feeInPercentage_) external;
    function configurePerformanceFee(address feeManager_, uint256 feeInPercentage_) external;
    function convertToAssets(uint256 shares) external view returns (uint256);
    function convertToShares(uint256 assets) external view returns (uint256);
    function deactivateMarketsLimits() external;
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
    function getAccessManagerAddress() external view returns (address);
    function getDependencyBalanceGraph(uint256 marketId_) external view returns (uint256[] memory);
    function getFuses() external view returns (address[] memory);
    function getInstantWithdrawalFuses() external view returns (address[] memory);
    function getInstantWithdrawalFusesParams(address fuse_, uint256 index_) external view returns (bytes32[] memory);
    function getManagementFeeData() external view returns (ManagementFeeData memory feeData);
    function getMarketLimit(uint256 marketId_) external view returns (uint256);
    function getPerformanceFeeData() external view returns (PerformanceFeeData memory feeData);
    function getPriceOracle() external view returns (address);
    function getRewardsClaimManagerAddress() external view returns (address);
    function getUniqueElements(uint256[] memory inputArray) external pure returns (uint256[] memory);
    function getUnrealizedManagementFee() external view returns (uint256);
    function grandMarketSubstrates(uint256 marketId_, bytes32[] memory substrates_) external;
    function isBalanceFuseSupported(uint256 marketId_, address fuse_) external view returns (bool);
    function isConsumingScheduledOp() external view returns (bytes4);
    function isFuseSupported(address fuse_) external view returns (bool);
    function isMarketSubstrateGranted(uint256 marketId_, bytes32 substrate_) external view returns (bool);
    function isMarketsLimitsActivated() external view returns (bool);
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
    function removeBalanceFuse(uint256 marketId_, address fuse_) external;
    function removeFuses(address[] memory fuses_) external;
    function setAuthority(address newAuthority) external;
    function setPriceOracle(address priceOracle_) external;
    function setRewardsClaimManagerAddress(address rewardsClaimManagerAddress_) external;
    function setupMarketsLimits(MarketLimit[] memory marketsLimits_) external;
    function symbol() external view returns (string memory);
    function totalAssets() external view returns (uint256);
    function totalAssetsInMarket(uint256 marketId_) external view returns (uint256);
    function totalSupply() external view returns (uint256);
    function transfer(address to_, uint256 value_) external returns (bool);
    function transferFrom(address from_, address to_, uint256 value_) external returns (bool);
    function updateDependencyBalanceGraphs(uint256[] memory marketIds_, uint256[][] memory dependencies_) external;
    function withdraw(uint256 assets_, address receiver_, address owner_) external returns (uint256);
}

