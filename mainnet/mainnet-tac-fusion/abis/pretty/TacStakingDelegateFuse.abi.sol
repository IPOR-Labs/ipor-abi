interface TacStakingDelegateFuse {
    struct TacStakingDelegateFuseEnterData {
        string[] validatorAddresses;
        uint256[] wTacAmounts;
    }

    struct TacStakingDelegateFuseExitData {
        string[] validatorAddresses;
        uint256[] tacAmounts;
    }

    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error FailedInnerCall();
    error SafeERC20FailedOperation(address token);
    error TacStakingFuseArrayLengthMismatch();
    error TacStakingFuseEmptyArray();
    error TacStakingFuseInsufficientBalance();
    error TacStakingFuseInvalidDelegatorAddress();
    error TacStakingFuseSubstrateNotGranted(string validator);
    error TacValidatorAddressConverterInvalidAddress();

    event TacStakingDelegateFuseEnter(address version, string[] validatorAddresses, uint256[] wTacAmounts);
    event TacStakingDelegateFuseExit(address version, string[] validatorAddresses, uint256[] tacAmounts);
    event TacStakingDelegatorCreated(address delegator, address plasmaVault, address wTAC, address staking);
    event TacStakingFuseInstantWithdraw(address version, uint256 amount);

    function MARKET_ID() external view returns (uint256);
    function STAKING() external view returns (address);
    function VERSION() external view returns (address);
    function W_TAC() external view returns (address);
    function enter(TacStakingDelegateFuseEnterData memory data_) external;
    function exit(TacStakingDelegateFuseExitData memory data_) external;
    function instantWithdraw(bytes32[] memory params_) external;
}

