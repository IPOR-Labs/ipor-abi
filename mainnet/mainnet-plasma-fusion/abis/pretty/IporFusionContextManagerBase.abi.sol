interface ContextManager {
    struct ContextDataWithSender {
        address sender;
        uint256 expirationTime;
        uint256 nonce;
        address target;
        bytes data;
        bytes signature;
    }

    struct ExecuteData {
        address[] targets;
        bytes[] datas;
    }

    error AccessManagedInvalidAuthority(address authority);
    error AccessManagedRequiredDelay(address caller, uint32 delay);
    error AccessManagedUnauthorized(address caller);
    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error ECDSAInvalidSignature();
    error ECDSAInvalidSignatureLength(uint256 length);
    error ECDSAInvalidSignatureS(bytes32 s);
    error EmptyArrayNotAllowed();
    error FailedInnerCall();
    error InvalidAuthority();
    error InvalidInitialization();
    error InvalidSignature();
    error LengthMismatch();
    error NonceTooLow();
    error NonceTooLow();
    error NotInitializing();
    error SignatureExpired();
    error TargetNotApproved(address target);

    event ApprovedTargetAdded(address indexed target);
    event ApprovedTargetRemoved(address indexed target);
    event AuthorityUpdated(address authority);
    event ContextCall(address indexed target, bytes data, bytes result);
    event Initialized(uint64 version);
    event NonceUpdated(address indexed target, uint256 newNonce);
    event TargetApproved(address indexed target);
    event TargetRemoved(address indexed target);

    function CHAIN_ID() external view returns (uint256);
    function addApprovedTargets(address[] memory targets_) external returns (uint256 approvedCount);
    function authority() external view returns (address);
    function getApprovedTargets() external view returns (address[] memory);
    function getNonce(address sender_) external view returns (uint256);
    function isConsumingScheduledOp() external view returns (bytes4);
    function isTargetApproved(address target_) external view returns (bool);
    function proxyInitialize(address initialAuthority_, address[] memory approvedTargets_) external;
    function removeApprovedTargets(address[] memory targets_) external returns (uint256 removedCount);
    function runWithContext(ExecuteData memory executeData_) external returns (bytes[] memory results);
    function runWithContextAndSignature(ContextDataWithSender[] memory contextDataArray_)
        external
        returns (bytes[] memory results);
    function setAuthority(address newAuthority) external;
}

