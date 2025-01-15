interface FeeAccount {
    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error OnlyFeeManagerCanApprove();
    error SafeERC20FailedOperation(address token);

    function FEE_MANAGER() external view returns (address);
    function approveMaxForFeeManager(address plasmaVault_) external;
}

