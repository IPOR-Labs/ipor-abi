interface AmmPoolsLensWstEth {
    constructor(
        address wstEthInput,
        address ipwstEthInput,
        address ammTreasuryWstEthInput,
        address ammStorageWstEthInput,
        address iporOracleInput
    );

    function ammStorageWstEth() external view returns (address);
    function ammTreasuryWstEth() external view returns (address);
    function getIpwstEthExchangeRate() external view returns (uint256);
    function iporOracle() external view returns (address);
    function ipwstEth() external view returns (address);
    function wstEth() external view returns (address);
}

