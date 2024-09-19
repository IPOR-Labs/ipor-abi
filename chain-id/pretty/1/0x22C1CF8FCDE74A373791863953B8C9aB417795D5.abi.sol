interface Spread90Days {
    struct SpreadInputs {
        address asset;
        uint256 swapNotional;
        uint256 demandSpreadFactor;
        int256 baseSpreadPerLeg;
        uint256 totalCollateralPayFixed;
        uint256 totalCollateralReceiveFixed;
        uint256 liquidityPoolBalance;
        uint256 iporIndexValue;
        uint256 fixedRateCapPerLeg;
    }

    constructor(address dai, address usdc, address usdt);

    function calculateAndUpdateOfferedRatePayFixed90Days(SpreadInputs memory spreadInputs)
        external
        returns (uint256 offeredRate);
    function calculateAndUpdateOfferedRateReceiveFixed90Days(SpreadInputs memory spreadInputs)
        external
        returns (uint256 offeredRate);
    function calculateOfferedRatePayFixed90Days(SpreadInputs memory spreadInputs)
        external
        view
        returns (uint256 offeredRate);
    function calculateOfferedRateReceiveFixed90Days(SpreadInputs memory spreadInputs)
        external
        view
        returns (uint256 offeredRate);
    function getSupportedAssets() external view returns (address[] memory);
    function spreadFunction90DaysConfig() external pure returns (uint256[] memory);
}

