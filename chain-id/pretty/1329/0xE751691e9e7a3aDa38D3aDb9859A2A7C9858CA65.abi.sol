interface PreHooksInfoReader {
    struct PreHookInfo {
        bytes4 selector;
        address implementation;
        bytes32[] substrates;
    }

    function getPreHooksInfo(address plasmaVault_) external view returns (PreHookInfo[] memory preHooksInfo);
    function getPreHooksInfo() external view returns (PreHookInfo[] memory preHooksInfo);
}

