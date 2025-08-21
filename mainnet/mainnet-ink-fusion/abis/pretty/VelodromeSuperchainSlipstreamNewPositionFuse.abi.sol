interface VelodromeSuperchainSlipstreamNewPositionFuse {
    struct VelodromeSuperchainSlipstreamNewPositionFuseEnterData {
        address token0;
        address token1;
        int24 tickSpacing;
        int24 tickLower;
        int24 tickUpper;
        uint256 amount0Desired;
        uint256 amount1Desired;
        uint256 amount0Min;
        uint256 amount1Min;
        uint256 deadline;
        uint160 sqrtPriceX96;
    }

    struct VelodromeSuperchainSlipstreamNewPositionFuseExitData {
        uint256[] tokenIds;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error SafeERC20FailedOperation(address token);
    error TokensNotSorted();
    error VelodromeSuperchainSlipstreamNewPositionFuseUnsupportedPool(address pool);

    event VelodromeSuperchainSlipstreamNewPositionFuseEnter(
        address indexed version,
        uint256 indexed tokenId,
        uint128 liquidity,
        uint256 amount0,
        uint256 amount1,
        address token0,
        address token1,
        int24 tickSpacing,
        int24 tickLower,
        int24 tickUpper
    );
    event VelodromeSuperchainSlipstreamNewPositionFuseExit(address indexed version, uint256 indexed tokenId);

    function FACTORY() external view returns (address);
    function MARKET_ID() external view returns (uint256);
    function NONFUNGIBLE_POSITION_MANAGER() external view returns (address);
    function VERSION() external view returns (address);
    function enter(VelodromeSuperchainSlipstreamNewPositionFuseEnterData memory data_) external;
    function exit(VelodromeSuperchainSlipstreamNewPositionFuseExitData memory closePositions_) external;
}

