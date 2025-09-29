interface WithdrawManager {
    struct WithdrawRequestInfo {
        uint256 shares;
        uint256 endWithdrawWindowTimestamp;
        bool canWithdraw;
        uint256 withdrawWindowInSeconds;
    }

    error AccessManagedInvalidAuthority(address authority);
    error AccessManagedRequiredDelay(address caller, uint32 delay);
    error AccessManagedUnauthorized(address caller);
    error ContextAlreadySet();
    error ContextNotSet();
    error InvalidInitialization();
    error MathOverflowedMulDiv();
    error NotInitializing();
    error PlasmaVaultAddressCannotBeZero();
    error SafeCastOverflowedUintDowncast(uint8 bits, uint256 value);
    error UnauthorizedSender();
    error WithdrawManagerInvalidFee(uint256 fee);
    error WithdrawManagerInvalidSharesToRelease(
        uint256 sharesToRelease, uint256 shares, uint256 plasmaVaultBalanceOfUnallocatedShares
    );
    error WithdrawManagerInvalidSharesToRelease(uint256 amount_);
    error WithdrawManagerInvalidTimestamp(uint256 timestamp);
    error WithdrawManagerInvalidTimestamp(uint256 lastReleaseFundsTimestamp, uint256 newReleaseFundsTimestamp);
    error WithdrawManagerZeroShares();
    error WithdrawWindowLengthCannotBeZero();

    event AuthorityUpdated(address authority);
    event ContextCleared(address indexed sender_);
    event ContextSet(address indexed sender_);
    event Initialized(uint64 version);
    event PlasmaVaultAddressUpdated(address plasmaVaultAddress);
    event ReleaseFundsUpdated(uint32 releaseTimestamp, uint128 sharesToRelease);
    event RequestFeeUpdated(uint256 fee);
    event WithdrawFeeUpdated(uint256 fee);
    event WithdrawRequestUpdated(address account, uint256 amount, uint32 endWithdrawWindow);
    event WithdrawWindowLengthUpdated(uint256 withdrawWindowLength);

    function authority() external view returns (address);
    function canWithdrawFromRequest(address account_, uint256 shares_) external returns (bool);
    function canWithdrawFromUnallocated(uint256 shares_) external returns (uint256);
    function clearContext() external;
    function getLastReleaseFundsTimestamp() external view returns (uint256);
    function getPlasmaVaultAddress() external view returns (address);
    function getRequestFee() external view returns (uint256);
    function getSharesToRelease() external view returns (uint256);
    function getWithdrawFee() external view returns (uint256);
    function getWithdrawWindow() external view returns (uint256);
    function isConsumingScheduledOp() external view returns (bytes4);
    function proxyInitialize(address accessManager_) external;
    function releaseFunds(uint256 timestamp_, uint256 sharesToRelease_) external;
    function requestInfo(address account_) external view returns (WithdrawRequestInfo memory);
    function requestShares(uint256 shares_) external;
    function setAuthority(address newAuthority) external;
    function setupContext(address sender_) external;
    function updatePlasmaVaultAddress(address plasmaVaultAddress_) external;
    function updateRequestFee(uint256 fee_) external;
    function updateWithdrawFee(uint256 fee_) external;
    function updateWithdrawWindow(uint256 window_) external;
}

