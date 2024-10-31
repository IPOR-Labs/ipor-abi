interface FeeManagerFactory {
    struct FeeManagerData {
        address feeManager;
        address plasmaVault;
        address performanceFeeAccount;
        address managementFeeAccount;
        uint256 managementFee;
        uint256 performanceFee;
    }

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

    function deployFeeManager(FeeManagerInitData memory initData) external returns (FeeManagerData memory);
}

