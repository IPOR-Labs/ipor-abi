interface WithdrawManager {
    struct WithdrawRequestInfo {
        uint256 amount;
        uint256 endWithdrawWindowTimestamp;
        bool canWithdraw;
        uint256 withdrawWindowInSeconds;
    }

    error AccessManagedInvalidAuthority(address authority);
    error AccessManagedRequiredDelay(address caller, uint32 delay);
    error AccessManagedUnauthorized(address caller);
    error InvalidInitialization();
    error NotInitializing();
    error SafeCastOverflowedUintDowncast(uint8 bits, uint256 value);
    error WithdrawManagerInvalidTimestamp(uint256 timestamp_);
    error WithdrawWindowLengthCannotBeZero();

    event AuthorityUpdated(address authority);
    event Initialized(uint64 version);
    event ReleaseFundsUpdated(uint256 releaseFunds);
    event WithdrawRequestUpdated(address account, uint256 amount, uint32 endWithdrawWindow);
    event WithdrawWindowLengthUpdated(uint256 withdrawWindowLength);

    function authority() external view returns (address);
    function canWithdrawAndUpdate(address account_, uint256 amount_) external returns (bool);
    function getLastReleaseFundsTimestamp() external view returns (uint256);
    function getWithdrawWindow() external view returns (uint256);
    function isConsumingScheduledOp() external view returns (bytes4);
    function releaseFunds(uint256 timestamp_) external;
    function request(uint256 amount_) external;
    function requestInfo(address account_) external view returns (WithdrawRequestInfo memory);
    function setAuthority(address newAuthority) external;
    function updateWithdrawWindow(uint256 window_) external;
}

