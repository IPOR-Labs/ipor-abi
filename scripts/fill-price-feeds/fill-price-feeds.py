import json
import os
import datetime
import logging
from dotenv import load_dotenv
import re

from web3 import Web3
from web3.exceptions import ContractLogicError

ADDRESSES_FILENAME = 'addresses.json'
MAINNET_PATH = '../../mainnet'
TESTNET_PATH = '../../testnet'
OUTPUT_DIR = 'output'
OUTPUT_FILE = f'{OUTPUT_DIR}/price-feeds.json'
MAIN_ADDRESSES_FILE = f'{MAINNET_PATH}/{ADDRESSES_FILENAME}'

ZERO_ADDRESS = "0x0000000000000000000000000000000000000000"

load_dotenv()

RPC_URLS = {
    "ethereum": os.getenv("ETHEREUM_RPC_URL", "https://eth.llamarpc.com"),
    "arbitrum": os.getenv("ARBITRUM_RPC_URL", "https://arb1.arbitrum.io/rpc"),
    "base": os.getenv("BASE_RPC_URL", "https://mainnet.base.org"),
    "unichain": os.getenv("UNICHAIN_RPC_URL", "https://mainnet.unichain.org"),
    "tac": os.getenv("TAC_RPC_URL", "https://rpc.ankr.com/tac")
}

for chain, url in RPC_URLS.items():
    if not url:
        raise ValueError(f"Missing RPC URL for {chain}. Please add {chain.upper()}_RPC_URL to your .env file.")

CHAIN_START_BLOCKS = {
    "ethereum": 20733870,
    "arbitrum": 218743859,
    "base": 21704649,
    "unichain": 17867366,
    "tac": 239
}

EXPLORERS = {
    "ethereum": "https://etherscan.io/address/",
    "arbitrum": "https://arbiscan.io/address/",
    "base": "https://basescan.org/address/",
    "unichain": "https://uniscan.xyz/address/",
    "tac": "https://explorer.tac.build/address/"
}

NAMES = {
    "ethereum": "Ethereum",
    "arbitrum": "Arbitrum",
    "base": "Base",
    "unichain": "Unichain",
    "tac": "TAC"
}

TOKEN_ABI = [
    {
        "inputs": [],
        "name": "symbol",
        "outputs": [{"internalType": "string", "name": "", "type": "string"}],
        "stateMutability": "view",
        "type": "function"
    }
]

PRICE_ORACLE_ABI = [
    {
        "anonymous": False,
        "inputs": [
            {"indexed": False, "internalType": "address", "name": "asset", "type": "address"},
            {"indexed": False, "internalType": "address", "name": "source", "type": "address"}
        ],
        "name": "AssetPriceSourceUpdated",
        "type": "event"
    }
]

NOT_PRICE_FEED_NAMES = [
]

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)


def get_contract_deployment_date(web3, address, chain):
    try:
        checksum_address = Web3.to_checksum_address(address)
        logger.info(f"Calling web3: get_contract_deployment_date for address {address}")
        
        left = CHAIN_START_BLOCKS.get(chain, 0)
        logger.info(f"Calling web3: get_block_number")
        right = web3.eth.block_number
        
        logger.info(f"Calling web3: get_code for address {address}")
        code = web3.eth.get_code(checksum_address)
        if code == b'' or code == '0x':
            logger.info(f"No code found at {address}, using current date")
            return datetime.datetime.now().strftime('%Y-%m-%d')
        
        while left <= right:
            mid = (left + right) // 2
            
            try:
                logger.info(f"Calling web3: get_code for address {address} at block {mid}")
                code = web3.eth.get_code(checksum_address, block_identifier=mid)
                
                if code == b'' or code == '0x':
                    left = mid + 1
                else:
                    right = mid - 1
            except Exception as e:
                right = mid - 1
        
        deployment_block = left
        
        logger.info(f"Calling web3: get_block for block {deployment_block}")
        block = web3.eth.get_block(deployment_block)
        timestamp = block['timestamp']
        
        date = datetime.datetime.fromtimestamp(timestamp).strftime('%Y-%m-%d')
        
        logger.info(f"Found deployment date for {address}: {date} (block {deployment_block}) on {web3.provider.endpoint_uri}")
        
        return date
    except Exception as e:
        logger.error(f"Error getting deployment date for {address}: {str(e)}")
        return datetime.datetime.now().strftime('%Y-%m-%d')


