interface MorphoFlashLoanFuse {
    struct MorphoFlashLoanFuseEnterData {
        address token;
        uint256 tokenAmount;
        bytes callbackFuseActionsData;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error MorphoFlashLoanFuseUnsupportedToken(address token);
    error SafeERC20FailedOperation(address token);

    event MorphoFlashLoanFuseEvent(address version, address asset, uint256 amount);

    function MARKET_ID() external view returns (uint256);
    function MORPHO() external view returns (address);
    function VERSION() external view returns (address);
    function enter(MorphoFlashLoanFuseEnterData memory data_) external;
}

