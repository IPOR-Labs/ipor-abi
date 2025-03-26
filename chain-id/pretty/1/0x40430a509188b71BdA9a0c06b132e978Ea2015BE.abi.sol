interface PendleRedeemPTAfterMaturityFuse {
    type SwapType is uint8;

    struct PendleRedeemPTAfterMaturityFuseEnterData {
        address market;
        uint256 netPyIn;
        TokenOutput output;
    }

    struct SwapData {
        SwapType swapType;
        address extRouter;
        bytes extCalldata;
        bool needScale;
    }

    struct TokenOutput {
        address tokenOut;
        uint256 minTokenOut;
        address tokenRedeemSy;
        address pendleSwap;
        SwapData swapData;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error PendleRedeemPTAfterMaturityFuseInvalidMarketId();
    error PendleRedeemPTAfterMaturityFuseInvalidRouter();
    error PendleRedeemPTAfterMaturityFuseInvalidTokenOut();
    error PendleRedeemPTAfterMaturityFusePTNotExpired();
    error SafeERC20FailedOperation(address token);

    event PendleRedeemPTAfterMaturityFuseEnter(address version, address market, uint256 netTokenOut);

    function MARKET_ID() external view returns (uint256);
    function ROUTER() external view returns (address);
    function VERSION() external view returns (address);
    function enter(PendleRedeemPTAfterMaturityFuseEnterData memory data_) external;
}

