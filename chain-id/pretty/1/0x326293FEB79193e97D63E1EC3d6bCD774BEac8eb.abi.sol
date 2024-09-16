interface AmmPoolsLensUsdm {
    constructor(
        address usdmInput,
        address ipUsdmInput,
        address ammTreasuryUsdmInput,
        address ammStorageUsdmInput,
        address iporOracleInput
    );

    function ammStorageUsdm() external view returns (address);
    function ammTreasuryUsdm() external view returns (address);
    function getIpUsdmExchangeRate() external view returns (uint256);
    function ipUsdm() external view returns (address);
    function iporOracle() external view returns (address);
    function usdm() external view returns (address);
}

