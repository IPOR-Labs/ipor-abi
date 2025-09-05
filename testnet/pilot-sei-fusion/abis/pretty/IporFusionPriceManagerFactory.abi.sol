interface PriceManagerFactory {
    event PriceManagerCreated(uint256 index, address priceManager, address priceOracleMiddleware);

    function create(uint256 index_, address accessManager_, address priceOracleMiddleware_)
        external
        returns (address priceManager);
}

