interface UniversalTokenSwapperEthFuse {
    struct UniversalTokenSwapperEthData {
        address[] targets;
        bytes[] callDatas;
        uint256[] ethAmounts;
        address[] tokensDustToCheck;
    }

    struct UniversalTokenSwapperEthEnterData {
        address tokenIn;
        address tokenOut;
        uint256 amountIn;
        UniversalTokenSwapperEthData data;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error SafeERC20FailedOperation(address token);
    error UniversalTokenSwapperFuseInvalidExecutorAddress();
    error UniversalTokenSwapperFuseSlippageFail();
    error UniversalTokenSwapperFuseUnsupportedAsset(address asset);

    event UniversalTokenSwapperEthFuseEnter(
        address version, address tokenIn, address tokenOut, uint256 tokenInDelta, uint256 tokenOutDelta
    );

    function EXECUTOR() external view returns (address payable);
    function MARKET_ID() external view returns (uint256);
    function SLIPPAGE_REVERSE() external view returns (uint256);
    function VERSION() external view returns (address);
    function enter(UniversalTokenSwapperEthEnterData memory data_) external;
}

