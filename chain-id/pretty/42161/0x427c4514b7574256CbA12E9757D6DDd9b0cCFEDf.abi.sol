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

interface WrappedPlasmaVault {
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
    error InvalidInitialization();
    error InvalidManagementFee(uint256 feeInPercentage);
    error InvalidPerformanceFee(uint256 feeInPercentage);
    error MathOverflowedMulDiv();
    error NotInitializing();
    error OwnableInvalidOwner(address owner);
    error OwnableUnauthorizedAccount(address account);
    error ReentrancyGuardReentrantCall();
    error SafeCastOverflowedUintDowncast(uint8 bits, uint256 value);
    error SafeERC20FailedOperation(address token);
    error WrongAddress();
    error ZeroAssetAddress();
    error ZeroAssetsDeposit();
    error ZeroAssetsWithdraw();
    error ZeroPlasmaVaultAddress();
    error ZeroReceiverAddress();
    error ZeroSharesMint();

    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Deposit(address indexed sender, address indexed owner, uint256 assets, uint256 shares);
    event Initialized(uint64 version);
    event ManagementFeeDataConfigured(address feeAccount, uint256 feeInPercentage);
    event ManagementFeeRealized(uint256 unrealizedFeeInUnderlying, uint256 unrealizedFeeInShares);
    event OwnershipTransferStarted(address indexed previousOwner, address indexed newOwner);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event PerformanceFeeAdded(uint256 fee, uint256 feeInShares);
    event PerformanceFeeDataConfigured(address feeAccount, uint256 feeInPercentage);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Withdraw(
        address indexed sender, address indexed receiver, address indexed owner, uint256 assets, uint256 shares
    );

    function PLASMA_VAULT() external view returns (address);
    function acceptOwnership() external;
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
    function asset() external view returns (address);
    function balanceOf(address account) external view returns (uint256);
    function configureManagementFee(address feeAccount_, uint256 feeInPercentage_) external;
    function configurePerformanceFee(address feeAccount_, uint256 feeInPercentage_) external;
    function convertToAssets(uint256 shares) external view returns (uint256);
    function convertToAssetsWithFees(uint256 shares) external view returns (uint256);
    function convertToShares(uint256 assets) external view returns (uint256);
    function convertToSharesWithFees(uint256 assets) external view returns (uint256);
    function decimals() external view returns (uint8);
    function deposit(uint256 assets_, address receiver_) external returns (uint256);
    function getManagementFeeData() external view returns (PlasmaVaultStorageLib.ManagementFeeData memory feeData);
    function getPerformanceFeeData() external view returns (PlasmaVaultStorageLib.PerformanceFeeData memory feeData);
    function getUnrealizedManagementFee() external view returns (uint256);
    function lastTotalAssets() external view returns (uint256);
    function maxDeposit(address) external view returns (uint256);
    function maxMint(address) external view returns (uint256);
    function maxRedeem(address owner) external view returns (uint256);
    function maxWithdraw(address owner) external view returns (uint256);
    function mint(uint256 shares_, address receiver_) external returns (uint256);
    function name() external view returns (string memory);
    function owner() external view returns (address);
    function pendingOwner() external view returns (address);
    function previewDeposit(uint256 assets_) external view returns (uint256);
    function previewMint(uint256 shares) external view returns (uint256);
    function previewRedeem(uint256 shares) external view returns (uint256);
    function previewWithdraw(uint256 assets_) external view returns (uint256);
    function realizeFees() external;
    function redeem(uint256 shares_, address receiver_, address owner_) external returns (uint256);
    function renounceOwnership() external;
    function symbol() external view returns (string memory);
    function totalAssets() external view returns (uint256);
    function totalSupply() external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function transferOwnership(address newOwner) external;
    function withdraw(uint256 assets_, address receiver_, address owner_) external returns (uint256);
}

