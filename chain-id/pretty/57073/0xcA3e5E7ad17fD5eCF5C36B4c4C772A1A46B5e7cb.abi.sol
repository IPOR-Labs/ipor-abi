interface VelodromeSuperchainSlipstreamModifyPositionFuse {
    struct VelodromeSuperchainSlipstreamModifyPositionFuseEnterData {
        address token0;
        address token1;
        uint256 tokenId;
        uint256 amount0Desired;
        uint256 amount1Desired;
        uint256 amount0Min;
        uint256 amount1Min;
        uint256 deadline;
    }

    struct VelodromeSuperchainSlipstreamModifyPositionFuseExitData {
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
    error TokensNotSorted();
    error VelodromeSuperchainSlipstreamModifyPositionFuseUnsupportedPool(address pool);

    event VelodromeSuperchainSlipstreamModifyPositionFuseEnter(
        address version, uint256 tokenId, uint128 liquidity, uint256 amount0, uint256 amount1
    );
    event VelodromeSuperchainSlipstreamModifyPositionFuseExit(
        address version, uint256 tokenId, uint256 amount0, uint256 amount1
    );

    function FACTORY() external view returns (address);
    function MARKET_ID() external view returns (uint256);
    function NONFUNGIBLE_POSITION_MANAGER() external view returns (address);
    function VERSION() external view returns (address);
    function enter(VelodromeSuperchainSlipstreamModifyPositionFuseEnterData memory data_) external;
    function exit(VelodromeSuperchainSlipstreamModifyPositionFuseExitData memory data_) external;
}

