interface UpdateBalancesIgnoreDustPreHook {
    error InvalidSubstratesLength();
    error PriceOracleMiddlewareNotSet();

    function VERSION() external view returns (address);
    function run(bytes4 selector_) external;
}

