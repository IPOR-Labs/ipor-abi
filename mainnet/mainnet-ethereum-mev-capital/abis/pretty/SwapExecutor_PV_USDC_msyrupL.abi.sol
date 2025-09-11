interface SwapExecutorRestricted {
    struct SwapExecutorData {
        address tokenIn;
        address tokenOut;
        address[] dexs;
        bytes[] dexsData;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error SafeERC20FailedOperation(address token);
    error SwapExecutorRestrictedInvalidRestrictedAddress();
    error SwapExecutorRestrictedInvalidSender();

    function RESTRICTED() external view returns (address);
    function execute(SwapExecutorData memory data_) external;
}

