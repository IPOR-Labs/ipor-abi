interface UniswapV3SwapFuse {
    struct UniswapV3SwapFuseEnterData {
        uint256 tokenInAmount;
        uint256 minOutAmount;
        bytes path;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error SafeCastOverflowedIntToUint(int256 value);
    error SafeCastOverflowedUintToInt(uint256 value);
    error SafeERC20FailedOperation(address token);
    error SliceOutOfBounds();
    error UniswapV3SwapFuseUnsupportedToken(address asset);
    error UnsupportedMethod();

    event UniswapV3SwapFuseEnter(address version, uint256 tokenInAmount, bytes path, uint256 minOutAmount);

    function MARKET_ID() external view returns (uint256);
    function UNIVERSAL_ROUTER() external view returns (address);
    function VERSION() external view returns (address);
    function enter(UniswapV3SwapFuseEnterData memory data_) external;
}

