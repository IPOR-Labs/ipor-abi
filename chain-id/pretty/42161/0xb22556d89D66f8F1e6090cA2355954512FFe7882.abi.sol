interface RewardsClaimManager {
    struct FuseAction {
        address fuse;
        bytes data;
    }

    struct VestingData {
        uint32 vestingTime;
        uint32 updateBalanceTimestamp;
        uint128 transferredTokens;
        uint128 lastUpdateBalance;
    }

    error AccessManagedInvalidAuthority(address authority);
    error AccessManagedRequiredDelay(address caller, uint32 delay);
    error AccessManagedUnauthorized(address caller);
    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error FuseAlreadyExists();
    error FuseDoesNotExist();
    error FuseUnsupported(address fuse);
    error MathOverflowedMulDiv();
    error SafeCastOverflowedUintDowncast(uint8 bits, uint256 value);
    error SafeERC20FailedOperation(address token);
    error UnableToTransferUnderlyingToken();

    event AmountWithdrawn(uint256 amount);
    event AuthorityUpdated(address authority);
    event FuseAdded(address fuse);
    event FuseRemoved(address fuse);
    event TransferredTokensUpdated(uint128 transferredTokens);
    event VestingDataUpdated(
        uint128 transferredTokens, uint128 balanceOnLastUpdate, uint32 vestingTime, uint32 lastUpdateBalance
    );
    event VestingTimeUpdated(uint256 vestingTime);

    function PLASMA_VAULT() external view returns (address);
    function UNDERLYING_TOKEN() external view returns (address);
    function addRewardFuses(address[] memory fuses_) external;
    function authority() external view returns (address);
    function balanceOf() external view returns (uint256);
    function claimRewards(FuseAction[] memory calls_) external;
    function getRewardsFuses() external view returns (address[] memory);
    function getVestingData() external view returns (VestingData memory);
    function isConsumingScheduledOp() external view returns (bytes4);
    function isRewardFuseSupported(address fuse_) external view returns (bool);
    function removeRewardFuses(address[] memory fuses_) external;
    function setAuthority(address newAuthority) external;
    function setupVestingTime(uint256 vestingTime_) external;
    function transfer(address asset_, address to_, uint256 amount_) external;
    function transferVestedTokensToVault() external;
    function updateBalance() external;
}

