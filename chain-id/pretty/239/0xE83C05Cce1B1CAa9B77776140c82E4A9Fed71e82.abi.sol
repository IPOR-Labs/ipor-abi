interface TacStakingDelegatorAddressReader {
    error TacValidatorAddressConverterInvalidAddress();

    function convertBytes32ToValidatorAddress(bytes32 firstSlot_, bytes32 secondSlot_)
        external
        pure
        returns (string memory);
    function convertValidatorAddressToBytes32(string memory validatorAddress_)
        external
        pure
        returns (bytes32, bytes32);
    function getTacStakingDelegatorAddress(address plasmaVault_) external view returns (address delegatorAddress);
    function readTacStakingDelegatorAddress() external view returns (address delegatorAddress);
}

