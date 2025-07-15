interface WithdrawManagerFactory {
    event WithdrawManagerCreated(uint256 index, address withdrawManager, address accessManager);

    function create(uint256 index_, address accessManager_) external returns (address withdrawManager);
}

