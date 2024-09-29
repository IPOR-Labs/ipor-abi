library AmmInternalTypes {
    struct OpenSwapItem {
        uint32 swapId;
        uint32 nextSwapId;
        uint32 previousSwapId;
        uint32 openSwapTimestamp;
    }
}

library AmmStorageTypes {
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

    struct SoapIndicators {
        uint256 hypotheticalInterestCumulative;
        uint256 totalNotional;
        uint256 totalIbtQuantity;
        uint256 averageInterestRate;
        uint256 rebalanceTimestamp;
    }
}

library AmmTypes {
    type SwapDirection is uint8;

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
        IporTypes.SwapTenor tenor;
    }

    struct Swap {
        uint256 id;
        address buyer;
        uint256 openTimestamp;
        IporTypes.SwapTenor tenor;
        uint256 idsIndex;
        uint256 collateral;
        uint256 notional;
        uint256 ibtQuantity;
        uint256 fixedInterestRate;
        uint256 liquidationDepositAmount;
        IporTypes.SwapState state;
    }
}

library IporTypes {
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
}

interface AmmStorage {
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

    function addLiquidityInternal(address account, uint256 assetAmount, uint256 cfgMaxLiquidityPoolBalance) external;
    function addPauseGuardians(address[] memory guardians) external;
    function confirmTransferOwnership() external;
    function getBalance() external view returns (IporTypes.AmmBalancesMemory memory);
    function getBalancesForOpenSwap() external view returns (IporTypes.AmmBalancesForOpenSwapMemory memory);
    function getConfiguration() external view returns (address, address);
    function getExtendedBalance() external view returns (AmmStorageTypes.ExtendedBalancesMemory memory);
    function getImplementation() external view returns (address);
    function getLastOpenedSwap(IporTypes.SwapTenor tenor, uint256 direction)
        external
        view
        returns (AmmInternalTypes.OpenSwapItem memory);
    function getLastSwapId() external view returns (uint256);
    function getSoapIndicators()
        external
        view
        returns (
            AmmStorageTypes.SoapIndicators memory indicatorsPayFixed,
            AmmStorageTypes.SoapIndicators memory indicatorsReceiveFixed
        );
    function getSwap(AmmTypes.SwapDirection direction, uint256 swapId) external view returns (AmmTypes.Swap memory);
    function getSwapIds(address account, uint256 offset, uint256 chunkSize)
        external
        view
        returns (uint256 totalCount, AmmStorageTypes.IporSwapId[] memory ids);
    function getSwapsPayFixed(address account, uint256 offset, uint256 chunkSize)
        external
        view
        returns (uint256 totalCount, AmmTypes.Swap[] memory swaps);
    function getSwapsReceiveFixed(address account, uint256 offset, uint256 chunkSize)
        external
        view
        returns (uint256 totalCount, AmmTypes.Swap[] memory swaps);
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
        AmmTypes.Swap memory swap,
        int256 pnlValue,
        uint256 swapUnwindFeeLPAmount,
        uint256 swapUnwindFeeTreasuryAmount,
        uint256 closingTimestamp
    ) external returns (AmmInternalTypes.OpenSwapItem memory closedSwap);
    function updateStorageWhenCloseSwapReceiveFixedInternal(
        AmmTypes.Swap memory swap,
        int256 pnlValue,
        uint256 swapUnwindFeeLPAmount,
        uint256 swapUnwindFeeTreasuryAmount,
        uint256 closingTimestamp
    ) external returns (AmmInternalTypes.OpenSwapItem memory closedSwap);
    function updateStorageWhenDepositToAssetManagement(uint256 depositAmount, uint256 vaultBalance) external;
    function updateStorageWhenOpenSwapPayFixedInternal(AmmTypes.NewSwap memory newSwap, uint256 cfgIporPublicationFee)
        external
        returns (uint256);
    function updateStorageWhenOpenSwapReceiveFixedInternal(
        AmmTypes.NewSwap memory newSwap,
        uint256 cfgIporPublicationFee
    ) external returns (uint256);
    function updateStorageWhenTransferToCharlieTreasuryInternal(uint256 transferredAmount) external;
    function updateStorageWhenTransferToTreasuryInternal(uint256 transferredAmount) external;
    function updateStorageWhenWithdrawFromAssetManagement(uint256 withdrawnAmount, uint256 vaultBalance) external;
    function upgradeTo(address newImplementation) external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
}

