interface AmmPoolsLensStEth {
    constructor(
        address stEthInput,
        address ipstEthInput,
        address ammTreasuryStEthInput,
        address ammStorageStEthInput,
        address iporOracleInput
    );

    function ammStorageStEth() external view returns (address);
    function ammTreasuryStEth() external view returns (address);
    function getIpstEthExchangeRate() external view returns (uint256);
    function iporOracle() external view returns (address);
    function ipstEth() external view returns (address);
    function stEth() external view returns (address);
}

