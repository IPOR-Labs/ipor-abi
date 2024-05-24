interface PowerToken {
    struct PwTokenCooldown {
        uint256 endTimestamp;
        uint256 pwTokenAmount;
    }

    struct UpdateGovernanceToken {
        address beneficiary;
        uint256 governanceTokenAmount;
    }

    event AdminChanged(address previousAdmin, address newAdmin);
    event AllowanceGranted(address indexed erc20Token, address indexed router);
    event AllowanceRevoked(address indexed erc20Token, address indexed router);
    event AppointedToTransferOwnership(address indexed appointedOwner);
    event BeaconUpgraded(address indexed beacon);
    event CooldownChanged(uint256 pwTokenAmount, uint256 endTimestamp);
    event Delegated(address indexed account, uint256 pwTokenAmounts);
    event GovernanceTokenAdded(
        address indexed account, uint256 governanceTokenAmount, uint256 internalExchangeRate, uint256 baseAmount
    );
    event GovernanceTokenRemovedWithFee(
        address indexed account, uint256 pwTokenAmount, uint256 internalExchangeRate, uint256 fee
    );
    event Initialized(uint8 version);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event PauseGuardiansAdded(address[] indexed guardians);
    event PauseGuardiansRemoved(address[] indexed guardians);
    event Paused(address account);
    event Redeem(address indexed account, uint256 pwTokenAmount);
    event Undelegated(address indexed account, uint256 pwTokenAmounts);
    event Unpaused(address account);
    event UnstakeWithoutCooldownFeeChanged(uint256 newFee);
    event Upgraded(address indexed implementation);

    function COOL_DOWN_IN_SECONDS() external view returns (uint256);
    function addGovernanceTokenInternal(UpdateGovernanceToken memory updateGovernanceToken) external;
    function addPauseGuardians(address[] memory guardians) external;
    function balanceOf(address account) external view returns (uint256);
    function calculateExchangeRate() external view returns (uint256);
    function cancelCooldownInternal(address account) external;
    function confirmTransferOwnership() external;
    function cooldownInternal(address account, uint256 pwTokenAmount) external;
    function decimals() external pure returns (uint8);
    function delegateInternal(address account, uint256 pwTokenAmount) external;
    function delegatedToLiquidityMiningBalanceOf(address account) external view returns (uint256);
    function getActiveCooldown(address account) external view returns (PwTokenCooldown memory);
    function getContractId() external pure returns (bytes32);
    function getGovernanceToken() external view returns (address);
    function getImplementation() external view returns (address);
    function getUnstakeWithoutCooldownFee() external view returns (uint256);
    function getVersion() external pure returns (uint256);
    function grantAllowanceForRouter(address erc20Token) external;
    function initialize() external;
    function isPauseGuardian(address guardian) external view returns (bool);
    function name() external pure returns (string memory);
    function owner() external view returns (address);
    function pause() external;
    function paused() external view returns (bool);
    function proxiableUUID() external view returns (bytes32);
    function redeemInternal(address account) external returns (uint256 transferAmount);
    function removeGovernanceTokenWithFeeInternal(UpdateGovernanceToken memory updateGovernanceToken)
        external
        returns (uint256 governanceTokenAmountToTransfer);
    function removePauseGuardians(address[] memory guardians) external;
    function renounceOwnership() external;
    function revokeAllowanceForRouter(address erc20Token) external;
    function routerAddress() external view returns (address);
    function setUnstakeWithoutCooldownFee(uint256 unstakeWithoutCooldownFee) external;
    function symbol() external pure returns (string memory);
    function totalSupply() external view returns (uint256);
    function totalSupplyBase() external view returns (uint256);
    function transferOwnership(address appointedOwner) external;
    function undelegateInternal(address account, uint256 pwTokenAmount) external;
    function unpause() external;
    function upgradeTo(address newImplementation) external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
}

