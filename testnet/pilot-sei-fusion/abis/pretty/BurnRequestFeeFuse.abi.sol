interface BurnRequestFeeFuse {
    struct BurnRequestFeeDataEnter {
        uint256 amount;
    }

    error BurnRequestFeeExitNotImplemented();
    error BurnRequestFeeWithdrawManagerNotSet();
    error ERC20InsufficientAllowance(address spender, uint256 allowance, uint256 needed);
    error ERC20InsufficientBalance(address sender, uint256 balance, uint256 needed);
    error ERC20InvalidApprover(address approver);
    error ERC20InvalidReceiver(address receiver);
    error ERC20InvalidSender(address sender);
    error ERC20InvalidSpender(address spender);
    error InvalidInitialization();
    error NotInitializing();

    event Approval(address indexed owner, address indexed spender, uint256 value);
    event BurnRequestFeeEnter(address version, uint256 amount);
    event Initialized(uint64 version);
    event Transfer(address indexed from, address indexed to, uint256 value);

    function MARKET_ID() external view returns (uint256);
    function VERSION() external view returns (address);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function decimals() external view returns (uint8);
    function enter(BurnRequestFeeDataEnter memory data_) external;
    function exit() external pure;
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function totalSupply() external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

