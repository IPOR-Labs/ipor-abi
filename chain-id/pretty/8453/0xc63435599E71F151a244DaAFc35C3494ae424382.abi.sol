interface FeeManager {
    struct FeeManagerInitData {
        uint256 iporDaoManagementFee;
        uint256 iporDaoPerformanceFee;
        uint256 atomistManagementFee;
        uint256 atomistPerformanceFee;
        address initialAuthority;
        address plasmaVault;
        address feeRecipientAddress;
        address iporDaoFeeRecipientAddress;
    }

    error AccessManagedInvalidAuthority(address authority);
    error AccessManagedRequiredDelay(address caller, uint32 delay);
    error AccessManagedUnauthorized(address caller);
    error AlreadyInitialized();
    error InvalidFeeRecipientAddress();
    error MathOverflowedMulDiv();
    error NotInitialized();
    error WrongAddress();

    event AuthorityUpdated(address authority);
    event HarvestManagementFee(address receiver, uint256 amount);
    event HarvestPerformanceFee(address receiver, uint256 amount);
    event ManagementFeeUpdated(uint256 newManagementFee);
    event PerformanceFeeUpdated(uint256 newPerformanceFee);

    function IPOR_DAO_MANAGEMENT_FEE() external view returns (uint256);
    function IPOR_DAO_PERFORMANCE_FEE() external view returns (uint256);
    function MANAGEMENT_FEE_ACCOUNT() external view returns (address);
    function PERFORMANCE_FEE_ACCOUNT() external view returns (address);
    function PLASMA_VAULT() external view returns (address);
    function authority() external view returns (address);
    function feeRecipientAddress() external view returns (address);
    function harvestManagementFee() external;
    function harvestPerformanceFee() external;
    function initialize() external;
    function initialized() external view returns (uint256);
    function iporDaoFeeRecipientAddress() external view returns (address);
    function isConsumingScheduledOp() external view returns (bytes4);
    function plasmaVaultManagementFee() external view returns (uint256);
    function plasmaVaultPerformanceFee() external view returns (uint256);
    function setAuthority(address newAuthority) external;
    function setFeeRecipientAddress(address feeRecipientAddress_) external;
    function setIporDaoFeeRecipientAddress(address iporDaoFeeRecipientAddress_) external;
    function updateManagementFee(uint256 managementFee_) external;
    function updatePerformanceFee(uint256 performanceFee_) external;
}

