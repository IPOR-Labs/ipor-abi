interface AmmPoolsLensWeEth {
    function ammStorageWeEth() external view returns (address);
    function ammTreasuryWeEth() external view returns (address);
    function getIpWeEthExchangeRate() external view returns (uint256);
    function ipWeEth() external view returns (address);
    function iporOracle() external view returns (address);
    function weEth() external view returns (address);
}

