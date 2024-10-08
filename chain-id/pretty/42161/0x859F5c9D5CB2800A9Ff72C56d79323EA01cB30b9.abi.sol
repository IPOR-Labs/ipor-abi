interface RamsesV2CollectFuse {
    struct RamsesV2CollectFuseEnterData {
        uint256[] tokenIds;
    }

    event RamsesV2CollectFuseEnter(address version, uint256 tokenId, uint256 amount0, uint256 amount1);

    function MARKET_ID() external view returns (uint256);
    function NONFUNGIBLE_POSITION_MANAGER() external view returns (address);
    function VERSION() external view returns (address);
    function enter(RamsesV2CollectFuseEnterData memory data_) external;
}

