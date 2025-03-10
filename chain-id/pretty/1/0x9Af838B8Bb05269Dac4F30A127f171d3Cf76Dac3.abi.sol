interface ERC4626ZapIn {
    struct Call {
        address target;
        bytes data;
    }

    struct ZapInData {
        address vault;
        address receiver;
        uint256 minAmountToDeposit;
        address[] assetsToRefundToSender;
        Call[] calls;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error ERC4626VaultIsZero();
    error FailedInnerCall();
    error InsufficientDepositAssetBalance();
    error MinAmountToDepositIsZero();
    error NoCalls();
    error ReceiverIsZero();
    error ReentrancyGuardReentrantCall();
    error SafeERC20FailedOperation(address token);

    function ZAP_IN_ALLOWANCE_CONTRACT() external view returns (address);
    function currentZapSender() external view returns (address);
    function zapIn(ZapInData memory zapInData_) external returns (bytes[] memory results);
}

