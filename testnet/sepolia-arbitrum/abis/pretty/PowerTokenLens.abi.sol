interface PowerTokenLens {
    struct PwTokenCooldown {
        uint256 endTimestamp;
        uint256 pwTokenAmount;
    }

    function balanceOfPwToken(address account) external view returns (uint256);
    function balanceOfPwTokenDelegatedToLiquidityMining(address account) external view returns (uint256);
    function getPwTokenCooldownTime() external view returns (uint256);
    function getPwTokenExchangeRate() external view returns (uint256);
    function getPwTokenTotalSupplyBase() external view returns (uint256);
    function getPwTokenUnstakeFee() external view returns (uint256);
    function getPwTokensInCooldown(address account) external view returns (PwTokenCooldown memory);
    function powerToken() external view returns (address);
    function totalSupplyOfPwToken() external view returns (uint256);
}

