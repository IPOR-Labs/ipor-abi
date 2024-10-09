interface RamsesV2NewPositionFuse {
    struct RamsesV2NewPositionFuseEnterData {
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
        uint256 veRamTokenId;
    }

    struct RamsesV2NewPositionFuseExitData {
        uint256[] tokenIds;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error RamsesV2NewPositionFuseUnsupportedToken(address token0, address token1);
    error SafeERC20FailedOperation(address token);

    event RamsesV2NewPositionFuseEnter(
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
    event RamsesV2NewPositionFuseExit(address version, uint256 tokenId);

    function MARKET_ID() external view returns (uint256);
    function NONFUNGIBLE_POSITION_MANAGER() external view returns (address);
    function VERSION() external view returns (address);
    function enter(RamsesV2NewPositionFuseEnterData memory data_) external;
    function exit(RamsesV2NewPositionFuseExitData memory closePositions) external;
}

