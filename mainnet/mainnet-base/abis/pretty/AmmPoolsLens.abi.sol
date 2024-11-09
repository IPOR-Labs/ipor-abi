interface AmmPoolsLensBaseV1 {
    function getIpTokenExchangeRate(address asset_) external view returns (uint256);
    function iporOracle() external view returns (address);
}

