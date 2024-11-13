library IAmmGovernanceLens {
    struct AmmGovernancePoolConfiguration {
        address asset;
        uint256 decimals;
        address ammStorage;
        address ammTreasury;
        address ammVault;
        address ammPoolsTreasury;
        address ammPoolsTreasuryManager;
        address ammCharlieTreasury;
        address ammCharlieTreasuryManager;
    }

    struct AmmPoolsParamsConfiguration {
        uint256 maxLiquidityPoolBalance;
        uint256 autoRebalanceThreshold;
        uint256 ammTreasuryAndAssetManagementRatio;
    }
}

library StorageLibBaseV1 {
    struct AssetGovernancePoolConfigValue {
        uint8 decimals;
        address ammStorage;
        address ammTreasury;
        address ammVault;
        address ammPoolsTreasury;
        address ammPoolsTreasuryManager;
        address ammCharlieTreasury;
        address ammCharlieTreasuryManager;
    }

    struct AssetLensDataValue {
        uint8 decimals;
        address ipToken;
        address ammStorage;
        address ammTreasury;
        address ammVault;
        address spread;
    }

    struct AssetServicesValue {
        address ammPoolsService;
        address ammOpenSwapService;
        address ammCloseSwapService;
    }
}

interface AmmGovernanceServiceBaseV1 {
    error UnsupportedModule(string errorCode, address asset);
    error WrongAddress(string errorCode, address wrongAddress, string message);

    event AmmAppointedToRebalanceChanged(address indexed asset, address indexed account, bool status);
    event AmmPoolsParamsChanged(
        address indexed asset,
        uint32 maxLiquidityPoolBalance,
        uint32 autoRebalanceThreshold,
        uint16 ammTreasuryAndAssetManagementRatio
    );
    event AmmSwapsLiquidatorChanged(address indexed asset, address indexed liquidator, bool status);

    function addAppointedToRebalanceInAmm(address asset, address account) external;
    function addSwapLiquidator(address asset, address account) external;
    function depositToAssetManagement(address asset, uint256 wadAssetAmount) external;
    function getAmmGovernancePoolConfiguration(address asset)
        external
        view
        returns (IAmmGovernanceLens.AmmGovernancePoolConfiguration memory);
    function getAmmPoolsParams(address asset)
        external
        view
        returns (IAmmGovernanceLens.AmmPoolsParamsConfiguration memory cfg);
    function getAssetLensData(address asset) external view returns (StorageLibBaseV1.AssetLensDataValue memory);
    function getAssetServices(address asset) external view returns (StorageLibBaseV1.AssetServicesValue memory);
    function getMessageSigner() external view returns (address);
    function isAppointedToRebalanceInAmm(address asset, address account) external view returns (bool);
    function isSwapLiquidator(address asset, address account) external view returns (bool);
    function removeAppointedToRebalanceInAmm(address asset, address account) external;
    function removeSwapLiquidator(address asset, address account) external;
    function setAmmGovernancePoolConfiguration(
        address asset,
        StorageLibBaseV1.AssetGovernancePoolConfigValue memory assetGovernancePoolConfig
    ) external;
    function setAmmPoolsParams(
        address asset,
        uint32 newMaxLiquidityPoolBalance,
        uint32 newAutoRebalanceThreshold,
        uint16 newAmmTreasuryAndAssetManagementRatio
    ) external;
    function setAssetLensData(address asset, StorageLibBaseV1.AssetLensDataValue memory assetLensData) external;
    function setAssetServices(address asset, StorageLibBaseV1.AssetServicesValue memory assetServices) external;
    function setMessageSigner(address messageSigner) external;
    function transferToCharlieTreasury(address asset, uint256 wadAssetAmountInput) external;
    function transferToTreasury(address asset, uint256 wadAssetAmountInput) external;
    function withdrawAllFromAssetManagement(address asset) external;
    function withdrawFromAssetManagement(address asset, uint256 wadAssetAmount) external;
}

