library Checkpoints {
    struct Checkpoint208 {
        uint48 _key;
        uint208 _value;
    }
}

library PlasmaVaultStorageLib {
    struct ManagementFeeData {
        address feeAccount;
        uint16 feeInPercentage;
        uint32 lastUpdateTimestamp;
    }

    struct PerformanceFeeData {
        address feeAccount;
        uint16 feeInPercentage;
    }
}

interface PlasmaVaultBase {
    struct InstantWithdrawalFusesParamsStruct {
        address fuse;
        bytes32[] params;
    }

    struct MarketLimit {
        uint256 marketId;
        uint256 limitInPercentage;
    }

    error AccessManagedInvalidAuthority(address authority);
    error AccessManagedRequiredDelay(address caller, uint32 delay);
    error AccessManagedUnauthorized(address caller);
    error AddressEmptyCode(address target);
    error BalanceFuseAlreadyExists(uint256 marketId, address fuse);
    error BalanceFuseDoesNotExist(uint256 marketId, address fuse);
    error BalanceFuseNotReadyToRemove(uint256 marketId, address fuse, uint256 currentBalance);
    error CheckpointUnorderedInsertion();
    error ContextAlreadySet();
    error ContextNotSet();
    error ECDSAInvalidSignature();
    error ECDSAInvalidSignatureLength(uint256 length);
    error ECDSAInvalidSignatureS(bytes32 s);
    error ERC20ExceededCap(uint256 increasedSupply, uint256 cap);
    error ERC20InsufficientAllowance(address spender, uint256 allowance, uint256 needed);
    error ERC20InsufficientBalance(address sender, uint256 balance, uint256 needed);
    error ERC20InvalidApprover(address approver);
    error ERC20InvalidCap(uint256 cap);
    error ERC20InvalidReceiver(address receiver);
    error ERC20InvalidSender(address sender);
    error ERC20InvalidSpender(address spender);
    error ERC2612ExpiredSignature(uint256 deadline);
    error ERC2612InvalidSigner(address signer, address owner);
    error ERC5805FutureLookup(uint256 timepoint, uint48 clock);
    error ERC6372InconsistentClock();
    error FailedInnerCall();
    error FuseAlreadyExists();
    error FuseDoesNotExist();
    error FuseUnsupported(address fuse);
    error InvalidAccountNonce(address account, uint256 currentNonce);
    error InvalidInitialization();
    error InvalidManagementFee(uint256 feeInPercentage);
    error InvalidPerformanceFee(uint256 feeInPercentage);
    error MarketLimitSetupInPercentageIsTooHigh(uint256 limit);
    error NotInitializing();
    error PreHooksLibInvalidArrayLength();
    error PreHooksLibInvalidSelector();
    error SafeCastOverflowedUintDowncast(uint8 bits, uint256 value);
    error UnauthorizedSender();
    error UnsupportedPriceOracleMiddleware();
    error VotesExpiredSignature(uint256 expiry);
    error WrongAddress();
    error WrongArrayLength();
    error WrongMarketId(uint256 marketId);
    error WrongValue();

    event Approval(address indexed owner, address indexed spender, uint256 value);
    event AuthorityUpdated(address authority);
    event BalanceFuseAdded(uint256 marketId, address fuse);
    event BalanceFuseRemoved(uint256 marketId, address fuse);
    event CallbackHandlerUpdated(address indexed handler, address indexed sender, bytes4 indexed sig);
    event ContextCleared(address indexed sender_);
    event ContextSet(address indexed sender_);
    event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
    event DelegateVotesChanged(address indexed delegate, uint256 previousVotes, uint256 newVotes);
    event EIP712DomainChanged();
    event FuseAdded(address fuse);
    event FuseRemoved(address fuse);
    event Initialized(uint64 version);
    event InstantWithdrawalFusesConfigured(InstantWithdrawalFusesParamsStruct[] fuses);
    event ManagementFeeDataConfigured(address feeAccount, uint256 feeInPercentage);
    event MarketLimitUpdated(uint256 marketId, uint256 newLimit);
    event MarketSubstratesGranted(uint256 marketId, bytes32[] substrates);
    event MarketsLimitsActivated();
    event MarketsLimitsDeactivated();
    event PerformanceFeeDataConfigured(address feeAccount, uint256 feeInPercentage);
    event PreHookImplementationChanged(bytes4 indexed selector, address newImplementation);
    event PriceOracleMiddlewareChanged(address newPriceOracleMiddleware);
    event RewardsClaimManagerAddressChanged(address newRewardsClaimManagerAddress);
    event Transfer(address indexed from, address indexed to, uint256 value);

