interface SwapExecutorEth {
    struct SwapExecutorEthData {
        address tokenIn;
        address tokenOut;
        address[] targets;
        bytes[] callDatas;
        uint256[] ethAmounts;
        address[] tokensDustToCheck;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error SafeERC20FailedOperation(address token);
    error SwapExecutorEthInvalidArrayLength();
    error SwapExecutorEthInvalidWethAddress();

    event SwapExecutorEthExecuted(address indexed sender, address indexed tokenIn, address indexed tokenOut);

    receive() external payable;

    function W_ETH() external view returns (address);
    function execute(SwapExecutorEthData memory data_) external;
}

