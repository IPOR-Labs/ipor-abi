interface IpToken {
    event AppointedToTransferOwnership(address indexed appointedOwner);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Burn(address indexed account, uint256 amount);
    event Mint(address indexed account, uint256 amount);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event TokenManagerChanged(address indexed newTokenManager);
    event Transfer(address indexed from, address indexed to, uint256 value);

    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function burn(address account, uint256 amount) external;
    function confirmTransferOwnership() external;
    function decimals() external view returns (uint8);
    function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
    function getAsset() external view returns (address);
    function getTokenManager() external view returns (address);
    function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
    function mint(address account, uint256 amount) external;
    function name() external view returns (string memory);
    function owner() external view returns (address);
    function renounceOwnership() external;
    function setTokenManager(address newTokenManager) external;
    function symbol() external view returns (string memory);
    function totalSupply() external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transferOwnership(address appointedOwner) external;
}

