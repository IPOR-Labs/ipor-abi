interface TestnetFaucet {
    event AdminChanged(address previousAdmin, address newAdmin);
    event AppointedToTransferOwnership(address indexed appointedOwner);
    event BeaconUpgraded(address indexed beacon);
    event Claim(address to, address asset, uint256 amount);
    event Initialized(uint8 version);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event TransferFailed(address to, address asset, uint256 amount);
    event Upgraded(address indexed implementation);

    fallback() external payable;

    receive() external payable;

    function addAsset(address asset, uint256 amount) external;
    function balanceOf(address asset) external view returns (uint256);
    function balanceOfEth() external view returns (uint256);
    function claim() external;
    function confirmTransferOwnership() external;
    function couldClaimInSeconds() external view returns (uint256);
    function getAmountToTransfer(address asset) external view returns (uint256);
    function getVersion() external pure returns (uint256);
    function hasClaimBefore() external view returns (bool);
    function initialize(address dai, address usdc, address usdt, address ipor) external;
    function owner() external view returns (address);
    function proxiableUUID() external view returns (bytes32);
    function renounceOwnership() external;
    function transfer(address asset, uint256 amount) external;
    function transferEth(address payable recipient, uint256 value) external payable;
    function transferOwnership(address appointedOwner) external;
    function updateAmountToTransfer(address asset, uint256 amount) external;
    function upgradeTo(address newImplementation) external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
}

