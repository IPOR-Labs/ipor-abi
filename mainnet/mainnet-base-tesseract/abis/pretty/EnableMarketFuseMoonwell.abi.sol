interface MoonwellEnableMarketFuse {
    struct MoonwellEnableMarketFuseEnterData {
        address[] mTokens;
    }

    struct MoonwellEnableMarketFuseExitData {
        address[] mTokens;
    }

    error MoonwellEnableMarketFuseEmptyArray();
    error MoonwellEnableMarketFuseUnsupportedMToken(address mToken);

    event MoonwellMarketDisableFailed(address version, address mToken);
    event MoonwellMarketDisabled(address version, address mToken);
    event MoonwellMarketEnableFailed(address version, address[] mTokens);
    event MoonwellMarketEnabled(address version, address[] mTokens);

    function COMPTROLLER() external view returns (address);
    function MARKET_ID() external view returns (uint256);
    function VERSION() external view returns (address);
    function enter(MoonwellEnableMarketFuseEnterData memory data_) external;
    function exit(MoonwellEnableMarketFuseExitData memory data_) external;
}

