interface RewardsManagerFactory {
    error ERC1167FailedCreateClone();
    error InvalidBaseAddress();

    event RewardsManagerCreated(uint256 index, address rewardsManager, address accessManager, address plasmaVault);

    function clone(address baseAddress_, uint256 index_, address accessManager_, address plasmaVault_)
        external
        returns (address rewardsManager);
    function create(uint256 index_, address accessManager_, address plasmaVault_)
        external
        returns (address rewardsManager);
}

