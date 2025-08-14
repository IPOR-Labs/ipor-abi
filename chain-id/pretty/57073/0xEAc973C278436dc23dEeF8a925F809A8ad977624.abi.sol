interface VelodromeSuperchainLiquidityFuse {
    struct VelodromeSuperchainLiquidityFuseEnterData {
        address tokenA;
        address tokenB;
        bool stable;
        uint256 amountADesired;
        uint256 amountBDesired;
        uint256 amountAMin;
        uint256 amountBMin;
        uint256 deadline;
    }

    struct VelodromeSuperchainLiquidityFuseExitData {
        address tokenA;
        address tokenB;
        bool stable;
        uint256 liquidity;
        uint256 amountAMin;
        uint256 amountBMin;
        uint256 deadline;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error SafeERC20FailedOperation(address token);
    error VelodromeSuperchainLiquidityFuseAddLiquidityFailed();
    error VelodromeSuperchainLiquidityFuseInvalidToken();
    error VelodromeSuperchainLiquidityFuseUnsupportedPool(string action, address poolAddress);

    event VelodromeSuperchainLiquidityFuseEnter(
        address version,
        address tokenA,
        address tokenB,
        bool stable,
        uint256 amountA,
        uint256 amountB,
        uint256 liquidity
    );
    event VelodromeSuperchainLiquidityFuseExit(
        address version,
        address tokenA,
        address tokenB,
        bool stable,
        uint256 amountA,
        uint256 amountB,
        uint256 liquidity
    );

    function MARKET_ID() external view returns (uint256);
    function VELODROME_ROUTER() external view returns (address);
    function VERSION() external view returns (address);
    function enter(VelodromeSuperchainLiquidityFuseEnterData memory data_) external;
    function exit(VelodromeSuperchainLiquidityFuseExitData memory data_) external;
}

