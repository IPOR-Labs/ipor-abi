interface ContextManagerFactory {
    event ContextManagerCreated(uint256 index, address contextManager, address[] approvedTargets);

    function create(uint256 index_, address accessManager_, address[] memory approvedTargets_)
        external
        returns (address contextManager);
}

