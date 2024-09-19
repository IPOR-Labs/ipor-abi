interface LiquidityMiningArbitrum {
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

    struct PoolPowerUpModifier {
        uint64 logBase;
        uint64 pwTokenModifier;
        uint64 vectorOfCurve;
    }

    struct UpdateLpToken {
        address beneficiary;
        address lpToken;
        uint256 lpTokenAmount;
    }

    struct UpdatePwToken {
        address beneficiary;
        address lpToken;
        uint256 pwTokenAmount;
    }

    event AdminChanged(address previousAdmin, address newAdmin);
    event AllowanceGranted(address indexed erc20Token, address indexed router);
    event AllowanceRevoked(address indexed erc20Token, address indexed router);
    event AppointedToTransferOwnership(address indexed appointedOwner);
    event BeaconUpgraded(address indexed beacon);
    event Claimed(address account, address[] lpTokens, uint256 rewardsAmount);
    event IndicatorsUpdated(address account, address lpToken);
    event Initialized(uint8 version);
    event LpTokenAdded(address beneficiary, address lpToken, uint256 lpTokenAmount);
    event LpTokenSupportRemoved(address account, address lpToken);
    event LpTokensRemoved(address account, address lpToken, uint256 lpTokenAmount);
    event LpTokensUnstaked(address account, address lpToken, uint256 lpTokenAmount);
    event NewLpTokenSupported(address account, address lpToken);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event PauseGuardiansAdded(address[] indexed guardians);
    event PauseGuardiansRemoved(address[] indexed guardians);
    event PauseManagerChanged(address indexed newPauseManager);
    event Paused(address account);
    event PoolPowerUpModifiersUpdated(address lpToken, uint64 logBase, uint64 pwTokenModifier, uint64 vectorOfCurve);
    event PwTokenDelegated(address account, address lpToken, uint256 pwTokenAmount);
    event PwTokenUndelegated(address account, address lpToken, uint256 pwTokenAmount);
    event PwTokensAdded(address beneficiary, address lpToken, uint256 pwTokenAmount);
    event PwTokensRemoved(address account, address lpToken, uint256 pwTokenAmount);
    event RewardsPerBlockChanged(address lpToken, uint256 newPwTokenAmount);
    event Unpaused(address account);
    event Upgraded(address indexed implementation);

    function addLpTokensInternal(UpdateLpToken[] memory updateLpToken) external;
    function addPauseGuardians(address[] memory guardians) external;
    function addPwTokensInternal(UpdatePwToken[] memory updatePwTokens) external;
    function balanceOf(address account, address lpToken) external view returns (uint256);
    function balanceOfDelegatedPwToken(address account, address[] memory lpTokens)
        external
        view
        returns (DelegatedPwTokenBalance[] memory balances);
    function calculateAccountRewards(address account, address[] memory lpTokens)
        external
        view
        returns (AccountRewardResult[] memory);
    function calculateAccruedRewards(address[] memory lpTokens)
        external
        view
        returns (AccruedRewardsResult[] memory result);
    function claimInternal(address account, address[] memory lpTokens)
        external
        returns (uint256 rewardsAmountToTransfer);
    function confirmTransferOwnership() external;
    function getAccountIndicators(address account, address[] memory lpTokens)
        external
        view
        returns (AccountIndicatorsResult[] memory);
    function getConfiguration() external view returns (address, address);
    function getGlobalIndicators(address[] memory lpTokens) external view returns (GlobalIndicatorsResult[] memory);
    function getImplementation() external view returns (address);
    function getPoolPowerUpModifiers(address lpToken)
        external
        view
        returns (uint256 pwTokenModifier, uint256 logBase, uint256 vectorOfCurve);
    function getVersion() external pure returns (uint256);
    function grantAllowanceForRouter(address erc20Token) external;
    function initialize(address[] memory lpTokens) external;
    function isLpTokenSupported(address lpToken) external view returns (bool);
    function isPauseGuardian(address guardian) external view returns (bool);
    function newSupportedLpToken(address lpToken) external;
    function owner() external view returns (address);
    function pause() external;
    function paused() external view returns (bool);
    function phasingOutLpToken(address lpToken) external;
    function proxiableUUID() external view returns (bytes32);
    function removeLpTokensInternal(UpdateLpToken[] memory updateLpToken) external;
    function removePauseGuardians(address[] memory guardians) external;
    function removePwTokensInternal(UpdatePwToken[] memory updatePwTokens) external;
    function renounceOwnership() external;
    function revokeAllowanceForRouter(address erc20Token) external;
    function routerAddress() external view returns (address);
    function setPoolPowerUpModifiers(address[] memory lpTokens, PoolPowerUpModifier[] memory modifiers) external;
    function setRewardsPerBlock(address[] memory lpTokens, uint32[] memory pwTokenAmounts) external;
    function transferOwnership(address appointedOwner) external;
    function unpause() external;
    function updateIndicators(address account, address[] memory lpTokens) external;
    function upgradeTo(address newImplementation) external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
}

