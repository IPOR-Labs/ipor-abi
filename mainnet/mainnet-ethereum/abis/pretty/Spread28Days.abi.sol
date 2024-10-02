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

interface Spread28Days {
    function calculateAndUpdateOfferedRatePayFixed28Days(IporTypes.SpreadInputs memory spreadInputs)
        external
        returns (uint256 offeredRate);
    function calculateAndUpdateOfferedRateReceiveFixed28Days(IporTypes.SpreadInputs memory spreadInputs)
        external
        returns (uint256 offeredRate);
    function calculateOfferedRatePayFixed28Days(IporTypes.SpreadInputs memory spreadInputs)
        external
        view
        returns (uint256 offeredRate);
    function calculateOfferedRateReceiveFixed28Days(IporTypes.SpreadInputs memory spreadInputs)
        external
        view
        returns (uint256 offeredRate);
    function getSupportedAssets() external view returns (address[] memory);
    function spreadFunction28DaysConfig() external pure returns (uint256[] memory);
}

