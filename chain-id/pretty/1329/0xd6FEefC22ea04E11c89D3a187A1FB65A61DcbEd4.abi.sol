interface BalanceFusesReader {
    function getBalanceFuseInfo(address plasmaVault_)
        external
        view
        returns (uint256[] memory marketIds, address[] memory fuseAddresses);
    function readMarketIdsAndFuseAddressesForBalanceFuses()
        external
        view
        returns (uint256[] memory marketIds, address[] memory fuseAddresses);
}

