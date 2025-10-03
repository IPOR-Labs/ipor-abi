interface UniversalTokenSwapperWithVerificationFuse {
    struct UniversalTokenSwapperSubstrate {
        bytes4 functionSelector;
        address target;
    }

    struct UniversalTokenSwapperWithVerificationData {
        address[] targets;
        bytes[] callDatas;
        uint256[] ethAmounts;
        address[] tokensDustToCheck;
    }

    struct UniversalTokenSwapperWithVerificationEnterData {
        address tokenIn;
        address tokenOut;
        uint256 amountIn;
        UniversalTokenSwapperWithVerificationData data;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error SafeERC20FailedOperation(address token);
    error UniversalTokenSwapperFuseInvalidExecutorAddress();
    error UniversalTokenSwapperFuseSlippageFail();
    error UniversalTokenSwapperFuseUnsupportedAsset(address asset);

    event UniversalTokenSwapperWithVerificationFuseEnter(
        address version, address tokenIn, address tokenOut, uint256 tokenInDelta, uint256 tokenOutDelta
    );

    function EXECUTOR() external view returns (address payable);
    function MARKET_ID() external view returns (uint256);
    function SLIPPAGE_REVERSE() external view returns (uint256);
    function VERSION() external view returns (address);
    function enter(UniversalTokenSwapperWithVerificationEnterData memory data_) external;
    function fromBytes32(bytes32 data_) external pure returns (UniversalTokenSwapperSubstrate memory);
    function toBytes32(UniversalTokenSwapperSubstrate memory substrate_) external pure returns (bytes32);
}

