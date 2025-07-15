interface LiquityStabilityPoolFuse {
    struct LiquityStabilityPoolFuseEnterData {
        address registry;
        uint256 amount;
    }

    struct LiquityStabilityPoolFuseExitData {
        address registry;
        uint256 amount;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error InvalidMarketId();
    error SafeERC20FailedOperation(address token);
    error UnsupportedSubstrate();

    event LiquityStabilityPoolFuseEnter(address stabilityPool, uint256 amount);
    event LiquityStabilityPoolFuseExit(address stabilityPool, uint256 amount);

    function MARKET_ID() external view returns (uint256);
    function enter(LiquityStabilityPoolFuseEnterData memory data) external;
    function exit(LiquityStabilityPoolFuseExitData memory data) external;
}

