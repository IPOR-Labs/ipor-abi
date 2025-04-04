interface PendleSwapPTFuse {
    type SwapType is uint8;

    struct ApproxParams {
        uint256 guessMin;
        uint256 guessMax;
        uint256 guessOffchain;
        uint256 maxIteration;
        uint256 eps;
    }

    struct PendleSwapPTFuseEnterData {
        address market;
        uint256 minPtOut;
        ApproxParams guessPtOut;
        TokenInput input;
    }

    struct PendleSwapPTFuseExitData {
        address market;
        uint256 exactPtIn;
        TokenOutput output;
    }

    struct SwapData {
        SwapType swapType;
        address extRouter;
        bytes extCalldata;
        bool needScale;
    }

    struct TokenInput {
        address tokenIn;
        uint256 netTokenIn;
        address tokenMintSy;
        address pendleSwap;
        SwapData swapData;
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
    error PendleSwapPTFuseInvalidMarketId();
    error PendleSwapPTFuseInvalidRouter();
    error PendleSwapPTFuseInvalidTokenIn();
    error PendleSwapPTFuseInvalidTokenOut();
    error SafeERC20FailedOperation(address token);

    event PendleSwapPTFuseEnter(
        address version, address market, uint256 netPtOut, uint256 netSyFee, uint256 netSyInterm
    );
    event PendleSwapPTFuseExit(
        address version, address market, uint256 netTokenOut, uint256 netSyFee, uint256 netSyInterm
    );

    function MARKET_ID() external view returns (uint256);
    function ROUTER() external view returns (address);
    function VERSION() external view returns (address);
    function enter(PendleSwapPTFuseEnterData memory data_) external;
    function exit(PendleSwapPTFuseExitData memory data_) external;
}

