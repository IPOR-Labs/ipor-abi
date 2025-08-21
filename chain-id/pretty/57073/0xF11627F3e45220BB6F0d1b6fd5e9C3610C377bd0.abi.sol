interface VelodromeSuperchainSlipstreamLeafCLGaugeFuse {
    struct VelodromeSuperchainSlipstreamLeafCLGaugeFuseEnterData {
        address gaugeAddress;
        uint256 tokenId;
    }

    struct VelodromeSuperchainSlipstreamLeafCLGaugeFuseExitData {
        address gaugeAddress;
        uint256 tokenId;
    }

    error VelodromeSuperchainSlipstreamLeafCLGaugeUnsupportedGauge(address gaugeAddress);

    event VelodromeSuperchainSlipstreamLeafCLGaugeEnter(address gaugeAddress, uint256 tokenId);
    event VelodromeSuperchainSlipstreamLeafCLGaugeExit(address gaugeAddress, uint256 tokenId);

    function MARKET_ID() external view returns (uint256);
    function VERSION() external view returns (address);
    function enter(VelodromeSuperchainSlipstreamLeafCLGaugeFuseEnterData memory data_) external;
    function exit(VelodromeSuperchainSlipstreamLeafCLGaugeFuseExitData memory data_) external;
}

