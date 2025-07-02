interface FusionFactoryLib {
    error BalanceFuseBurnRequestFeeNotSet();
    error BurnRequestFeeFuseNotSet();
    error InvalidAddress();
    error InvalidAddress();
    error InvalidAssetName();
    error InvalidAssetSymbol();
    error InvalidDaoFeeRecipient();
    error InvalidFactoryAddress();
    error InvalidFeeValue();
    error InvalidIporDaoFeeRecipient();
    error InvalidOwner();
    error InvalidPlasmaVaultAdmin();
    error InvalidUnderlyingToken();
    error InvalidWithdrawWindow();

    event FusionInstanceCreated(
        uint256 index,
        uint256 version,
        string assetName,
        string assetSymbol,
        uint8 assetDecimals,
        address underlyingToken,
        string underlyingTokenSymbol,
        uint8 underlyingTokenDecimals,
        address initialOwner,
        address plasmaVault,
        address plasmaVaultBase,
        address feeManager
    );
}

