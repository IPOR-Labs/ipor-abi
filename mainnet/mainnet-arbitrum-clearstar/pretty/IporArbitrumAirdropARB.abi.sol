interface IporArbitrumAirdrop {
    error OwnableInvalidOwner(address owner);
    error OwnableUnauthorizedAccount(address account);

    event Claimed(address who, uint256 grantedAmount, uint256 transferAmount);
    event NewRoot(bytes32 newRoot, bytes32 oldRoot);
    event OwnershipTransferStarted(address indexed previousOwner, address indexed newOwner);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event WithdrawnAll(address to, uint256 amount);

    function ASSET() external view returns (address);
    function acceptOwnership() external;
    function claim(address account_, uint256 amount_, bytes32[] memory proof_) external;
    function claimed(address) external view returns (uint256);
    function owner() external view returns (address);
    function pendingOwner() external view returns (address);
    function renounceOwnership() external;
    function root() external view returns (bytes32);
    function setRoot(bytes32 root_) external;
    function totalReleased() external view returns (uint256);
    function transferOwnership(address newOwner) external;
    function withdrawAll(address account_) external;
}

