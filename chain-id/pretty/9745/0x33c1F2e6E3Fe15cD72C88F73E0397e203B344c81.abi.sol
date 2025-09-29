interface CallbackHandlerReader {
    error CallbackHandlerReaderInvalidArrayLength();

    function getCallbackHandler(address plasmaVault_, address sender_, bytes4 sig_)
        external
        view
        returns (address handler);
    function getCallbackHandler(address sender_, bytes4 sig_) external view returns (address handler);
    function getCallbackHandlers(address[] memory senders_, bytes4[] memory sigs_)
        external
        view
        returns (address[] memory handlers);
    function getCallbackHandlers(address plasmaVault_, address[] memory senders_, bytes4[] memory sigs_)
        external
        view
        returns (address[] memory handlers);
}

