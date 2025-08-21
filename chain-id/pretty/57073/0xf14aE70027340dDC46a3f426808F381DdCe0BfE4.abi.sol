interface VelodromeSuperchainSlipstreamCollectFuse {
    struct VelodromeSuperchainSlipstreamCollectFuseEnterData {
        uint256[] tokenIds;
    }

    error UnsupportedMethod();

    event VelodromeSuperchainSlipstreamCollectFuseEnter(
        address version, uint256 tokenId, uint256 amount0, uint256 amount1
    );

    function MARKET_ID() external view returns (uint256);
    function NONFUNGIBLE_POSITION_MANAGER() external view returns (address);
    function VERSION() external view returns (address);
    function enter(VelodromeSuperchainSlipstreamCollectFuseEnterData memory data_) external;
}

