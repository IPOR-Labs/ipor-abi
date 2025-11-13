interface UniversalTokenSwapperFuse {
    struct UniversalTokenSwapperData {
        address[] targets;
        bytes[] data;
    }

    struct UniversalTokenSwapperEnterData {
        address tokenIn;
        address tokenOut;
        uint256 amountIn;
        UniversalTokenSwapperData data;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error SafeERC20FailedOperation(address token);
    error UniversalTokenSwapperFuseSlippageFail();
    error UniversalTokenSwapperFuseUnsupportedAsset(address asset);

    event UniversalTokenSwapperFuseEnter(
        address version, address tokenIn, address tokenOut, uint256 tokenInDelta, uint256 tokenOutDelta
    );

    function EXECUTOR() external view returns (address);
    function MARKET_ID() external view returns (uint256);
    function SLIPPAGE_REVERSE() external view returns (uint256);
    function VERSION() external view returns (address);
    function enter(UniversalTokenSwapperEnterData memory data_) external;
}

