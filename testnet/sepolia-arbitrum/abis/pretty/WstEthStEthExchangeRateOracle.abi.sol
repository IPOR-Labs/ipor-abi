interface MockWstEthStEthExchangeRateOracle {
    event AppointedToTransferOwnership(address indexed appointedOwner);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    function confirmTransferOwnership() external;
    function decimals() external pure returns (uint8);
    function description() external pure returns (string memory);
    function getRoundData(uint80 _roundId)
        external
        view
        returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
    function latestRoundData()
        external
        view
        returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
    function owner() external view returns (address);
    function renounceOwnership() external;
    function setLatestAnswer(uint80 latestRoundId, int256 latestAnswer) external;
    function transferOwnership(address appointedOwner) external;
    function version() external pure returns (uint256);
}

