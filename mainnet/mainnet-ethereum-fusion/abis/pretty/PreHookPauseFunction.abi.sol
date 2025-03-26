interface PauseFunctionPreHook {
    error FunctionPaused(bytes4 selector);

    function run(bytes4 selector_) external pure;
}

