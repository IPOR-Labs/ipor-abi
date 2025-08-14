interface StEthWrapperFuse {
    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error SafeERC20FailedOperation(address token);
    error StEthWrapperFuseUnsupportedAsset(string action, address asset);
    error WrongValue();

    event StEthWrapperFuseEnter(address version, uint256 stEthAmount, uint256 wstEthAmount);
    event StEthWrapperFuseExit(address version, uint256 wstEthAmount, uint256 stEthAmount);

    function MARKET_ID() external view returns (uint256);
    function ST_ETH() external view returns (address);
    function VERSION() external view returns (address);
    function WST_ETH() external view returns (address);
    function enter(uint256 stEthAmount) external;
    function exit(uint256 wstEthAmount) external;
}

