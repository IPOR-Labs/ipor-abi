interface EulerV2BorrowFuse {
    struct EulerV2BorrowFuseEnterData {
        address eulerVault;
        uint256 assetAmount;
        bytes1 subAccount;
    }

    struct EulerV2BorrowFuseExitData {
        address eulerVault;
        uint256 maxAssetAmount;
        bytes1 subAccount;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error EulerV2BorrowFuseUnsupportedEnterAction(address vault, bytes1 subAccount);
    error FailedInnerCall();
    error SafeERC20FailedOperation(address token);
    error WrongAddress();

    event EulerV2BorrowEnterFuse(address version, address eulerVault, uint256 borrowAmount, address subAccount);
    event EulerV2BorrowExitFuse(address version, address eulerVault, uint256 repayAmount, address subAccount);

    function EVC() external view returns (address);
    function MARKET_ID() external view returns (uint256);
    function VERSION() external view returns (address);
    function enter(EulerV2BorrowFuseEnterData memory data_) external;
    function exit(EulerV2BorrowFuseExitData memory data_) external;
}

