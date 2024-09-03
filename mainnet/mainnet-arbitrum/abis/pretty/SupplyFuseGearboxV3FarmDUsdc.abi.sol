interface GearboxV3FarmSupplyFuse {
    struct GearboxV3FarmdSupplyFuseEnterData {
        uint256 dTokenAmount;
        address farmdToken;
    }

    struct GearboxV3FarmdSupplyFuseExitData {
        uint256 dTokenAmount;
        address farmdToken;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error GearboxV3FarmdSupplyFuseUnsupportedFarmdToken(string action, address farmdToken);
    error SafeERC20FailedOperation(address token);

    event GearboxV3FarmdEnterFuse(address version, address farmdToken, address dToken, uint256 amount);
    event GearboxV3FarmdExitFuse(address version, address farmdToken, uint256 amount);

    function MARKET_ID() external view returns (uint256);
    function VERSION() external view returns (address);
    function enter(GearboxV3FarmdSupplyFuseEnterData memory data_) external;
    function enter(bytes memory data_) external;
    function exit(bytes memory data_) external;
    function exit(GearboxV3FarmdSupplyFuseExitData memory data_) external;
    function instantWithdraw(bytes32[] memory params_) external;
}

