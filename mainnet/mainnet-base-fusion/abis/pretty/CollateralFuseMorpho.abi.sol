interface MorphoCollateralFuse {
    struct MorphoCollateralFuseEnterData {
        bytes32 morphoMarketId;
        uint256 collateralAmount;
    }

    struct MorphoCollateralFuseExitData {
        bytes32 morphoMarketId;
        uint256 maxCollateralAmount;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error MorphoCollateralUnsupportedMarket(string action, bytes32 morphoMarketId);
    error SafeERC20FailedOperation(address token);

    event MorphoCollateralFuseEnter(address version, address asset, bytes32 market, uint256 amount);
    event MorphoCollateralFuseExit(address version, address asset, bytes32 market, uint256 amount);

    function MARKET_ID() external view returns (uint256);
    function MORPHO() external view returns (address);
    function VERSION() external view returns (address);
    function enter(MorphoCollateralFuseEnterData memory data_) external;
    function exit(MorphoCollateralFuseExitData memory data_) external;
}

