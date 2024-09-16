interface AmmStorage {
    type SwapDirection is uint8;
    type SwapState is uint8;
    type SwapTenor is uint8;

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

    struct ExtendedBalancesMemory {
        uint256 totalCollateralPayFixed;
        uint256 totalCollateralReceiveFixed;
        uint256 liquidityPool;
        uint256 vault;
        uint256 iporPublicationFee;
        uint256 treasury;
    }

    struct IporSwapId {
        uint256 id;
        uint8 direction;
    }

    struct NewSwap {
        address buyer;
        uint256 openTimestamp;
        uint256 collateral;
        uint256 notional;
        uint256 ibtQuantity;
        uint256 fixedInterestRate;
        uint256 liquidationDepositAmount;
        uint256 openingFeeLPAmount;
        uint256 openingFeeTreasuryAmount;
        SwapTenor tenor;
    }

    struct OpenSwapItem {
        uint32 swapId;
        uint32 nextSwapId;
        uint32 previousSwapId;
        uint32 openSwapTimestamp;
    }

    struct SoapIndicators {
        uint256 hypotheticalInterestCumulative;
        uint256 totalNotional;
        uint256 totalIbtQuantity;
        uint256 averageInterestRate;
        uint256 rebalanceTimestamp;
    }

    struct Swap {
        uint256 id;
        address buyer;
        uint256 openTimestamp;
        SwapTenor tenor;
        uint256 idsIndex;
        uint256 collateral;
        uint256 notional;
        uint256 ibtQuantity;
        uint256 fixedInterestRate;
        uint256 liquidationDepositAmount;
        SwapState state;
    }

    event AdminChanged(address previousAdmin, address newAdmin);
    event AppointedToTransferOwnership(address indexed appointedOwner);
    event BeaconUpgraded(address indexed beacon);
    event Initialized(uint8 version);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event PauseGuardiansAdded(address[] indexed guardians);
    event PauseGuardiansRemoved(address[] indexed guardians);
    event Paused(address account);
    event Unpaused(address account);
    event Upgraded(address indexed implementation);

    constructor(address iporProtocolRouterInput, address ammTreasury);

    function addLiquidityInternal(address account, uint256 assetAmount, uint256 cfgMaxLiquidityPoolBalance) external;
    function addPauseGuardians(address[] memory guardians) external;
    function confirmTransferOwnership() external;
    function getBalance() external view returns (AmmBalancesMemory memory);
    function getBalancesForOpenSwap() external view returns (AmmBalancesForOpenSwapMemory memory);
    function getConfiguration() external view returns (address, address);
    function getExtendedBalance() external view returns (ExtendedBalancesMemory memory);
    function getImplementation() external view returns (address);
    function getLastOpenedSwap(SwapTenor tenor, uint256 direction) external view returns (OpenSwapItem memory);
    function getLastSwapId() external view returns (uint256);
    function getSoapIndicators()
        external
        view
        returns (SoapIndicators memory indicatorsPayFixed, SoapIndicators memory indicatorsReceiveFixed);
    function getSwap(SwapDirection direction, uint256 swapId) external view returns (Swap memory);
    function getSwapIds(address account, uint256 offset, uint256 chunkSize)
        external
        view
        returns (uint256 totalCount, IporSwapId[] memory ids);
    function getSwapsPayFixed(address account, uint256 offset, uint256 chunkSize)
        external
        view
        returns (uint256 totalCount, Swap[] memory swaps);
    function getSwapsReceiveFixed(address account, uint256 offset, uint256 chunkSize)
        external
        view
        returns (uint256 totalCount, Swap[] memory swaps);
    function getVersion() external pure returns (uint256);
    function initialize() external;
    function isPauseGuardian(address account) external view returns (bool);
    function josephDeprecated() external view returns (address);
    function miltonDeprecated() external view returns (address);
    function owner() external view returns (address);
    function pause() external;
    function paused() external view returns (bool);
    function postUpgrade() external;
    function proxiableUUID() external view returns (bytes32);
    function removePauseGuardians(address[] memory guardians) external;
    function renounceOwnership() external;
    function subtractLiquidityInternal(uint256 assetAmount) external;
    function transferOwnership(address appointedOwner) external;
    function unpause() external;
    function updateStorageWhenCloseSwapPayFixedInternal(
        Swap memory swap,
        int256 pnlValue,
        uint256 swapUnwindFeeLPAmount,
        uint256 swapUnwindFeeTreasuryAmount,
        uint256 closingTimestamp
    ) external returns (OpenSwapItem memory closedSwap);
    function updateStorageWhenCloseSwapReceiveFixedInternal(
        Swap memory swap,
        int256 pnlValue,
        uint256 swapUnwindFeeLPAmount,
        uint256 swapUnwindFeeTreasuryAmount,
        uint256 closingTimestamp
    ) external returns (OpenSwapItem memory closedSwap);
    function updateStorageWhenDepositToAssetManagement(uint256 depositAmount, uint256 vaultBalance) external;
    function updateStorageWhenOpenSwapPayFixedInternal(NewSwap memory newSwap, uint256 cfgIporPublicationFee)
        external
        returns (uint256);
    function updateStorageWhenOpenSwapReceiveFixedInternal(NewSwap memory newSwap, uint256 cfgIporPublicationFee)
        external
        returns (uint256);
    function updateStorageWhenTransferToCharlieTreasuryInternal(uint256 transferredAmount) external;
    function updateStorageWhenTransferToTreasuryInternal(uint256 transferredAmount) external;
    function updateStorageWhenWithdrawFromAssetManagement(uint256 withdrawnAmount, uint256 vaultBalance) external;
    function upgradeTo(address newImplementation) external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
}