def find_addresses_files(start_path):
    addresses_files = []
    for root, dirs, files in os.walk(start_path):
        if ADDRESSES_FILENAME in files:
            addresses_files.append(os.path.join(root, ADDRESSES_FILENAME))
    return addresses_files


def extract_price_feed_fields(file_path):
    try:
        with open(file_path, 'r') as f:
            data = json.load(f)

        extracted_data = {}
        for field in data:
            if re.search(r'PriceOracleMiddleware.*Proxy', field, re.IGNORECASE) and data[field] != ZERO_ADDRESS:
                if field in NOT_PRICE_FEED_NAMES:
                    logger.info(f"Skipping field {field} as it's in NOT_PRICE_FEED_NAMES list")
                    continue
                extracted_data[field] = data[field]

        return extracted_data if extracted_data else None

    except Exception as e:
        logger.error(f"Error processing {file_path}: {str(e)}")
        return None


def get_price_feed_events(web3, address, chain):
    try:
        checksum_address = Web3.to_checksum_address(address)
        logger.info(f"Getting AssetPriceSourceUpdated events for {address} on {chain}")
        
        contract = web3.eth.contract(address=checksum_address, abi=PRICE_ORACLE_ABI)
        start_block = CHAIN_START_BLOCKS.get(chain, 0)

        price_feeds = {}
        
        try:
            event_filter = contract.events.AssetPriceSourceUpdated.create_filter(
                from_block=start_block,
                to_block='latest'
            )
            events = event_filter.get_all_entries()
            
            for event in events:
                asset = event['args']['asset']
                source = event['args']['source']
                
                try:
                    token_contract = web3.eth.contract(address=asset, abi=TOKEN_ABI)
                    symbol = token_contract.functions.symbol().call()
                    logger.info(f"Found price feed for {symbol} ({asset}) -> {source}")
                except Exception as e:
                    logger.warning(f"Could not get symbol for {asset}: {str(e)}")
                    symbol = f"Unknown-{asset[-6:]}"

                price_feeds[asset] = {
                    "symbol": symbol,
                    "source": source
                }
            
        except Exception as e:
            logger.error(f"Error fetching events from {start_block} to latest: {str(e)}")
        
        logger.info(f"Found {len(price_feeds)} price feeds from events for {address}")
        return price_feeds
        
    except Exception as e:
        logger.error(f"Error getting price feed events for {address}: {str(e)}")
        return {}


