interface UniswapV2SwapFuse {
    struct UniswapV2SwapFuseEnterData {
        uint256 tokenInAmount;
        address[] path;
        uint256 minOutAmount;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error SafeERC20FailedOperation(address token);
    error UniswapV2SwapFuseUnsupportedToken(address asset);
    error UnsupportedMethod();

    event UniswapV2SwapFuseEnter(address version, uint256 tokenInAmount, address[] path, uint256 minOutAmount);

    function MARKET_ID() external view returns (uint256);
    function UNIVERSAL_ROUTER() external view returns (address);
    function VERSION() external view returns (address);
    function enter(UniswapV2SwapFuseEnterData memory data_) external;
}

