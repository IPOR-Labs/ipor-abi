library IAmmSwapsLens {
    struct IporSwap {
        uint256 id;
        address asset;
        address buyer;
        uint256 collateral;
        uint256 notional;
        uint256 leverage;
        uint256 direction;
        uint256 ibtQuantity;
        uint256 fixedInterestRate;
        int256 pnlValue;
        uint256 openTimestamp;
        uint256 endTimestamp;
        uint256 liquidationDepositAmount;
        uint256 state;
    }
}

interface AmmSwapsLensLibBaseV1 {
    function getSwaps(
        address iporOracle,
        address ammStorage,
        address asset,
        address account,
        uint256 offset,
        uint256 chunkSize
    ) external view returns (uint256 totalCount, IAmmSwapsLens.IporSwap[] memory swaps);
}

