interface TacStakingRedelegateFuse {
    struct TacStakingRedelegateFuseEnterData {
        string[] validatorSrcAddresses;
        string[] validatorDstAddresses;
        uint256[] wTacAmounts;
    }

    error TacStakingRedelegateFuseArrayLengthMismatch();
    error TacStakingRedelegateFuseInvalidDelegatorAddress();
    error TacStakingRedelegateFuseSubstrateNotGranted(string validator);
    error TacValidatorAddressConverterInvalidAddress();

    event TacStakingRedelegateFuseRedelegate(
        address version, string[] validatorSrcAddresses, string[] validatorDstAddresses, uint256[] wTacAmounts
    );

    function MARKET_ID() external view returns (uint256);
    function VERSION() external view returns (address);
    function enter(TacStakingRedelegateFuseEnterData memory data_) external;
}

