library IporTypes {
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
}

interface Spread60Days {
    function calculateAndUpdateOfferedRatePayFixed60Days(IporTypes.SpreadInputs memory spreadInputs)
        external
        returns (uint256 offeredRate);
    function calculateAndUpdateOfferedRateReceiveFixed60Days(IporTypes.SpreadInputs memory spreadInputs)
        external
        returns (uint256 offeredRate);
    function calculateOfferedRatePayFixed60Days(IporTypes.SpreadInputs memory spreadInputs)
        external
        view
        returns (uint256 offeredRate);
    function calculateOfferedRateReceiveFixed60Days(IporTypes.SpreadInputs memory spreadInputs)
        external
        view
        returns (uint256 offeredRate);
    function getSupportedAssets() external view returns (address[] memory);
    function spreadFunction60DaysConfig() external pure returns (uint256[] memory);
}

