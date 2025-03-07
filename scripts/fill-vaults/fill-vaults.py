import json
import os
import logging
from dotenv import load_dotenv

from web3 import Web3
from web3.exceptions import ContractLogicError

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

ADDRESSES_FILENAME = 'addresses.json'
START_PATH = '../../mainnet'
OUTPUT_DIR = 'output'
OUTPUT_FILE = f'{OUTPUT_DIR}/plasma_vaults.json'
MAIN_ADDRESSES_FILE = f'{START_PATH}/{ADDRESSES_FILENAME}'

ZERO_ADDRESS = "0x0000000000000000000000000000000000000000"
PLASMA_FIELDS = [
    'IporPlasmaVaultCbBTC',
    'IporPlasmaVaultDai',
    'IporPlasmaVaultRUsd',
    'IporPlasmaVaultUsdc',
    'IporPlasmaVaultUsdt',
    'IporPlasmaVaultWBTC',
    'IporPlasmaVaultWEth'
]

load_dotenv()

RPC_URLS = {
    "ethereum": os.getenv("ETHEREUM_RPC_URL", "https://eth.llamarpc.com"),
    "arbitrum": os.getenv("ARBITRUM_RPC_URL", "https://arb1.arbitrum.io/rpc"),
    "base": os.getenv("BASE_RPC_URL", "https://mainnet.base.org")
}

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

TOKEN_ABI = [
    {
        "inputs": [],
        "name": "symbol",
        "outputs": [{"internalType": "string", "name": "", "type": "string"}],
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


def get_token_symbol(web3, address):
    logger.info(f"Executing web3 call: get_token_symbol for address {address}")
    try:
        contract = web3.eth.contract(address=Web3.to_checksum_address(address), abi=TOKEN_ABI)
        return contract.functions.symbol().call()
    except (ContractLogicError, Exception) as e:
        logger.error(f"Error getting symbol for {address}: {str(e)}")
        return None


def find_addresses_files(start_path):
    addresses_files = []
    for root, dirs, files in os.walk(start_path):
        if ADDRESSES_FILENAME in files:
            addresses_files.append(os.path.join(root, ADDRESSES_FILENAME))
    return addresses_files


def extract_plasma_fields(file_path):
    try:
        with open(file_path, 'r') as f:
            data = json.load(f)

        extracted_data = {
            field: data[field]
            for field in PLASMA_FIELDS
            if field in data and data[field] != ZERO_ADDRESS
        }

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
                "base": {"vaults": []}
            }

        web3_connections = {
            chain: Web3(Web3.HTTPProvider(url))
            for chain, url in RPC_URLS.items()
        }

        for file_path, vaults in plasma_data.items():
            chain = None
            if "ethereum" in file_path:
                chain = "ethereum"
            elif "arbitrum" in file_path:
                chain = "arbitrum"
            elif "base" in file_path:
                chain = "base"

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

    addresses_files = find_addresses_files(START_PATH)

    for file_path in addresses_files:
        relative_path = os.path.relpath(file_path, '.')
        plasma_data = extract_plasma_fields(file_path)

        if plasma_data:
            result[relative_path] = plasma_data

    with open(OUTPUT_FILE, 'w') as f:
        json.dump(result, f, indent=2)

    logger.info(f"Processing complete. Results written to {OUTPUT_FILE}")

    update_addresses_json(OUTPUT_FILE, MAIN_ADDRESSES_FILE)


if __name__ == "__main__":
    main()