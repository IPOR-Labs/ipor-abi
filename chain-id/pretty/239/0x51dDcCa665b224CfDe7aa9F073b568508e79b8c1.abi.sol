interface AccessManagerFactory {
    event AccessManagerCreated(uint256 index, address accessManager, uint256 redemptionDelayInSeconds);

    function create(uint256 index_, address initialAuthority_, uint256 redemptionDelayInSeconds_)
        external
        returns (address accessManager);
}

