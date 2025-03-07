import json
import os
import datetime
from dotenv import load_dotenv

from web3 import Web3
from web3.exceptions import ContractLogicError

ADDRESSES_FILENAME = 'addresses.json'
START_PATH = '../../mainnet'
OUTPUT_DIR = 'output'
OUTPUT_FILE = f'{OUTPUT_DIR}/fuses.json'
MAIN_ADDRESSES_FILE = f'{START_PATH}/{ADDRESSES_FILENAME}'

ZERO_ADDRESS = "0x0000000000000000000000000000000000000000"

# Load environment variables from .env file
load_dotenv()

# Get RPC URLs from environment variables
RPC_URLS = {
    "ethereum": os.getenv("ETHEREUM_RPC_URL"),
    "arbitrum": os.getenv("ARBITRUM_RPC_URL"),
    "base": os.getenv("BASE_RPC_URL")
}

# Validate that all required RPC URLs are available
for chain, url in RPC_URLS.items():
    if not url:
        raise ValueError(f"Missing RPC URL for {chain}. Please add {chain.upper()}_RPC_URL to your .env file.")

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
    try:
        contract = web3.eth.contract(address=Web3.to_checksum_address(address), abi=VAULT_ABI)
        return contract.functions.name().call()
    except (ContractLogicError, Exception) as e:
        print(f"Error getting name for {address}: {str(e)}")
        return None


def get_vault_asset(web3, address):
    try:
        contract = web3.eth.contract(address=Web3.to_checksum_address(address), abi=VAULT_ABI)
        return contract.functions.asset().call()
    except (ContractLogicError, Exception) as e:
        print(f"Error getting asset for {address}: {str(e)}")
        return "TODO"


def get_token_symbol(web3, address):
    try:
        contract = web3.eth.contract(address=Web3.to_checksum_address(address), abi=TOKEN_ABI)
        return contract.functions.symbol().call()
    except (ContractLogicError, Exception) as e:
        print(f"Error getting symbol for {address}: {str(e)}")
        return None


def get_contract_deployment_date(web3, address):
    try:
        checksum_address = Web3.to_checksum_address(address)
        
        left = 0
        right = web3.eth.block_number
        
        code = web3.eth.get_code(checksum_address)
        if code == b'' or code == '0x':
            print(f"No code found at {address}, using current date")
            return datetime.datetime.now().strftime('%Y-%m-%d')
        
        while left <= right:
            mid = (left + right) // 2
            
            try:
                code = web3.eth.get_code(checksum_address, block_identifier=mid)
                
                if code == b'' or code == '0x':
                    left = mid + 1
                else:
                    right = mid - 1
            except Exception as e:
                right = mid - 1
        
        deployment_block = left
        
        block = web3.eth.get_block(deployment_block)
        timestamp = block['timestamp']
        
        date = datetime.datetime.fromtimestamp(timestamp).strftime('%Y-%m-%d')
        
        print(f"Found deployment date for {address}: {date} (block {deployment_block}) on {web3.provider.endpoint_uri}")
        
        return date
    except Exception as e:
        print(f"Error getting deployment date for {address}: {str(e)}")
        return datetime.datetime.now().strftime('%Y-%m-%d')


def find_addresses_files(start_path):
    addresses_files = []
    for root, dirs, files in os.walk(start_path):
        if ADDRESSES_FILENAME in files:
            addresses_files.append(os.path.join(root, ADDRESSES_FILENAME))
    return addresses_files


def extract_fuse_fields(file_path):
    try:
        with open(file_path, 'r') as f:
            data = json.load(f)

        extracted_data = {}
        for field in data:
            if "Fuse" in field and data[field] != ZERO_ADDRESS:
                extracted_data[field] = data[field]

        return extracted_data if extracted_data else None

    except Exception as e:
        print(f"Error processing {file_path}: {str(e)}")
        return None


def update_addresses_json(fuses_file, addresses_file):
    try:
        with open(fuses_file, 'r') as f:
            fuses_data = json.load(f)

        try:
            with open(addresses_file, 'r') as f:
                addresses = json.load(f)
        except FileNotFoundError:
            addresses = {
                "ethereum": {"fuses": []},
                "arbitrum": {"fuses": []},
                "base": {"fuses": []}
            }

        blockchain_fuses = {
            "ethereum": {},
            "arbitrum": {},
            "base": {}
        }

        web3_connections = {}
        for chain, url in RPC_URLS.items():
            web3_connections[chain] = Web3(Web3.HTTPProvider(url))

        for file_path, fuses in fuses_data.items():
            chain = None
            if "ethereum" in file_path:
                chain = "ethereum"
            elif "arbitrum" in file_path:
                chain = "arbitrum"
            elif "base" in file_path:
                chain = "base"

            if not chain:
                continue

            web3 = web3_connections[chain]
            
            for field_name, address in fuses.items():
                deployment_date = get_contract_deployment_date(web3, address)
                
                if field_name not in blockchain_fuses[chain]:
                    blockchain_fuses[chain][field_name] = {}
                
                blockchain_fuses[chain][field_name][deployment_date] = address

        for chain, fuse_dict in blockchain_fuses.items():
            if chain not in addresses:
                addresses[chain] = {}

            if "fuses" not in addresses[chain]:
                addresses[chain]["fuses"] = []

            fuse_entries = []
            
            for field_name, versions in fuse_dict.items():
                sorted_versions = sorted(versions.items(), key=lambda x: x[0])
                
                versions_dict = {date: address for date, address in sorted_versions}
                
                fuse_entries.append({
                    "name": field_name,
                    "versions": versions_dict
                })
            
            fuse_entries.sort(key=lambda x: x["name"])
            
            addresses[chain]["fuses"] = fuse_entries

        os.makedirs(os.path.dirname(addresses_file), exist_ok=True)

        with open(addresses_file, 'w') as f:
            json.dump(addresses, f, indent=2)

        print(f"Successfully updated {addresses_file}")

    except Exception as e:
        print(f"Error updating addresses.json: {str(e)}")


def main():
    result = {}

    addresses_files = find_addresses_files(START_PATH)

    for file_path in addresses_files:
        relative_path = os.path.relpath(file_path, '.')
        fuse_data = extract_fuse_fields(file_path)

        if fuse_data:
            result[relative_path] = fuse_data

    os.makedirs(OUTPUT_DIR, exist_ok=True)
    
    with open(OUTPUT_FILE, 'w') as f:
        json.dump(result, f, indent=2)

    print(f"Processing complete. Results written to {OUTPUT_FILE}")

    update_addresses_json(OUTPUT_FILE, MAIN_ADDRESSES_FILE)


if __name__ == "__main__":
    main()
