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
        address initialAuthority;
        address plasmaVault;
        uint256 iporDaoManagementFee;
        uint256 iporDaoPerformanceFee;
        address iporDaoFeeRecipientAddress;
        RecipientFee[] recipientManagementFees;
        RecipientFee[] recipientPerformanceFees;
    }

    struct RecipientFee {
        address recipient;
        uint256 feeValue;
    }

    function deployFeeManager(FeeManagerInitData memory initData_) external returns (FeeManagerData memory);
}

