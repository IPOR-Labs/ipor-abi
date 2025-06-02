interface HarvestDoHardWorkFuse {
    struct HarvestDoHardWorkFuseEnterData {
        address[] vaults;
    }

    error NotSupported();
    error UnsupportedComptroller(address vault);
    error UnsupportedVault(address vault);

    event HarvestDoHardWorkFuseEnter(address version, address vault, address comptroller);

    function MARKET_ID() external view returns (uint256);
    function VERSION() external view returns (address);
    function enter(HarvestDoHardWorkFuseEnterData memory data_) external;
    function exit() external;
}

