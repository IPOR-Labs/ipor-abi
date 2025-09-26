# [fill-factory-vaults.sh](fill-factory-vaults.sh) script

## Script Overview

`fill-factory-vaults.sh` is running `fill-factory-vaults.py` script.

`fill-factory-vaults.py` is designed to discover and track IPOR Protocol Plasma Vaults deployed through IporFusionFactoryProxy contracts across different blockchain networks (Ethereum, Arbitrum, Base, Unichain, TAC, INK, Plasma, Avalanche). The script identifies factory proxy addresses from network-specific `addresses.json` files, fetches `FusionInstanceCreated` events from these factory contracts, and consolidates vault information into the main `addresses.json` file. For each vault, it captures essential details like vault addresses, underlying tokens, asset names, and symbols directly from the blockchain.

## Prerequisites

- Python 3.x
- Poetry (for dependency management)

The project uses Poetry to manage dependencies. All required packages are specified in the `pyproject.toml` file.

## Installation

Install dependencies using Poetry
```bash
poetry install
```

## Usage

```bash
./fill-factory-vaults.sh
```

## Script Behavior

The script performs the following operations:

1. **Factory Discovery**
   - Searches through the project directories to find all `addresses.json` files
   - Identifies IporFusionFactoryProxy addresses for different blockchain networks (Ethereum, Arbitrum, Base, etc.)

2. **Event Processing**
   - Connects to each blockchain network using provided RPC URLs
   - Fetches `FusionInstanceCreated` events from each factory contract
   - Uses binary search to optimize finding contract creation blocks
   - Processes events in configurable chunk sizes to handle RPC limitations

3. **Vault Information Collection**
   For each discovered vault, collects:
   - Vault address
   - Underlying token address
   - Asset name and symbol
   - Underlying token symbol

4. **Data Updates**
   - Updates the main `addresses.json` file with discovered vault information
   - For each chain:
     - Creates a 'vaults' array if it doesn't exist
     - Updates existing vault entries or adds new ones
     - Preserves existing vault configurations

5. **Output Generation**
   - Saves collected vault information to `output/fusion_vaults.json`
   - Generates a summary of discovered vaults per chain
   - Logs detailed information about the discovery and update process

The script uses environment variables for RPC URLs and implements error handling and logging throughout the process.

## License

This script is licensed under the GNU General Public License, Version 2. You may redistribute and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 2 of the License, or (at your option) any later version.

For more details, see the [LICENSE](../../LICENSE) file. 
