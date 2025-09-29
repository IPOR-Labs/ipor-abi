interface ContextManagerFactory {
    error ERC1167FailedCreateClone();
    error InvalidBaseAddress();

    event ContextManagerCreated(uint256 index, address contextManager, address[] approvedTargets);

    function clone(address baseAddress_, uint256 index_, address accessManager_, address[] memory approvedTargets_)
        external
        returns (address contextManager);
    function create(uint256 index_, address accessManager_, address[] memory approvedTargets_)
        external
        returns (address contextManager);
}

