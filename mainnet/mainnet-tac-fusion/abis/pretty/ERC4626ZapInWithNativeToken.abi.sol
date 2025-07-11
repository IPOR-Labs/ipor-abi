interface ERC4626ZapInWithNativeToken {
    struct Call {
        address target;
        bytes data;
        uint256 nativeTokenAmount;
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
    function zapIn(ZapInData memory zapInData_) external payable returns (bytes[] memory results);
}

