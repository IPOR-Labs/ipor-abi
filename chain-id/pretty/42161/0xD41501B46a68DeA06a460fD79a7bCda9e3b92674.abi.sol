interface RamsesV2ModifyPositionFuse {
    struct RamsesV2ModifyPositionFuseEnterData {
        address token0;
        address token1;
        uint256 tokenId;
        uint256 amount0Desired;
        uint256 amount1Desired;
        uint256 amount0Min;
        uint256 amount1Min;
        uint256 deadline;
    }

    struct RamsesV2ModifyPositionFuseExitData {
        uint256 tokenId;
        uint128 liquidity;
        uint256 amount0Min;
        uint256 amount1Min;
        uint256 deadline;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error RamsesV2ModifyPositionFuseUnsupportedToken(address token0, address token1);
    error SafeERC20FailedOperation(address token);

    event RamsesV2ModifyPositionFuseEnter(
        address version, uint256 tokenId, uint128 liquidity, uint256 amount0, uint256 amount1
    );
    event RamsesV2ModifyPositionFuseExit(address version, uint256 tokenId, uint256 amount0, uint256 amount1);

    function MARKET_ID() external view returns (uint256);
    function NONFUNGIBLE_POSITION_MANAGER() external view returns (address);
    function VERSION() external view returns (address);
    function enter(RamsesV2ModifyPositionFuseEnterData memory data_) external;
    function exit(RamsesV2ModifyPositionFuseExitData memory data_) external;
}

