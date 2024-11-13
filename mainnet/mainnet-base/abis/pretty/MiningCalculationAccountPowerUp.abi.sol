interface MiningCalculationAccountPowerUp {
    struct AccountPowerUpData {
        uint256 accountPwTokenAmount;
        uint256 accountLpTokenAmount;
        bytes16 verticalShift;
        bytes16 horizontalShift;
        uint256 logBase;
        uint256 pwTokenModifier;
        uint256 vectorOfCurve;
    }

    function calculateAccountPowerUp(AccountPowerUpData memory data_) external pure returns (uint256);
}

