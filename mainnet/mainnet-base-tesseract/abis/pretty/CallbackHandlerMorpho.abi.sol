interface CallbackHandlerMorpho {
    struct CallbackData {
        address asset;
        address addressToApprove;
        uint256 amountToApprove;
        bytes actionData;
    }

    function onMorphoFlashLoan(uint256 assets, bytes memory data) external pure returns (CallbackData memory);
    function onMorphoSupply(uint256 assets, bytes memory data) external pure returns (CallbackData memory);
}

