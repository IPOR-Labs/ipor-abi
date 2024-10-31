library AmmInternalTypes {
    struct OpenSwapItem {
        uint32 swapId;
        uint32 nextSwapId;
        uint32 previousSwapId;
        uint32 openSwapTimestamp;
    }
}

library AmmStorageTypes {
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
}

library AmmTypesBaseV1 {
    struct AmmBalanceForOpenSwap {
        uint256 totalCollateralPayFixed;
        uint256 totalNotionalPayFixed;
        uint256 totalCollateralReceiveFixed;
        uint256 totalNotionalReceiveFixed;
    }

    struct Balance {
        uint256 totalCollateralPayFixed;
        uint256 totalCollateralReceiveFixed;
        uint256 iporPublicationFee;
        uint256 treasury;
        uint256 totalLiquidationDepositBalance;
    }

    struct Swap {
        uint256 id;
        address buyer;
        uint256 openTimestamp;
        IporTypes.SwapTenor tenor;
        AmmTypes.SwapDirection direction;
        uint256 idsIndex;
        uint256 collateral;
        uint256 notional;
        uint256 ibtQuantity;
        uint256 fixedInterestRate;
        uint256 wadLiquidationDepositAmount;
        IporTypes.SwapState state;
    }
}

library IporTypes {
    type SwapState is uint8;
    type SwapTenor is uint8;
}

interface AmmStorageBaseV1 {
    error CallerNotIporProtocolRouter(string errorCode, address caller);

    event AdminChanged(address previousAdmin, address newAdmin);
    event AppointedToTransferOwnership(address indexed appointedOwner);
    event BeaconUpgraded(address indexed beacon);
    event Initialized(uint8 version);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Upgraded(address indexed implementation);

    function confirmTransferOwnership() external;
    function getBalance() external view returns (AmmTypesBaseV1.Balance memory);
    function getBalancesForOpenSwap() external view returns (AmmTypesBaseV1.AmmBalanceForOpenSwap memory);
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
    function getSwap(AmmTypes.SwapDirection direction, uint256 swapId)
        external
        view
        returns (AmmTypesBaseV1.Swap memory);
    function getSwapIds(address account, uint256 offset, uint256 chunkSize)
        external
        view
        returns (uint256 totalCount, AmmStorageTypes.IporSwapId[] memory ids);
    function getSwapsPayFixed(address account, uint256 offset, uint256 chunkSize)
        external
        view
        returns (uint256 totalCount, AmmTypesBaseV1.Swap[] memory swaps);
    function getSwapsReceiveFixed(address account, uint256 offset, uint256 chunkSize)
        external
        view
        returns (uint256 totalCount, AmmTypesBaseV1.Swap[] memory swaps);
    function getVersion() external pure returns (uint256);
    function initialize() external;
    function iporProtocolRouter() external view returns (address);
    function owner() external view returns (address);
    function proxiableUUID() external view returns (bytes32);
    function renounceOwnership() external;
    function transferOwnership(address appointedOwner) external;
    function updateStorageWhenCloseSwapPayFixedInternal(
        AmmTypesBaseV1.Swap memory swap,
        int256 pnlValue,
        uint256 swapUnwindFeeLPAmount,
        uint256 swapUnwindFeeTreasuryAmount,
        uint256 closingTimestamp
    ) external returns (AmmInternalTypes.OpenSwapItem memory closedSwap);
    function updateStorageWhenCloseSwapReceiveFixedInternal(
        AmmTypesBaseV1.Swap memory swap,
        int256 pnlValue,
        uint256 swapUnwindFeeLPAmount,
        uint256 swapUnwindFeeTreasuryAmount,
        uint256 closingTimestamp
    ) external returns (AmmInternalTypes.OpenSwapItem memory closedSwap);
    function updateStorageWhenOpenSwapPayFixedInternal(AmmTypes.NewSwap memory newSwap, uint256 cfgIporPublicationFee)
        external
        returns (uint256);
    function updateStorageWhenOpenSwapReceiveFixedInternal(
        AmmTypes.NewSwap memory newSwap,
        uint256 cfgIporPublicationFee
    ) external returns (uint256);
    function updateStorageWhenTransferToCharlieTreasuryInternal(uint256 transferredAmount) external;
    function updateStorageWhenTransferToTreasuryInternal(uint256 transferredAmount) external;
    function upgradeTo(address newImplementation) external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
}

