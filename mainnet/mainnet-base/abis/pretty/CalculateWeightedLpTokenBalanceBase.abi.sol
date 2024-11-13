interface CalculateWeightedLpTokenBalanceBase {
    function _calculateWeightedLpTokenBalance(
        address lpToken_,
        uint256 lpTokenBalance_,
        address ethUsdOracle_,
        address lpwstEth_,
        address wstEthEthOracle_
    ) external view returns (uint256);
}

