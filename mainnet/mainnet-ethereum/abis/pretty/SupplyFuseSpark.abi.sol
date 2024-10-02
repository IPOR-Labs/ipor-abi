interface SparkSupplyFuse {
    struct SparkSupplyFuseEnterData {
        uint256 amount;
    }

    struct SparkSupplyFuseExitData {
        uint256 amount;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error SafeERC20FailedOperation(address token);

    event SparkSupplyFuseEnter(address version, uint256 amount, uint256 shares);
    event SparkSupplyFuseExit(address version, uint256 amount, uint256 shares);
    event SparkSupplyFuseExitFailed(address version, uint256 amount);

    function DAI() external view returns (address);
    function MARKET_ID() external view returns (uint256);
    function SDAI() external view returns (address);
    function VERSION() external view returns (address);
    function enter(SparkSupplyFuseEnterData memory data) external;
    function exit(SparkSupplyFuseExitData memory data) external;
    function instantWithdraw(bytes32[] memory params_) external;
}

