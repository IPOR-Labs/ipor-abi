interface FeeManager {
    struct FeeManagerInitData {
        address initialAuthority;
        address plasmaVault;
        uint256 iporDaoManagementFee;
        uint256 iporDaoPerformanceFee;
        address iporDaoFeeRecipientAddress;
        RecipientFee[] recipientManagementFees;
        RecipientFee[] recipientPerformanceFees;
    }

    struct HighWaterMarkPerformanceFeeStorage {
        uint128 highWaterMark;
        uint32 lastUpdate;
        uint32 updateInterval;
    }

    struct RecipientFee {
        address recipient;
        uint256 feeValue;
    }

    error AccessManagedInvalidAuthority(address authority);
    error AccessManagedRequiredDelay(address caller, uint32 delay);
    error AccessManagedUnauthorized(address caller);
    error AlreadyInitialized();
    error ContextAlreadySet();
    error ContextNotSet();
    error InvalidAuthority();
    error InvalidFeeRecipientAddress();
    error InvalidHighWaterMark();
    error InvalidInitialization();
    error MathOverflowedMulDiv();
    error NotInitialized();
    error NotInitializing();
    error NotPlasmaVault();
    error SafeCastOverflowedUintDowncast(uint8 bits, uint256 value);
    error UnauthorizedSender();

    event AuthorityUpdated(address authority);
    event ContextCleared(address indexed sender_);
    event ContextSet(address indexed sender_);
    event HarvestManagementFee(address receiver, uint256 amount);
    event HarvestPerformanceFee(address receiver, uint256 amount);
    event HighWaterMarkPerformanceFeeUpdateIntervalUpdated(uint32 updateInterval);
    event HighWaterMarkPerformanceFeeUpdated(uint128 highWaterMark);
    event Initialized(uint64 version);
    event IporDaoFeeRecipientAddressChanged(address indexed newRecipient);
    event ManagementFeeUpdated(uint256 totalFee, address[] recipients, uint256[] fees);
    event PerformanceFeeUpdated(uint256 totalFee, address[] recipients, uint256[] fees);

    function IPOR_DAO_MANAGEMENT_FEE() external view returns (uint256);
    function IPOR_DAO_PERFORMANCE_FEE() external view returns (uint256);
    function MANAGEMENT_FEE_ACCOUNT() external view returns (address);
    function PERFORMANCE_FEE_ACCOUNT() external view returns (address);
    function PLASMA_VAULT() external view returns (address);
    function authority() external view returns (address);
    function calculateAndUpdatePerformanceFee(
        uint128 actualExchangeRate_,
        uint256 totalSupply_,
        uint256 performanceFee_,
        uint256 assetDecimals_
    ) external returns (address recipient, uint256 feeShares);
    function clearContext() external;
    function getIporDaoFeeRecipientAddress() external view returns (address);
    function getManagementFeeRecipients() external view returns (RecipientFee[] memory);
    function getPerformanceFeeRecipients() external view returns (RecipientFee[] memory);
    function getPlasmaVaultHighWaterMarkPerformanceFee()
        external
        view
        returns (HighWaterMarkPerformanceFeeStorage memory);
    function getTotalManagementFee() external view returns (uint256);
    function getTotalPerformanceFee() external view returns (uint256);
    function harvestAllFees() external;
    function harvestManagementFee() external;
    function harvestPerformanceFee() external;
    function initialize() external;
    function isConsumingScheduledOp() external view returns (bytes4);
    function setAuthority(address newAuthority) external;
    function setIporDaoFeeRecipientAddress(address iporDaoFeeRecipientAddress_) external;
    function setupContext(address sender_) external;
    function updateHighWaterMarkPerformanceFee() external;
    function updateIntervalHighWaterMarkPerformanceFee(uint32 updateInterval_) external;
    function updateManagementFee(RecipientFee[] memory recipientFees) external;
    function updatePerformanceFee(RecipientFee[] memory recipientFees) external;
}

