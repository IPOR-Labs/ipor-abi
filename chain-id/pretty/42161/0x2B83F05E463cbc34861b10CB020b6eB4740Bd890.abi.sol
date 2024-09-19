interface FluidInstadappStakingSupplyFuse {
    struct FluidInstadappStakingSupplyFuseEnterData {
        uint256 fluidTokenAmount;
        address stakingPool;
    }

    struct FluidInstadappStakingSupplyFuseExitData {
        uint256 fluidTokenAmount;
        address stakingPool;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error FluidInstadappStakingSupplyFuseUnsupportedStakingPool(string action, address stakingPool);
    error SafeERC20FailedOperation(address token);

    event FluidInstadappStakingEnterFuse(address version, address stakingPool, address stakingToken, uint256 amount);
    event FluidInstadappStakingExitFuse(address version, address stakingPool, uint256 amount);

    function MARKET_ID() external view returns (uint256);
    function VERSION() external view returns (address);
    function enter(FluidInstadappStakingSupplyFuseEnterData memory data_) external;
    function enter(bytes memory data_) external;
    function exit(bytes memory data_) external;
    function exit(FluidInstadappStakingSupplyFuseExitData memory data_) external;
    function instantWithdraw(bytes32[] memory params_) external;
}