def update_addresses_json(priceoracles_file, addresses_file):
    try:
        with open(priceoracles_file, 'r') as f:
            priceoracles_data = json.load(f)

        try:
            with open(addresses_file, 'r') as f:
                addresses = json.load(f)
        except FileNotFoundError:
            addresses = {
                "ethereum": {"price_oracles": []},
                "arbitrum": {"price_oracles": []},
                "base": {"price_oracles": []},
                "unichain": {"price_oracles": []},
                "tac": {"price_oracles": []}
            }

        blockchain_priceoracles = {
            "ethereum": {},
            "arbitrum": {},
            "base": {},
            "unichain": {},
            "tac": {}
        }

        web3_connections = {}
        for chain, url in RPC_URLS.items():
            web3_connections[chain] = Web3(Web3.HTTPProvider(url))

        existing_priceoracles = {}
        for chain in addresses:
            existing_priceoracles[chain] = {}
            if "price_oracles" in addresses[chain]:
                for priceoracle in addresses[chain]["price_oracles"]:
                    existing_priceoracles[chain][priceoracle["name"]] = {}
                    for date_key, version_data in priceoracle.get("versions", {}).items():
                        if isinstance(version_data, str):
                            existing_priceoracles[chain][priceoracle["name"]][date_key] = {"address": version_data}
                        else:
                            existing_priceoracles[chain][priceoracle["name"]][date_key] = version_data
                    blockchain_priceoracles[chain][priceoracle["name"]] = existing_priceoracles[chain][priceoracle["name"]]

        price_feeds_from_events = {
            "ethereum": {},
            "arbitrum": {},
            "base": {},
            "unichain": {},
            "tac": {}
        }

        unique_addresses = {
            "ethereum": {},
            "arbitrum": {},
            "base": {},
            "unichain": {},
            "tac": {}
        }

        address_to_date_key = {
            "ethereum": {},
            "arbitrum": {},
            "base": {},
            "unichain": {},
            "tac": {}
        }

        for file_path, priceoracles in priceoracles_data.items():
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

            if not chain:
                continue

            web3 = web3_connections[chain]
            
            for field_name, address in priceoracles.items():
                address_already_known = False
                
                if field_name not in blockchain_priceoracles[chain]:
                    blockchain_priceoracles[chain][field_name] = {}

                for date_key, version_data in list(blockchain_priceoracles[chain][field_name].items()):
                    existing_address = version_data.get("address")
                    if existing_address and existing_address.lower() == address.lower():
                        address_already_known = True
                        logger.info(f"Address {address} already exists for {field_name} on {chain} with date key {date_key}")
                        break
                
                if not address_already_known:
                    deployment_date = get_contract_deployment_date(web3, address, chain)
                    
                    base_date_key = deployment_date
                    iteration = 1
                    date_key = f"{base_date_key}_001"
                    
                    existing_keys = blockchain_priceoracles[chain][field_name].keys()
                    matching_keys = [k for k in existing_keys if k.startswith(base_date_key)]
                    
                    if matching_keys:
                        max_iteration = 0
                        for key in matching_keys:
                            if '_' in key:
                                try:
                                    iter_num = int(key.split('_')[1])
                                    max_iteration = max(max_iteration, iter_num)
                                except (ValueError, IndexError):
                                    pass
                        
                        iteration = max_iteration + 1
                        date_key = f"{base_date_key}_{iteration:03d}"
                    
                    blockchain_priceoracles[chain][field_name][date_key] = {"address": address}
                    
                    if field_name not in address_to_date_key[chain]:
                        address_to_date_key[chain][field_name] = {}
                    address_to_date_key[chain][field_name][address.lower()] = date_key
                
                unique_addresses[chain][address] = True

        for chain, addresses_dict in unique_addresses.items():
            web3 = web3_connections[chain]
            logger.info(f"Processing {len(addresses_dict)} unique price oracle addresses for {chain}")
            
            for address in addresses_dict:
                feeds = get_price_feed_events(web3, address, chain)
                if feeds:
                    for field_name, versions in blockchain_priceoracles[chain].items():
                        for date_key, version_data in versions.items():
                            if version_data.get("address") == address:
                                if field_name not in price_feeds_from_events[chain]:
                                    price_feeds_from_events[chain][field_name] = {}
                                
                                price_feeds_from_events[chain][field_name][address] = feeds

        for chain in blockchain_priceoracles:
            for field_name in blockchain_priceoracles[chain]:
                address_map = {}
                for date_key, version_data in blockchain_priceoracles[chain][field_name].items():
                    address = version_data.get("address", "").lower()
                    if address:
                        if address in address_map:

                            existing_date_key = address_map[address]
                            logger.warning(f"Duplicate address {address} found for {field_name} on {chain} "
                                          f"with date keys {existing_date_key} and {date_key}")
                              
                            if existing_date_key < date_key:
                                logger.info(f"Removing duplicate entry with date key {date_key}")
                                del blockchain_priceoracles[chain][field_name][date_key]
                            else:
                                logger.info(f"Removing duplicate entry with date key {existing_date_key}")
                                del blockchain_priceoracles[chain][field_name][existing_date_key]
                                address_map[address] = date_key
                        else:
                            address_map[address] = date_key

        for chain, priceoracle_dict in blockchain_priceoracles.items():
            if chain not in addresses:
                addresses[chain] = {}

            if "price_oracles" not in addresses[chain]:
                addresses[chain]["price_oracles"] = []

            priceoracle_entries = []
            
            for field_name, versions in priceoracle_dict.items():
                def sort_key(item):
                    key = item[0]
                    if '_' in key:
                        date_part, iter_part = key.split('_', 1)
                        try:
                            iter_num = int(iter_part)
                            return (date_part, iter_num)
                        except (ValueError, IndexError):
                            return (key, 0)
                    return (key, 0)
                
                sorted_versions = sorted(versions.items(), key=sort_key)
                
                versions_dict = {}
                for date_key, version_data in sorted_versions:
                    versions_dict[date_key] = version_data
                
                priceoracle_entry = {
                    "name": field_name,
                    "versions": versions_dict
                }
                
                if field_name in price_feeds_from_events[chain]:
                    feeds_by_address = price_feeds_from_events[chain][field_name]
                    
                    for date_key, version_data in versions_dict.items():
                        address = version_data.get("address")
                        if address and address in feeds_by_address:
                            version_data["price_feeds"] = feeds_by_address[address]
                
                priceoracle_entries.append(priceoracle_entry)
            
            priceoracle_entries.sort(key=lambda x: x["name"])
            
            addresses[chain]["price_oracles"] = priceoracle_entries

        os.makedirs(os.path.dirname(addresses_file), exist_ok=True)

        with open(addresses_file, 'w') as f:
            json.dump(addresses, f, indent=2)

        logger.info(f"Successfully updated {addresses_file}")

    except Exception as e:
        logger.error(f"Error updating addresses.json: {str(e)}")


