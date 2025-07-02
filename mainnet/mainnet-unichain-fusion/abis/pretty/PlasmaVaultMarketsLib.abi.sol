interface PlasmaVaultMarketsLib {
    error AddressEmptyCode(address target);
    error FailedInnerCall();
    error SafeCastOverflowedIntToUint(int256 value);
    error SafeCastOverflowedUintToInt(uint256 value);

    event MarketBalancesUpdated(uint256[] marketIds, int256 deltaInUnderlying);
}

