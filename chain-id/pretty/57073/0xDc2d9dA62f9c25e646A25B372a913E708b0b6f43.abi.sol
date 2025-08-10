interface VelodromeSuperchainSlipstreamBalanceFuse {
    function MARKET_ID() external view returns (uint256);
    function NONFUNGIBLE_POSITION_MANAGER() external view returns (address);
    function SLIPSTREAM_SUPERCHAIN_SUGAR() external view returns (address);
    function balanceOf() external view returns (uint256);
}

