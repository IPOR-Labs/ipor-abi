library IIporAlgorithm {
    struct InitConnectorData {
        uint256 startDate;
        uint256 endDate;
        uint256 fadeChange;
    }

    struct InitData {
        InitConnectorData daiAaveV2Input;
        InitConnectorData usdcAaveV2Input;
        InitConnectorData usdtAaveV2Input;
        InitConnectorData wethAaveV2Input;
        InitConnectorData daiAaveV3Input;
        InitConnectorData usdcAaveV3Input;
        InitConnectorData usdtAaveV3Input;
        InitConnectorData wethAaveV3Input;
        InitConnectorData daiCompoundV2Input;
        InitConnectorData usdcCompoundV2Input;
        InitConnectorData usdtCompoundV2Input;
        InitConnectorData wethCompoundV2Input;
        InitConnectorData usdcCompoundV3Input;
        InitConnectorData wethCompoundV3Input;
    }
}

interface IporWeighted {
    error GeneralError(string message);

    event AdminChanged(address previousAdmin, address newAdmin);
    event AppointedToTransferOwnership(address indexed appointedOwner);
    event BeaconUpgraded(address indexed beacon);
    event Initialized(uint8 version);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Upgraded(address indexed implementation);

    function calculateIpor(address asset) external view returns (uint256 iporIndex);
    function confirmTransferOwnership() external;
    function getVersion() external pure returns (uint256);
    function initialize() external;
    function owner() external view returns (address);
    function proxiableUUID() external view returns (bytes32);
    function renounceOwnership() external;
    function transferOwnership(address appointedOwner) external;
    function upgradeTo(address newImplementation) external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
}

