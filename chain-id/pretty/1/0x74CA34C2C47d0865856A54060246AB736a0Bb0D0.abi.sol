interface UpdateWithdrawManagerMaintenanceFuse {
    struct UpdateWithdrawManagerMaintenanceFuseEnterData {
        address newManager;
    }

    event WithdrawManagerUpdated(address version, address newManager);

    function MARKET_ID() external view returns (uint256);
    function VERSION() external view returns (address);
    function enter(UpdateWithdrawManagerMaintenanceFuseEnterData memory data_) external;
    function exit(bytes memory) external pure;
    function getWithdrawManager() external view returns (address);
}

