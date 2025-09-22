interface AccessManagerFactory {
    error ERC1167FailedCreateClone();
    error InvalidBaseAddress();

    event AccessManagerCreated(uint256 index, address accessManager, uint256 redemptionDelayInSeconds);

    function clone(address baseAddress_, uint256 index_, address initialAuthority_, uint256 redemptionDelayInSeconds_)
        external
        returns (address accessManager);
    function create(uint256 index_, address initialAuthority_, uint256 redemptionDelayInSeconds_)
        external
        returns (address accessManager);
}

