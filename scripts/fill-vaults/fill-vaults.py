import json
import os
import sys
sys.path.append('..')
from shared_utils import *

logger = setup_env_and_logging()

OUTPUT_FILE = f'{OUTPUT_DIR}/plasma_vaults.json'
PLASMA_FIELDS = [
    'IporPlasmaVaultCbBTC',
    'IporPlasmaVaultDai',
    'IporPlasmaVaultRUsd',
    'IporPlasmaVaultUsdc',
    'IporPlasmaVaultUsdt',
    'IporPlasmaVaultWBTC',
    'IporPlasmaVaultWEth',
    'IporPlasmaVaultWstETH',
    'IporPlasmaVaultUsdcLPCO',
    'IporPlasmaVaultUsdcCSLL',
    'PlasmaVaultStETH',
    'PlasmaVaultWeETH',
    'IporPlasmaVaultUsdcTAUSRP',
    'PlasmaVault_USDC_iUSDC',
    'PlasmaVault_sUSDf_iFALC',
    'PlasmaVaultWstETH',
    'PlasmaVaultUsdcTAUBOND',
    'PlasmaVault_USDC_Autopilot_USDC',
    'PlasmaVault_wETH_BCV1',
    'PlasmaVault_USDC_BASEX',
    'PlasmaVault_wBTC_vBTC',
    'PlasmaVault_USDC_F1_PP_NOTE',
    'PlasmaVault_USDC_PILOT_V1',
    'PlasmaVault_stETH_ipstETHfusion',
    'PlasmaVault_wETH_K3WETH'
]

VAULT_ABI = [
    {
        "inputs": [],
        "name": "name",
        "outputs": [{"internalType": "string", "name": "", "type": "string"}],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "asset",
        "outputs": [{"internalType": "address", "name": "", "type": "address"}],
        "stateMutability": "view",
        "type": "function"
    }
]

def get_vault_name(web3, address):
    logger.info(f"Executing web3 call: get_vault_name for address {address}")
    try:
        contract = web3.eth.contract(address=Web3.to_checksum_address(address), abi=VAULT_ABI)
        return contract.functions.name().call()
    except (ContractLogicError, Exception) as e:
        logger.error(f"Error getting name for {address}: {str(e)}")
        return None


def get_vault_asset(web3, address):
    logger.info(f"Executing web3 call: get_vault_asset for address {address}")
    try:
        contract = web3.eth.contract(address=Web3.to_checksum_address(address), abi=VAULT_ABI)
        return contract.functions.asset().call()
    except (ContractLogicError, Exception) as e:
        logger.error(f"Error getting asset for {address}: {str(e)}")
        return "TODO"

# get_token_symbol and find_addresses_files are now imported from shared_utils


def extract_plasma_fields(file_path):
    try:
        with open(file_path, 'r') as f:
            data = json.load(f)

        # Create a case-insensitive mapping of fields
        data_lower = {k.lower(): (k, v) for k, v in data.items()}
        
        extracted_data = {}
        for field in PLASMA_FIELDS:
            field_lower = field.lower()
            if field_lower in data_lower and data_lower[field_lower][1] != ZERO_ADDRESS:
                original_key, value = data_lower[field_lower]
                extracted_data[original_key] = value

        return extracted_data if extracted_data else None

    except Exception as e:
        logger.error(f"Error processing {file_path}: {str(e)}")
        return None


def update_addresses_json(plasma_vaults_file, addresses_file):
    try:
        with open(plasma_vaults_file, 'r') as f:
            plasma_data = json.load(f)

        try:
            with open(addresses_file, 'r') as f:
                addresses = json.load(f)
        except FileNotFoundError:
            addresses = {
                "ethereum": {"vaults": []},
                "arbitrum": {"vaults": []},
                "base": {"vaults": []},
                "unichain": {"vaults": []},
                "tac": {"vaults": []},
                "ink": {"vaults": []},
                "plasma": {"vaults": []},
                "avalanche": {"vaults": []},
                "katana": {"vaults": []}
            }

        web3_connections = create_web3_connections()

        for file_path, vaults in plasma_data.items():
            chain = None
            if "ethereum" in file_path:
                chain = "ethereum"
            elif "arbitrum" in file_path:
                chain = "arbitrum"
            elif "base" in file_path:
                chain = "base"
            elif "unichain" in file_path:
                chain = "unichain"
            elif "tac" in file_path:
                chain = "tac"
            elif "ink" in file_path:
                chain = "ink"
            elif "plasma" in file_path:
                chain = "plasma"
            elif "avalanche" in file_path:
                chain = "avalanche"
            elif "katana" in file_path:
                chain = "katana"

            if not chain:
                continue

            if chain not in addresses:
                addresses[chain] = {}

            if "vaults" not in addresses[chain]:
                addresses[chain]["vaults"] = []

            for field_name, address in vaults.items():
                logger.info(f"Processing new address: {address} ({field_name}) on {chain}")
                vault_name = get_vault_name(web3_connections[chain], address)
                if not vault_name:
                    vault_name = field_name

                asset_address = get_vault_asset(web3_connections[chain], address)
                token = get_token_symbol(web3_connections[chain], asset_address)

                vault_entry = {
                    "name": vault_name,
                    "token": token,
                    "asset": asset_address,
                    "PlasmaVault": address
                }

                existing_vault = next(
                    (v for v in addresses[chain]["vaults"] if v["name"] == vault_name),
                    None
                )

                if existing_vault:
                    existing_vault.update(vault_entry)
                else:
                    addresses[chain]["vaults"].append(vault_entry)

        os.makedirs(os.path.dirname(addresses_file), exist_ok=True)

        with open(addresses_file, 'w') as f:
            json.dump(addresses, f, indent=2)

        logger.info(f"Successfully updated {addresses_file}")

    except Exception as e:
        logger.error(f"Error updating addresses.json: {str(e)}")


def main():
    result = {}

    addresses_files = find_addresses_files(MAINNET_PATH)

    for file_path in addresses_files:
        relative_path = os.path.relpath(file_path, '.')
        plasma_data = extract_plasma_fields(file_path)

        if plasma_data:
            result[relative_path] = plasma_data

    with open(OUTPUT_FILE, 'w') as f:
        json.dump(result, f, indent=2)

    logger.info(f"Processing complete. Results written to {OUTPUT_FILE}")

    update_addresses_json(OUTPUT_FILE, get_main_addresses_file())


if __name__ == "__main__":
    main()
