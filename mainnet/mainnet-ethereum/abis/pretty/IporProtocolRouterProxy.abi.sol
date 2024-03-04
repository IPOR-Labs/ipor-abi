interface IIporProtocol {
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

    struct AmmBalancesMemory {
        uint256 totalCollateralPayFixed;
        uint256 totalCollateralReceiveFixed;
        uint256 liquidityPool;
        uint256 vault;
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

    struct AmmPoolsLensPoolConfiguration {
        address asset;
        uint256 decimals;
        address ipToken;
        address ammStorage;
        address ammTreasury;
        address assetManagement;
    }

    struct AmmPoolsParamsConfiguration {
        uint256 maxLiquidityPoolBalance;
        uint256 autoRebalanceThresholdInThousands;
        uint256 ammTreasuryAndAssetManagementRatio;
    }

    struct AmmPoolsServicePoolConfiguration {
        address asset;
        uint256 decimals;
        address ipToken;
        address ammStorage;
        address ammTreasury;
        address assetManagement;
        uint256 redeemFeeRate;
        uint256 redeemLpMaxCollateralRatio;
    }

    struct AssetManagementConfiguration {
        address asset;
        uint256 decimals;
        address assetManagement;
        address ammTreasury;
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
        uint256 totalAmount;
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

    error ProvideLiquidityFailed(address poolAsset, string errorCode, string errorMessage);
    error StEthSubmitFailed(uint256 amount, string errorCode);

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
        address asset,
        SwapDirection direction,
        OpenSwapAmount amounts,
        uint256 openTimestamp,
        uint256 endTimestamp,
        IporSwapIndicator indicator
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
    event ProvideLiquidity(
        address indexed from,
        address indexed beneficiary,
        address indexed to,
        uint256 exchangeRate,
        uint256 assetAmount,
        uint256 ipTokenAmount
    );
    event ProvideLiquidityEth(
        address indexed from,
        address indexed beneficiary,
        address indexed to,
        uint256 exchangeRate,
        uint256 amountEth,
        uint256 amountStEth,
        uint256 ipTokenAmount
    );
    event ProvideLiquidityStEth(
        address indexed from,
        address indexed beneficiary,
        address indexed to,
        uint256 exchangeRate,
        uint256 assetAmount,
        uint256 ipTokenAmount
    );
    event Redeem(
        address indexed ammTreasury,
        address indexed from,
        address indexed beneficiary,
        uint256 exchangeRate,
        uint256 assetAmount,
        uint256 ipTokenAmount,
        uint256 redeemFee,
        uint256 redeemAmount
    );
    event RedeemStEth(
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
    function balanceOfAmmTreasuryInAssetManagement(address asset) external view returns (uint256);
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
    function closeSwapsDai(
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
    function closeSwapsStEth(
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
    function closeSwapsUsdc(
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
    function closeSwapsUsdt(
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
    function emergencyCloseSwapsDai(
        uint256[] memory payFixedSwapIds,
        uint256[] memory receiveFixedSwapIds,
        CloseSwapRiskIndicatorsInput memory riskIndicatorsInput
    )
        external
        returns (
            IporSwapClosingResult[] memory closedPayFixedSwaps,
            IporSwapClosingResult[] memory closedReceiveFixedSwaps
        );
    function emergencyCloseSwapsStEth(
        uint256[] memory payFixedSwapIds,
        uint256[] memory receiveFixedSwapIds,
        CloseSwapRiskIndicatorsInput memory riskIndicatorsInput
    )
        external
        returns (
            IporSwapClosingResult[] memory closedPayFixedSwaps,
            IporSwapClosingResult[] memory closedReceiveFixedSwaps
        );
    function emergencyCloseSwapsUsdc(
        uint256[] memory payFixedSwapIds,
        uint256[] memory receiveFixedSwapIds,
        CloseSwapRiskIndicatorsInput memory riskIndicatorsInput
    )
        external
        returns (
            IporSwapClosingResult[] memory closedPayFixedSwaps,
            IporSwapClosingResult[] memory closedReceiveFixedSwaps
        );
    function emergencyCloseSwapsUsdt(
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
    function getAmmBalance(address asset) external view returns (AmmBalancesMemory memory);
    function getAmmCloseSwapServicePoolConfiguration(address asset)
        external
        view
        returns (AmmCloseSwapServicePoolConfiguration memory);
    function getAmmGovernancePoolConfiguration(address asset)
        external
        view
        returns (AmmGovernancePoolConfiguration memory);
    function getAmmPoolServiceConfiguration(address asset)
        external
        view
        returns (AmmPoolsServicePoolConfiguration memory);
    function getAmmPoolsLensConfiguration(address asset) external view returns (AmmPoolsLensPoolConfiguration memory);
    function getAmmPoolsParams(address asset) external view returns (AmmPoolsParamsConfiguration memory);
    function getAssetManagementConfiguration(address asset)
        external
        view
        returns (AssetManagementConfiguration memory);
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
    function getIpTokenExchangeRate(address asset) external view returns (uint256);
    function getIpWeEthExchangeRate() external view returns (uint256);
    function getIpstEthExchangeRate() external view returns (uint256);
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
    function iporOracle() external view returns (address);
    function isAppointedToRebalanceInAmm(address asset, address account) external view returns (bool);
    function isPauseGuardian(address account) external view returns (bool);
    function isSwapLiquidator(address asset, address account) external view returns (bool);
    function openSwapPayFixed28daysDai(
        address beneficiary,
        uint256 totalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external returns (uint256);
    function openSwapPayFixed28daysStEth(
        address beneficiary,
        address inputAsset,
        uint256 inputAssetTotalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external payable returns (uint256);
    function openSwapPayFixed28daysUsdc(
        address beneficiary,
        uint256 totalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external returns (uint256);
    function openSwapPayFixed28daysUsdt(
        address beneficiary,
        uint256 totalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external returns (uint256);
    function openSwapPayFixed60daysDai(
        address beneficiary,
        uint256 totalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external returns (uint256);
    function openSwapPayFixed60daysStEth(
        address beneficiary,
        address inputAsset,
        uint256 inputAssetTotalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external payable returns (uint256);
    function openSwapPayFixed60daysUsdc(
        address beneficiary,
        uint256 totalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external returns (uint256);
    function openSwapPayFixed60daysUsdt(
        address beneficiary,
        uint256 totalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external returns (uint256);
    function openSwapPayFixed90daysDai(
        address beneficiary,
        uint256 totalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external returns (uint256);
    function openSwapPayFixed90daysStEth(
        address beneficiary,
        address inputAsset,
        uint256 inputAssetTotalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external payable returns (uint256);
    function openSwapPayFixed90daysUsdc(
        address beneficiary,
        uint256 totalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external returns (uint256);
    function openSwapPayFixed90daysUsdt(
        address beneficiary,
        uint256 totalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external returns (uint256);
    function openSwapReceiveFixed28daysDai(
        address beneficiary,
        uint256 totalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external returns (uint256);
    function openSwapReceiveFixed28daysStEth(
        address beneficiary,
        address inputAsset,
        uint256 inputAssetTotalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external payable returns (uint256);
    function openSwapReceiveFixed28daysUsdc(
        address beneficiary,
        uint256 totalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external returns (uint256);
    function openSwapReceiveFixed28daysUsdt(
        address beneficiary,
        uint256 totalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external returns (uint256);
    function openSwapReceiveFixed60daysDai(
        address beneficiary,
        uint256 totalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external returns (uint256);
    function openSwapReceiveFixed60daysStEth(
        address beneficiary,
        address inputAsset,
        uint256 inputAssetTotalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external payable returns (uint256);
    function openSwapReceiveFixed60daysUsdc(
        address beneficiary,
        uint256 totalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external returns (uint256);
    function openSwapReceiveFixed60daysUsdt(
        address beneficiary,
        uint256 totalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external returns (uint256);
    function openSwapReceiveFixed90daysDai(
        address beneficiary,
        uint256 totalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external returns (uint256);
    function openSwapReceiveFixed90daysStEth(
        address beneficiary,
        address inputAsset,
        uint256 inputAssetTotalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external payable returns (uint256);
    function openSwapReceiveFixed90daysUsdc(
        address beneficiary,
        uint256 totalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external returns (uint256);
    function openSwapReceiveFixed90daysUsdt(
        address beneficiary,
        uint256 totalAmount,
        uint256 acceptableFixedInterestRate,
        uint256 leverage,
        RiskIndicatorsInputs memory riskIndicatorsInputs
    ) external returns (uint256);
    function pause() external;
    function provideLiquidity(address poolAsset, address inputAsset, address beneficiary, uint256 inputAssetAmount)
        external
        payable
        returns (uint256 ipTokenAmount);
    function provideLiquidityDai(address beneficiary, uint256 assetAmount) external;
    function provideLiquidityEth(address beneficiary, uint256 assetAmount) external payable;
    function provideLiquidityStEth(address beneficiary, uint256 stEthAmount) external payable;
    function provideLiquidityUsdc(address beneficiary, uint256 assetAmount) external;
    function provideLiquidityUsdt(address beneficiary, uint256 assetAmount) external;
    function provideLiquidityWEth(address beneficiary, uint256 assetAmount) external payable;
    function provideLiquidityWeEthToAmmPoolWeEth(address beneficiary, uint256 usdmAmount) external;
    function proxiableUUID() external view returns (bytes32);
    function pwTokenCancelCooldown() external;
    function pwTokenCooldown(uint256 pwTokenAmount) external;
    function rebalanceBetweenAmmTreasuryAndAssetManagement(address asset) external;
    function redeemFromAmmPoolDai(address beneficiary, uint256 ipTokenAmount) external;
    function redeemFromAmmPoolStEth(address beneficiary, uint256 ipTokenAmount) external;
    function redeemFromAmmPoolUsdc(address beneficiary, uint256 ipTokenAmount) external;
    function redeemFromAmmPoolUsdt(address beneficiary, uint256 ipTokenAmount) external;
    function redeemFromAmmPoolWeEth(address beneficiary, uint256 ipTokenAmount) external;
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

