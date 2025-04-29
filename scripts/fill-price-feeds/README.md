# [fill-price-feeds.sh](fill-price-feeds.sh) script

## Script Overview

`fill-price-feeds.sh` is running `fill-price-feeds.py` script.

`fill-price-feeds.py` is designed to process and aggregate information about price oracles and their price feeds across different blockchain networks (Ethereum, Arbitrum, Base). It reads price oracle addresses from various `addresses.json` files, determines their deployment dates using Web3 calls, fetches price feed information from on-chain events, and updates a main addresses file with the consolidated data.

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
./fill-price-feeds.sh
```

## Script Behavior

1. **Find Address Files**: 
   - Recursively searches through the `../../mainnet` and `../../testnet` directories for all `addresses.json` files
   - Extracts price oracle addresses from fields that match the regex `PriceOracleMiddleware.*Proxy` in their name

2. **Process Price Oracle Information**:
   - Connects to different blockchain networks using RPC endpoints defined in `.env` file
   - For each price oracle address:
     - Determines the deployment date using binary search on blockchain blocks
     - Fetches `AssetPriceSourceUpdated` events to identify price feeds
     - Organizes price oracles by name and deployment date

3. **Output Generation**:
   - Creates an intermediate JSON file with all found price oracles
   - Updates the main `addresses.json` file with consolidated price oracle information
   - Generates markdown documentation for price oracles and their price feeds

## Configuration Constants

- `ADDRESSES_FILENAME`: Name of address files to process (`addresses.json`)
- `MAINNET_PATH`: Base path for searching mainnet address files (`../../mainnet`)
- `TESTNET_PATH`: Base path for searching testnet address files (`../../testnet`)
- `OUTPUT_DIR`: Directory for output files (`output`)
- `OUTPUT_FILE`: Path for intermediate results (`output/price-feeds.json`)
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
    "price_oracles": [
      {
        "name": "PriceOracleName",
        "versions": {
          "2023-01-01_001": {
            "address": "0x1234...",
            "price_feeds": {
              "0xAssetAddress": {
                "symbol": "TokenSymbol",
                "source": "0xPriceFeedSource"
              }
    ...
  }
  // Similar structure for arbitrum and base networks
}

```

Additionally, the script updates the main README.md file with a formatted list of price oracles and their price feeds.

## Error Handling

- Handles contract interaction errors gracefully
- Provides detailed logging for debugging purposes
- Creates output directories if they don't exist
- Maintains existing data when updating the main addresses file
- Validates RPC URLs from environment variables

## License

This script is licensed under the GNU General Public License, Version 2. You may redistribute and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 2 of the License, or (at your option) any later version.

For more details, see the [LICENSE](../../LICENSE) file.
