interface RewardsManagerFactory {
    event RewardsManagerCreated(uint256 index, address rewardsManager, address accessManager, address plasmaVault);

    function create(uint256 index_, address accessManager_, address plasmaVault_)
        external
        returns (address rewardsManager);
}

