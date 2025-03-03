interface MorphoSupplyFuse {
    struct MorphoSupplyFuseEnterData {
        bytes32 morphoMarketId;
        uint256 amount;
    }

    struct MorphoSupplyFuseExitData {
        bytes32 morphoMarketId;
        uint256 amount;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error MorphoSupplyFuseUnsupportedMarket(string action, bytes32 morphoMarketId);
    error SafeERC20FailedOperation(address token);

    event MorphoSupplyFuseEnter(address version, address asset, bytes32 market, uint256 amount);
    event MorphoSupplyFuseExit(address version, address asset, bytes32 market, uint256 amount);
    event MorphoSupplyFuseExitFailed(address version, address asset, bytes32 market);

    function MARKET_ID() external view returns (uint256);
    function MORPHO() external view returns (address);
    function VERSION() external view returns (address);
    function enter(MorphoSupplyFuseEnterData memory data_) external;
    function exit(MorphoSupplyFuseExitData memory data_) external;
    function instantWithdraw(bytes32[] memory params_) external;
}