    function CLOCK_MODE() external view returns (string memory);
    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function activateMarketsLimits() external;
    function addBalanceFuse(uint256 marketId_, address fuse_) external;
    function addFuses(address[] memory fuses_) external;
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
    function authority() external view returns (address);
    function balanceOf(address account) external view returns (uint256);
    function cap() external view returns (uint256);
    function checkpoints(address account, uint32 pos) external view returns (Checkpoints.Checkpoint208 memory);
    function clearContext() external;
    function clock() external view returns (uint48);
    function configureInstantWithdrawalFuses(InstantWithdrawalFusesParamsStruct[] memory fuses_) external;
    function configureManagementFee(address feeAccount_, uint256 feeInPercentage_) external;
    function configurePerformanceFee(address feeAccount_, uint256 feeInPercentage_) external;
    function convertToPublicVault() external;
    function deactivateMarketsLimits() external;
    function decimals() external view returns (uint8);
    function delegate(address delegatee) external;
    function delegateBySig(address delegatee, uint256 nonce, uint256 expiry, uint8 v, bytes32 r, bytes32 s) external;
    function delegates(address account) external view returns (address);
    function eip712Domain()
        external
        view
        returns (
            bytes1 fields,
            string memory name,
            string memory version,
            uint256 chainId,
            address verifyingContract,
            bytes32 salt,
            uint256[] memory extensions
        );
    function enableTransferShares() external;
    function getAccessManagerAddress() external view returns (address);
    function getActiveMarketsInBalanceFuses() external view returns (uint256[] memory);
    function getDependencyBalanceGraph(uint256 marketId_) external view returns (uint256[] memory);
    function getFuses() external view returns (address[] memory);
    function getInstantWithdrawalFuses() external view returns (address[] memory);
    function getInstantWithdrawalFusesParams(address fuse_, uint256 index_) external view returns (bytes32[] memory);
    function getManagementFeeData() external view returns (PlasmaVaultStorageLib.ManagementFeeData memory feeData);
    function getMarketLimit(uint256 marketId_) external view returns (uint256);
    function getMarketSubstrates(uint256 marketId_) external view returns (bytes32[] memory);
    function getPastTotalSupply(uint256 timepoint) external view returns (uint256);
    function getPastVotes(address account, uint256 timepoint) external view returns (uint256);
    function getPerformanceFeeData() external view returns (PlasmaVaultStorageLib.PerformanceFeeData memory feeData);
    function getPreHookImplementation(bytes4 selector_) external view returns (address);
    function getPreHookSelectors() external view returns (bytes4[] memory);
    function getPriceOracleMiddleware() external view returns (address);
    function getRewardsClaimManagerAddress() external view returns (address);
    function getTotalSupplyCap() external view returns (uint256);
    function getVotes(address account) external view returns (uint256);
    function grantMarketSubstrates(uint256 marketId_, bytes32[] memory substrates_) external;
    function init(string memory assetName_, address accessManager_, uint256 totalSupplyCap_) external;
    function isBalanceFuseSupported(uint256 marketId_, address fuse_) external view returns (bool);
    function isConsumingScheduledOp() external view returns (bytes4);
    function isFuseSupported(address fuse_) external view returns (bool);
    function isMarketSubstrateGranted(uint256 marketId_, bytes32 substrate_) external view returns (bool);
    function isMarketsLimitsActivated() external view returns (bool);
    function name() external view returns (string memory);
    function nonces(address owner_) external view returns (uint256);
    function numCheckpoints(address account) external view returns (uint32);
    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s)
        external;
    function removeBalanceFuse(uint256 marketId_, address fuse_) external;
    function removeFuses(address[] memory fuses_) external;
    function setAuthority(address newAuthority) external;
    function setMinimalExecutionDelaysForRoles(uint64[] memory rolesIds_, uint256[] memory delays_) external;
    function setPreHookImplementations(bytes4[] memory selectors_, address[] memory implementations_) external;
    function setPriceOracleMiddleware(address priceOracleMiddleware_) external;
    function setRewardsClaimManagerAddress(address rewardsClaimManagerAddress_) external;
    function setTotalSupplyCap(uint256 cap_) external;
    function setupContext(address sender_) external;
    function setupMarketsLimits(MarketLimit[] memory marketsLimits_) external;
    function symbol() external view returns (string memory);
    function totalSupply() external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function updateCallbackHandler(address handler_, address sender_, bytes4 sig_) external;
    function updateDependencyBalanceGraphs(uint256[] memory marketIds_, uint256[][] memory dependencies_) external;
    function updateInternal(address from_, address to_, uint256 value_) external;
}

