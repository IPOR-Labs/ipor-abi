interface VelodromeSuperchainGaugeFuse {
    struct VelodromeSuperchainGaugeFuseEnterData {
        address gaugeAddress;
        uint256 amount;
        uint256 minAmount;
    }

    struct VelodromeSuperchainGaugeFuseExitData {
        address gaugeAddress;
        uint256 amount;
        uint256 minAmount;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error SafeERC20FailedOperation(address token);
    error VelodromeSuperchainGaugeFuseInvalidAmount();
    error VelodromeSuperchainGaugeFuseInvalidGauge();
    error VelodromeSuperchainGaugeFuseMinAmountNotMet();
    error VelodromeSuperchainGaugeFuseUnsupportedGauge(string action, address gaugeAddress);

    event VelodromeSuperchainGaugeFuseEnter(address version, address gaugeAddress, uint256 amount);
    event VelodromeSuperchainGaugeFuseExit(address version, address gaugeAddress, uint256 amount);

    function MARKET_ID() external view returns (uint256);
    function VERSION() external view returns (address);
    function enter(VelodromeSuperchainGaugeFuseEnterData memory data_) external;
    function exit(VelodromeSuperchainGaugeFuseExitData memory data_) external;
}

