# [fill-vaults.sh](fill-vaults.sh) script

## Script Overview

`fill-vaults.sh` is running `fill-vaults.py` script.

`fill-vaults.py` is designed to process and aggregate information about IPOR Protocol Plasma Vaults across different blockchain networks (Ethereum, Arbitrum, Base). It reads vault addresses from various `addresses.json` files, fetches additional information about each vault using Web3 calls, and updates a main addresses file with the consolidated data.

## Prerequisites

- Python 3.x
- Required Python packages:
  - `web3`
  - `json`
  - `os`

## Usage

```bash
./fill-vaults.sh
```

## Script Behavior

1. **Find Address Files**: 
   - Recursively searches through the `../../mainnet` directory for all `addresses.json` files
   - Extracts Plasma Vault addresses for different tokens (BTC, DAI, RUSD, USDC, USDT, WETH)

2. **Process Vault Information**:
   - Connects to different blockchain networks using RPC endpoints
   - For each vault address, fetches:
     - Vault name
     - Asset address
     - Token symbol

3. **Output Generation**:
   - Creates an intermediate JSON file with all found Plasma Vaults
   - Updates the main `addresses.json` file with consolidated vault information

## Configuration Constants

- `ADDRESSES_FILENAME`: Name of address files to process (`addresses.json`)
- `START_PATH`: Base path for searching address files (`../../mainnet`)
- `OUTPUT_DIR`: Directory for output files (`output`)
- `OUTPUT_FILE`: Path for intermediate results (`output/plasma_vaults.json`)
- `MAIN_ADDRESSES_FILE`: Path to main addresses file (`../../mainnet/addresses.json`)

### Supported Networks

The script supports the following networks with their respective RPC endpoints:
- Ethereum: `https://eth.llamarpc.com`
- Arbitrum: `https://arb1.arbitrum.io/rpc`
- Base: `https://mainnet.base.org`

### Plasma Vault Types

Processes the following vault types:
- IporPlasmaVaultCbBTC
- IporPlasmaVaultDai
- IporPlasmaVaultRUsd
- IporPlasmaVaultUsdc
- IporPlasmaVaultUsdt
- IporPlasmaVaultWBTC
- IporPlasmaVaultWEth

New vaults field names need to be added to the script to `PLASMA_FIELDS` constant.

## Output Format

The script generates a JSON file with the following structure for each network:

```json
{
  "ethereum": {
    "vaults": [
      {
        "name": "Vault Name",
        "token": "Token Symbol",
        "asset": "Asset Address",
        "PlasmaVault": "Vault Address"
      }
    ]
  }
  // Similar structure for arbitrum and base networks
}
```

## Error Handling

- Handles contract interaction errors gracefully
- Provides error messages for failed Web3 calls
- Creates output directories if they don't exist
- Maintains existing data when updating the main addresses file

## License

This script is licensed under the GNU General Public License, Version 2. You may redistribute and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 2 of the License, or (at your option) any later version.

For more details, see the [LICENSE](../../LICENSE) file. 
