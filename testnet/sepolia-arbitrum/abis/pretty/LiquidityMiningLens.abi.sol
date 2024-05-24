interface LiquidityMiningLens {
    struct AccountIndicatorsResult {
        address lpToken;
        AccountRewardsIndicators indicators;
    }

    struct AccountRewardResult {
        address lpToken;
        uint256 rewardsAmount;
        uint256 allocatedPwTokens;
    }

    struct AccountRewardsIndicators {
        uint128 compositeMultiplierCumulativePrevBlock;
        uint128 lpTokenBalance;
        uint72 powerUp;
        uint96 delegatedPwTokenBalance;
    }

    struct AccruedRewardsResult {
        address lpToken;
        uint256 rewardsAmount;
    }

    struct DelegatedPwTokenBalance {
        address lpToken;
        uint256 pwTokenAmount;
    }

    struct GlobalIndicatorsResult {
        address lpToken;
        GlobalRewardsIndicators indicators;
    }

    struct GlobalRewardsIndicators {
        uint256 aggregatedPowerUp;
        uint128 compositeMultiplierInTheBlock;
        uint128 compositeMultiplierCumulativePrevBlock;
        uint32 blockNumber;
        uint32 rewardsPerBlock;
        uint88 accruedRewards;
    }

    function balanceOfLpTokensStakedInLiquidityMining(address account, address lpToken)
        external
        view
        returns (uint256);
    function balanceOfPowerTokensDelegatedToLiquidityMining(address account, address[] memory lpTokens)
        external
        view
        returns (DelegatedPwTokenBalance[] memory balances);
    function getAccountIndicatorsFromLiquidityMining(address account, address[] memory lpTokens)
        external
        view
        returns (AccountIndicatorsResult[] memory);
    function getAccountRewardsInLiquidityMining(address account, address[] memory lpTokens)
        external
        view
        returns (AccountRewardResult[] memory);
    function getAccruedRewardsInLiquidityMining(address[] memory lpTokens)
        external
        view
        returns (AccruedRewardsResult[] memory result);
    function getGlobalIndicatorsFromLiquidityMining(address[] memory lpTokens)
        external
        view
        returns (GlobalIndicatorsResult[] memory);
    function liquidityMining() external view returns (address);
}

