interface PlasmaVaultFactory {
    struct FeeConfig {
        address feeFactory;
        uint256 iporDaoManagementFee;
        uint256 iporDaoPerformanceFee;
        address iporDaoFeeRecipientAddress;
    }

    struct PlasmaVaultInitData {
        string assetName;
        string assetSymbol;
        address underlyingToken;
        address priceOracleMiddleware;
        FeeConfig feeConfig;
        address accessManager;
        address plasmaVaultBase;
        address withdrawManager;
    }

    error ERC1167FailedCreateClone();
    error InvalidBaseAddress();

    event PlasmaVaultCreated(
        uint256 index, address plasmaVault, string assetName, string assetSymbol, address underlyingToken
    );

    function clone(address baseAddress_, uint256 index_, PlasmaVaultInitData memory initData_)
        external
        returns (address plasmaVault);
    function create(uint256 index_, PlasmaVaultInitData memory initData_) external returns (address plasmaVault);
}