def generate_markdown_list(addresses_file=MAIN_ADDRESSES_FILE, readme_file="../../README.md"):
    try:
        with open(addresses_file, 'r') as f:
            addresses_data = json.load(f)

        try:
            with open(readme_file, 'r') as f:
                readme_content = f.read()
        except FileNotFoundError:
            readme_content = "# Price Oracles Protocol\n\n"

        priceoracles_md = "## Price Oracles List\n\n"
        priceoracles_md += f"*Last updated: {datetime.datetime.now(datetime.timezone.utc).strftime('%Y-%m-%d %H:%M:%S')} UTC*\n\n"
        
        for chain, chain_data in addresses_data.items():
            if "price_oracles" in chain_data and chain_data["price_oracles"]:
                priceoracles_md += f"### {NAMES[chain]} Price Oracles\n\n"
                
                explorer_base_url = EXPLORERS.get(chain.lower(), "")
                sorted_priceoracles = sorted(chain_data["price_oracles"], key=lambda x: x["name"])
                
                priceoracles_md += f"| Price Oracle Name | Address / View in Explorer |\n"
                priceoracles_md += "|-----------|---------------------------|\n"
                
                def sort_key(item):
                    key = item[0]
                    if '_' in key:
                        date_part, iter_part = key.split('_', 1)
                        try:
                            iter_num = int(iter_part)
                            return (date_part, iter_num)
                        except (ValueError, IndexError):
                            return (key, 0)
                    return (key, 0)
                
                for priceoracle in sorted_priceoracles:
                    priceoracle_name = priceoracle["name"]
                    
                    sorted_versions = sorted(priceoracle["versions"].items(), key=sort_key, reverse=True)
                    if sorted_versions:
                        newest_date_key, newest_version = sorted_versions[0]
                        newest_address = newest_version.get("address") if isinstance(newest_version, dict) else newest_version
                        if explorer_base_url:
                            address_display = f"`{newest_address}` [View]({explorer_base_url}{newest_address}#code)"
                        else:
                            address_display = f"`{newest_address}`"
                        priceoracles_md += f"| `{priceoracle_name}` | {address_display} |\n"
                
                priceoracles_md += "\n"
                
                for priceoracle in sorted_priceoracles:
                    priceoracle_name = priceoracle["name"]
                    sorted_versions = sorted(priceoracle["versions"].items(), key=sort_key, reverse=True)
                    
                    if sorted_versions:
                        priceoracles_md += f"#### Price Feeds for `{priceoracle_name}`\n\n"
                        
                        for date_key, version_data in sorted_versions:
                            address = version_data.get("address") if isinstance(version_data, dict) else version_data
                            display_date = date_key.split('_')[0] if '_' in date_key else date_key
                            
                            if explorer_base_url:
                                address_display = f"`{address}` [View]({explorer_base_url}{address}#code)"
                            else:
                                address_display = f"`{address}`"
                            
                            priceoracles_md += f"##### Version {display_date} - {address_display}\n\n"
                            
                            price_feeds = version_data.get("price_feeds", {}) if isinstance(version_data, dict) else {}
                            
                            if price_feeds:
                                priceoracles_md += "| Asset | Source / View in Explorer |\n"
                                priceoracles_md += "|-------|---------------|\n"
                                
                                for asset_address, feed_data in price_feeds.items():
                                    symbol = feed_data.get("symbol", "Unknown")
                                    source = feed_data.get("source", "")
                                    
                                    asset_link = f"**{symbol}** `{asset_address}`"
                                    source_link = f"`{source}` [View]({explorer_base_url}{source})" if source else "`None`"
                                    
                                    priceoracles_md += f"| {asset_link} | {source_link} |\n"
                                
                                priceoracles_md += "\n"
                            else:
                                priceoracles_md += "No price feeds found for this version.\n\n"
                
                priceoracles_md += "\n"

        import re
        sections = re.split(r'(^##\s+[^\n]+\n)', readme_content, flags=re.MULTILINE)
        
        priceoracles_list_found = False
        for i in range(1, len(sections), 2):
            if "## Price Oracles List" in sections[i]:
                sections[i+1] = "\n" + priceoracles_md.replace("## Price Oracles List\n\n", "")
                priceoracles_list_found = True
                break
        
        if not priceoracles_list_found:
            sections.append("\n\n## Price Oracles List\n")
            sections.append("\n" + priceoracles_md.replace("## Price Oracles List\n\n", ""))
        
        new_readme_content = "".join(sections)
        
        with open(readme_file, 'w') as f:
            f.write(new_readme_content.strip() + "\n")
            
        logger.info(f"Price Oracles list updated in {readme_file}")
        
        output_md_file = f"{OUTPUT_DIR}/price_oracles_list.md"
        os.makedirs(os.path.dirname(output_md_file), exist_ok=True)
        with open(output_md_file, 'w') as f:
            f.write(priceoracles_md)
        
    except Exception as e:
        logger.error(f"Error generating markdown list: {str(e)}")


def main():
    result = {}

    addresses_files = find_addresses_files(MAINNET_PATH)
    addresses_files.extend(find_addresses_files(TESTNET_PATH))

    for file_path in addresses_files:
        relative_path = os.path.relpath(file_path, '.')
        price_feed_data = extract_price_feed_fields(file_path)

        if price_feed_data:
            result[relative_path] = price_feed_data

    os.makedirs(OUTPUT_DIR, exist_ok=True)
    
    with open(OUTPUT_FILE, 'w') as f:
        json.dump(result, f, indent=2)

    logger.info(f"Processing complete. Results written to {OUTPUT_FILE}")

    update_addresses_json(OUTPUT_FILE, MAIN_ADDRESSES_FILE)
    
    generate_markdown_list()


if __name__ == "__main__":
    main()
