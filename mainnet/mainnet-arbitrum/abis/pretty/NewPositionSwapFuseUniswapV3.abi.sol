interface UniswapV3NewPositionFuse {
    struct UniswapV3NewPositionFuseEnterData {
        address token0;
        address token1;
        uint24 fee;
        int24 tickLower;
        int24 tickUpper;
        uint256 amount0Desired;
        uint256 amount1Desired;
        uint256 amount0Min;
        uint256 amount1Min;
        uint256 deadline;
    }

    struct UniswapV3NewPositionFuseExitData {
        uint256[] tokenIds;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error MathOverflowedMulDiv();
    error SafeCastOverflowedIntToUint(int256 value);
    error SafeERC20FailedOperation(address token);
    error UniswapV3NewPositionFuseUnsupportedToken(address token0, address token1);

    event UniswapV3NewPositionFuseEnter(
        address version,
        uint256 tokenId,
        uint128 liquidity,
        uint256 amount0,
        uint256 amount1,
        address token0,
        address token1,
        uint24 fee,
        int24 tickLower,
        int24 tickUpper
    );
    event UniswapV3NewPositionFuseExit(address version, uint256 tokenIds);

    function MARKET_ID() external view returns (uint256);
    function NONFUNGIBLE_POSITION_MANAGER() external view returns (address);
    function VERSION() external view returns (address);
    function enter(UniswapV3NewPositionFuseEnterData memory data_) external;
    function exit(UniswapV3NewPositionFuseExitData memory closePositions) external;
}

