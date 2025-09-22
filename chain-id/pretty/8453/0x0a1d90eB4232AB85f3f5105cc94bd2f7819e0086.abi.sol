interface PriceManagerFactory {
    error ERC1167FailedCreateClone();
    error InvalidBaseAddress();

    event PriceManagerCreated(uint256 index, address priceManager, address priceOracleMiddleware);

    function clone(address baseAddress_, uint256 index_, address accessManager_, address priceOracleMiddleware_)
        external
        returns (address priceManager);
    function create(uint256 index_, address accessManager_, address priceOracleMiddleware_)
        external
        returns (address priceManager);
}

