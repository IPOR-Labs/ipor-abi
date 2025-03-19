interface MorphoBorrowFuse {
    struct MorphoBorrowFuseEnterData {
        bytes32 morphoMarketId;
        uint256 amountToBorrow;
        uint256 sharesToBorrow;
    }

    struct MorphoBorrowFuseExitData {
        bytes32 morphoMarketId;
        uint256 amountToRepay;
        uint256 sharesToRepay;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error MorphoBorrowFuseUnsupportedMarket(string action, bytes32 morphoMarketId);
    error SafeERC20FailedOperation(address token);

    event MorphoBorrowFuseEvent(
        address version, uint256 marketId, bytes32 morphoMarket, uint256 assetsBorrowed, uint256 sharesBorrowed
    );
    event MorphoBorrowFuseRepay(
        address version, uint256 marketId, bytes32 morphoMarket, uint256 assetsRepaid, uint256 sharesRepaid
    );

    function MARKET_ID() external view returns (uint256);
    function MORPHO() external view returns (address);
    function VERSION() external view returns (address);
    function enter(MorphoBorrowFuseEnterData memory data_) external;
    function exit(MorphoBorrowFuseExitData memory data_) external;
}

