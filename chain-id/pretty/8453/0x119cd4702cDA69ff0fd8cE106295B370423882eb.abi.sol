interface ERC1967Proxy {
    error AddressEmptyCode(address target);
    error ERC1967InvalidImplementation(address implementation);
    error ERC1967NonPayable();
    error FailedInnerCall();

    event Upgraded(address indexed implementation);

    fallback() external payable;
}

