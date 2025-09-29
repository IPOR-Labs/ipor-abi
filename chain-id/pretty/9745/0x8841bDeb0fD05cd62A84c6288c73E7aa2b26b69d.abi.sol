interface WithdrawManagerFactory {
    error ERC1167FailedCreateClone();
    error InvalidBaseAddress();

    event WithdrawManagerCreated(uint256 index, address withdrawManager, address accessManager);

    function clone(address baseAddress_, uint256 index_, address accessManager_)
        external
        returns (address withdrawManager);
    function create(uint256 index_, address accessManager_) external returns (address withdrawManager);
}

