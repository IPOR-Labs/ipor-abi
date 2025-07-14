interface TacStakingEmergencyFuse {
    error TacStakingEmergencyFuseInvalidDelegatorAddress();

    event TacStakingEmergencyFuseExit(address version);

    function MARKET_ID() external view returns (uint256);
    function VERSION() external view returns (address);
    function exit() external;
}

