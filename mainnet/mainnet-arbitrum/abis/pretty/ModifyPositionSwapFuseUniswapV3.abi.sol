interface UniswapV3ModifyPositionFuse {
    struct UniswapV3ModifyPositionFuseEnterData {
        address token0;
        address token1;
        uint256 tokenId;
        uint256 amount0Desired;
        uint256 amount1Desired;
        uint256 amount0Min;
        uint256 amount1Min;
        uint256 deadline;
    }

    struct UniswapV3ModifyPositionFuseExitData {
        uint256 tokenId;
        uint128 liquidity;
        uint256 amount0Min;
        uint256 amount1Min;
        uint256 deadline;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error SafeERC20FailedOperation(address token);
    error UniswapV3ModifyPositionFuseUnsupportedToken(address token0, address token1);

    event UniswapV3ModifyPositionFuseEnter(
        address version, uint256 tokenId, uint128 liquidity, uint256 amount0, uint256 amount1
    );
    event UniswapV3ModifyPositionFuseExit(address version, uint256 tokenId, uint256 amount0, uint256 amount1);

    function MARKET_ID() external view returns (uint256);
    function NONFUNGIBLE_POSITION_MANAGER() external view returns (address);
    function VERSION() external view returns (address);
    function enter(UniswapV3ModifyPositionFuseEnterData memory data_) external;
    function exit(UniswapV3ModifyPositionFuseExitData memory data_) external;
}

