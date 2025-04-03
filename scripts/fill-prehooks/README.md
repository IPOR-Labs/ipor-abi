# [fill-prehooks.sh](fill-prehooks.sh) script

## Script Overview

`fill-prehooks.sh` is running `fill-prehooks.py` script.

`fill-prehooks.py` is designed to process and aggregate information about IPOR Protocol PreHooks across different blockchain networks (Ethereum, Arbitrum, Base). It reads PreHook addresses from various `addresses.json` files, determines their deployment dates using Web3 calls, and updates a main addresses file with the consolidated data.

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
./fill-prehooks.sh
```

## Script Behavior

1. **Find Address Files**: 
   - Recursively searches through the `../../mainnet` directory for all `addresses.json` files
   - Extracts prehook addresses from fields containing "prehook" in their name

2. **Process prehook Information**:
   - Connects to different blockchain networks using RPC endpoints defined in `.env` file
   - For each prehook address:
     - Determines the deployment date using binary search on blockchain blocks
     - Organizes prehooks by name and deployment date

3. **Output Generation**:
   - Creates an intermediate JSON file with all found prehooks
   - Updates the main `addresses.json` file with consolidated prehook information

## Configuration Constants

- `ADDRESSES_FILENAME`: Name of address files to process (`addresses.json`)
- `START_PATH`: Base path for searching address files (`../../mainnet`)
- `OUTPUT_DIR`: Directory for output files (`output`)
- `OUTPUT_FILE`: Path for intermediate results (`output/prehooks.json`)
- `MAIN_ADDRESSES_FILE`: Path to main addresses file (`../../mainnet/addresses.json`)

### Supported Networks

The script supports the following networks with their respective RPC endpoints defined in the `.env` file:
- Ethereum: `ETHEREUM_RPC_URL`
- Arbitrum: `ARBITRUM_RPC_URL`
- Base: `BASE_RPC_URL`

### Chain Start Blocks

The script uses predefined start blocks for each chain to optimize the binary search:
- Ethereum: 20733870
- Arbitrum: 218743859
- Base: 21704649

## Output Format

The script generates a JSON file with the following structure for each network:

```json
{
    "ethereum": {
        "prehooks": [
            {
                "name": "PrehookName",
                "versions": {
                    "2023-01-01": "0x1234...",
                    "2023-02-15": "0x5678..."
                }
            }
        ]
    }
    // Similar structure for arbitrum and base networks
}
```

## Error Handling

- Handles contract interaction errors gracefully
- Provides detailed logging for debugging purposes
- Creates output directories if they don't exist
- Maintains existing data when updating the main addresses file
- Validates RPC URLs from environment variables

## License

This script is licensed under the GNU General Public License, Version 2. You may redistribute and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 2 of the License, or (at your option) any later version.

For more details, see the [LICENSE](../../LICENSE) file.