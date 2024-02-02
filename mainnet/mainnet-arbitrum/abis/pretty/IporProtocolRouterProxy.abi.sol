interface IIporProtocolArbitrum {
    type SwapClosableStatus is uint8;
    type SwapDirection is uint8;
    type SwapTenor is uint8;

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

    struct AmmBalancesForOpenSwapMemory {
        uint256 totalCollateralPayFixed;
        uint256 totalNotionalPayFixed;
        uint256 totalCollateralReceiveFixed;
        uint256 totalNotionalReceiveFixed;
        uint256 liquidityPool;
    }

    struct AmmCloseSwapServicePoolConfiguration {
        address asset;
        uint256 decimals;
        address ammStorage;
        address ammTreasury;
        address assetManagement;
        address spread;
        uint256 unwindingFeeRate;
        uint256 unwindingFeeTreasuryPortionRate;
        uint256 maxLengthOfLiquidatedSwapsPerLeg;
        uint256 timeBeforeMaturityAllowedToCloseSwapByCommunity;
        uint256 timeBeforeMaturityAllowedToCloseSwapByBuyerTenor28days;
        uint256 timeBeforeMaturityAllowedToCloseSwapByBuyerTenor60days;
        uint256 timeBeforeMaturityAllowedToCloseSwapByBuyerTenor90days;
        uint256 minLiquidationThresholdToCloseBeforeMaturityByCommunity;
        uint256 minLiquidationThresholdToCloseBeforeMaturityByBuyer;
        uint256 minLeverage;
        uint256 timeAfterOpenAllowedToCloseSwapWithUnwindingTenor28days;
        uint256 timeAfterOpenAllowedToCloseSwapWithUnwindingTenor60days;
        uint256 timeAfterOpenAllowedToCloseSwapWithUnwindingTenor90days;
    }

    struct AmmGovernancePoolConfiguration {
        address asset;
        uint256 decimals;
        address ammStorage;
        address ammTreasury;
        address ammPoolsTreasury;
        address ammPoolsTreasuryManager;
        address ammCharlieTreasury;
        address ammCharlieTreasuryManager;
    }

    struct AmmPoolsParamsConfiguration {
        uint256 maxLiquidityPoolBalance;
        uint256 autoRebalanceThresholdInThousands;
        uint256 ammTreasuryAndAssetManagementRatio;
    }

    struct CloseSwapRiskIndicatorsInput {
        RiskIndicatorsInputs payFixed;
        RiskIndicatorsInputs receiveFixed;
    }

    struct ClosingSwapDetails {
        SwapClosableStatus closableStatus;
        bool swapUnwindRequired;
        int256 swapUnwindPnlValue;
        uint256 swapUnwindOpeningFeeAmount;
        uint256 swapUnwindFeeLPAmount;
        uint256 swapUnwindFeeTreasuryAmount;
        int256 pnlValue;
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

    struct IporSwap {
        uint256 id;
        address asset;
        address buyer;
        uint256 collateral;
        uint256 notional;
        uint256 leverage;
        uint256 direction;
        uint256 ibtQuantity;
        uint256 fixedInterestRate;
        int256 pnlValue;
        uint256 openTimestamp;
        uint256 endTimestamp;
        uint256 liquidationDepositAmount;
        uint256 state;
    }

    struct IporSwapClosingResult {
        uint256 swapId;
        bool closed;
    }

    struct IporSwapIndicator {
        uint256 iporIndexValue;
        uint256 ibtPrice;
        uint256 ibtQuantity;
        uint256 fixedInterestRate;
    }

    struct OpenSwapAmount {
        uint256 inputAssetTotalAmount;
        uint256 assetTotalAmount;
        uint256 collateral;
        uint256 notional;
        uint256 openingFeeLPAmount;
        uint256 openingFeeTreasuryAmount;
        uint256 iporPublicationFee;
        uint256 liquidationDepositAmount;
    }

    struct PwTokenCooldown {
        uint256 endTimestamp;
        uint256 pwTokenAmount;
    }

    struct RiskIndicatorsInputs {
        uint256 maxCollateralRatio;
        uint256 maxCollateralRatioPerLeg;
        uint256 maxLeveragePerLeg;
        int256 baseSpreadPerLeg;
        uint256 fixedRateCapPerLeg;
        uint256 demandSpreadFactor;
        uint256 expiration;
        bytes signature;
    }

    struct SwapLensPoolConfiguration {
        address asset;
        address ammStorage;
        address ammTreasury;
        address spread;
    }

    event AdminChanged(address previousAdmin, address newAdmin);
    event BeaconUpgraded(address indexed beacon);
    event CloseSwap(
        uint256 indexed swapId,
        address asset,
        uint256 closeTimestamp,
        address liquidator,
        uint256 transferredToBuyer,
        uint256 transferredToLiquidator
    );
    event OpenSwap(
        uint256 indexed swapId,
        address indexed buyer,
        address inputAsset,
        address asset,
        SwapDirection direction,
        OpenSwapAmount amounts,
        uint256 openTimestamp,
        uint256 endTimestamp,
        IporSwapIndicator indicator
    );
    event ProvideLiquidityWstEth(
        address indexed from,
        address indexed beneficiary,
        address indexed to,
        uint256 exchangeRate,
        uint256 assetAmount,
        uint256 ipTokenAmount
    );
    event RedeemWstEth(
        address indexed ammTreasuryEth,
        address indexed from,
        address indexed beneficiary,
        uint256 exchangeRate,
        uint256 amountStEth,
        uint256 redeemedAmountStEth,
        uint256 ipTokenAmount
    );
    event SwapUnwind(
        address asset,
        uint256 indexed swapId,
        int256 swapPnlValueToDate,
        int256 swapUnwindAmount,
        uint256 unwindFeeLPAmount,
        uint256 unwindFeeTreasuryAmount
    );
    event Upgraded(address indexed implementation);

    function addAppointedToRebalanceInAmm(address asset, address account) external;
    function addPauseGuardians(address[] memory guardians) external;
    function addSwapLiquidator(address asset, address account) external;
    function balanceOfLpTokensStakedInLiquidityMining(address account, address lpToken)
        external
        view
        returns (uint256);
    function balanceOfPowerTokensDelegatedToLiquidityMining(address account, address[] memory lpTokens)
        external
        view
        returns (DelegatedPwTokenBalance[] memory balances);
    function balanceOfPwToken(address account) external view returns (uint256);
    function balanceOfPwTokenDelegatedToLiquidityMining(address account) external view returns (uint256);
    function claimRewardsFromLiquidityMining(address[] memory lpTokens) external;
    function closeSwapsWstEth(
        address beneficiary,
        uint256[] memory payFixedSwapIds,
        uint256[] memory receiveFixedSwapIds,
        CloseSwapRiskIndicatorsInput memory riskIndicatorsInput
    )
        external
        returns (
            IporSwapClosingResult[] memory closedPayFixedSwaps,
            IporSwapClosingResult[] memory closedReceiveFixedSwaps
        );
    function delegatePwTokensToLiquidityMining(address[] memory lpTokens, uint256[] memory lpTokenAmounts) external;
    function depositToAssetManagement(address asset, uint256 assetAmount) external;
    function emergencyCloseSwapsWstEth(
        uint256[] memory payFixedSwapIds,
        uint256[] memory receiveFixedSwapIds,
        CloseSwapRiskIndicatorsInput memory riskIndicatorsInput
    )
        external
        returns (
            IporSwapClosingResult[] memory closedPayFixedSwaps,
            IporSwapClosingResult[] memory closedReceiveFixedSwaps
        );
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
    function getAmmCloseSwapServicePoolConfiguration(address asset)
        external
        view
        returns (AmmCloseSwapServicePoolConfiguration memory);
    function getAmmGovernancePoolConfiguration(address asset)
        external
        view
        returns (AmmGovernancePoolConfiguration memory);
    function getAmmPoolsParams(address asset) external view returns (AmmPoolsParamsConfiguration memory);
    function getBalancesForOpenSwap(address asset) external view returns (AmmBalancesForOpenSwapMemory memory);
    function getClosingSwapDetails(
        address asset,
        address account,
        SwapDirection direction,
        uint256 swapId,
        uint256 closeTimestamp,
        CloseSwapRiskIndicatorsInput memory riskIndicatorsInput
    ) external view returns (ClosingSwapDetails memory closingSwapDetails);
    function getGlobalIndicatorsFromLiquidityMining(address[] memory lpTokens)
        external
        view
        returns (GlobalIndicatorsResult[] memory);
    function getImplementation() external view returns (address);
    function getIpwstEthExchangeRate() external view returns (uint256);
    function getOfferedRate(
        address asset,
        SwapTenor tenor,
        uint256 notional,
        RiskIndicatorsInputs memory payFixedRiskIndicatorsInputs,
        RiskIndicatorsInputs memory receiveFixedRiskIndicatorsInputs
    ) external view returns (uint256 offeredRatePayFixed, uint256 offeredRateReceiveFixed);
    function getPnlPayFixed(address asset, uint256 swapId) external view returns (int256 pnlValue);
    function getPnlReceiveFixed(address asset, uint256 swapId) external view returns (int256 pnlValue);
    function getPwTokenCooldownTime() external view returns (uint256);
    function getPwTokenExchangeRate() external view returns (uint256);
    function getPwTokenTotalSupplyBase() external view returns (uint256);
    function getPwTokenUnstakeFee() external view returns (uint256);
    function getPwTokensInCooldown(address account) external view returns (PwTokenCooldown memory);
    function getSoap(address asset) external view returns (int256 soapPayFixed, int256 soapReceiveFixed, int256 soap);
    function getSwapLensPoolConfiguration(address asset) external view returns (SwapLensPoolConfiguration memory);
    function getSwaps(address asset, address account, uint256 offset, uint256 chunkSize)
        external
        view
        returns (uint256 totalCount, IporSwap[] memory swaps);
    function isAppointedToRebalanceInAmm(address asset, address account) external view returns (bool);
    function isPauseGuardian(address account) external view returns (bool);
    function isSwapLiquidator(address asset, address account) external view returns (bool);
    function openSwapPayFixed28daysWstEth(
        address beneficiary,
        address inputAsset,
        uint256 inputAssetTotalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external returns (uint256);
    function openSwapPayFixed60daysWstEth(
        address beneficiary,
        address inputAsset,
        uint256 inputAssetTotalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external returns (uint256);
    function openSwapPayFixed90daysWstEth(
        address beneficiary,
        address inputAsset,
        uint256 inputAssetTotalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external returns (uint256);
    function openSwapReceiveFixed28daysWstEth(
        address beneficiary,
        address inputAsset,
        uint256 inputAssetTotalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external returns (uint256);
    function openSwapReceiveFixed60daysWstEth(
        address beneficiary,
        address inputAsset,
        uint256 inputAssetTotalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external returns (uint256);
    function openSwapReceiveFixed90daysWstEth(
        address beneficiary,
        address inputAsset,
        uint256 inputAssetTotalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external returns (uint256);
    function pause() external;
    function provideLiquidityWstEth(address beneficiary, uint256 stEthAmount) external payable;
    function proxiableUUID() external view returns (bytes32);
    function pwTokenCancelCooldown() external;
    function pwTokenCooldown(uint256 pwTokenAmount) external;
    function redeemFromAmmPoolWstEth(address beneficiary, uint256 ipTokenAmount) external;
    function redeemPwToken(address transferTo) external;
    function removeAppointedToRebalanceInAmm(address asset, address account) external;
    function removePauseGuardians(address[] memory guardians) external;
    function removeSwapLiquidator(address asset, address account) external;
    function setAmmPoolsParams(
        address asset,
        uint32 newMaxLiquidityPoolBalance,
        uint32 newAutoRebalanceThresholdInThousands,
        uint16 newAmmTreasuryAndAssetManagementRatio
    ) external;
    function stakeGovernanceTokenToPowerToken(address beneficiary, uint256 iporTokenAmount) external;
    function stakeGovernanceTokenToPowerTokenAndDelegate(
        address beneficiary,
        uint256 governanceTokenAmount,
        address[] memory lpTokens,
        uint256[] memory pwTokenAmounts
    ) external;
    function stakeLpTokensToLiquidityMining(
        address beneficiary,
        address[] memory lpTokens,
        uint256[] memory lpTokenAmounts
    ) external;
    function totalSupplyOfPwToken() external view returns (uint256);
    function transferToCharlieTreasury(address asset, uint256 assetAmount) external;
    function transferToTreasury(address asset, uint256 assetAmount) external;
    function undelegatePwTokensFromLiquidityMining(address[] memory lpTokens, uint256[] memory lpTokenAmounts)
        external;
    function unpause() external;
    function unstakeGovernanceTokenFromPowerToken(address transferTo, uint256 iporTokenAmount) external;
    function unstakeLpTokensFromLiquidityMining(
        address transferTo,
        address[] memory lpTokens,
        uint256[] memory lpTokenAmounts
    ) external;
    function updateIndicatorsInLiquidityMining(address account, address[] memory lpTokens) external;
    function withdrawAllFromAssetManagement(address asset) external;
    function withdrawFromAssetManagement(address asset, uint256 assetAmount) external;
}

