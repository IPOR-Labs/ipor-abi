import json
import os
import sys
import re
import logging
sys.path.append('..')
from shared_utils import *

OUTPUT_FILE = f'{OUTPUT_DIR}/price-feeds.json'

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

logger = setup_env_and_logging()

# get_contract_creation_block, get_contract_deployment_date, and find_addresses_files are now imported from shared_utils


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
    """Fetch all AssetPriceSourceUpdated events for a price oracle in chunks, using cache to avoid redundant queries."""
    logger.info(f"Fetching AssetPriceSourceUpdated events for price oracle: {address}")
    
    try:
        # Check cache first
        cached_events, last_read_block = get_cached_price_feed_events(chain, address)
        
        contract = web3.eth.contract(address=Web3.to_checksum_address(address), abi=PRICE_ORACLE_ABI)
        
        # Get the event signature with 0x prefix
        event_signature = '0x' + web3.keccak(text="AssetPriceSourceUpdated(address,address)").hex()
        logger.info(f"Event signature: {event_signature}")
        
        # Get the latest block number
        latest_block = web3.eth.block_number
        logger.info(f"Latest block number: {latest_block}")
        
        # Determine starting block for fetching new events
        if last_read_block is not None:
            # Start from the block after the last read block
            from_block = last_read_block + 1
            logger.info(f"Using cached data, starting from block: {from_block} (last read: {last_read_block})")
        else:
            # No cache, start from contract creation block or chain start block as fallback
            try:
                from_block = get_contract_creation_block(web3, address, chain)
            except Exception as e:
                logger.warning(f"Could not find contract creation block, using chain start block: {str(e)}")
                from_block = CHAIN_START_BLOCKS.get(chain, 0)
            logger.info(f"No cache found, starting from block: {from_block}")
        
        # If we're already up to date, return cached events
        if from_block > latest_block:
            logger.info(f"Cache is up to date (last read block {last_read_block} >= latest block {latest_block})")
            # Convert cached events back to event-like objects for compatibility
            return _process_cached_price_feed_events(cached_events, web3)
        
        # Collect new events
        new_events = []
        chunk_size = CHUNK_SIZES.get(chain, CHUNK_SIZES["default"])
        logger.info(f"Using chunk size of {chunk_size} for chain {chain}")
        
        # Process in chunks
        current_from_block = from_block
        while current_from_block <= latest_block:
            current_to_block = min(current_from_block + chunk_size, latest_block)
            logger.info(f"Fetching events from block {current_from_block} to {current_to_block}")
            
            try:
                # Get logs for this chunk
                logs = web3.eth.get_logs({
                    'address': Web3.to_checksum_address(address),
                    'topics': [event_signature],
                    'fromBlock': current_from_block,
                    'toBlock': current_to_block
                })
                
                logger.info(f"Found {len(logs)} logs in this chunk")
                
                # Process each log
                for log in logs:
                    try:
                        # Decode the event data
                        event_data = contract.events.AssetPriceSourceUpdated().process_log(log)
                        new_events.append(event_data)
                    except Exception as decode_error:
                        logger.error(f"Error decoding log: {str(decode_error)}")
                        continue
                
            except Exception as chunk_error:
                logger.error(f"Error fetching events for chunk {current_from_block}-{current_to_block}: {str(chunk_error)}")
                # If chunk size is too large, try with a smaller chunk
                if chunk_size >= 10000:
                    logger.info(f"Reducing chunk size and retrying...")
                    chunk_size = chunk_size // 2
                    continue
                
            current_from_block = current_to_block + 1
        
        logger.info(f"New events found: {len(new_events)}")
        
        # Cache the new events
        if new_events or last_read_block is None:
            # Update cache with new events and latest block number
            cache_price_feed_events(chain, address, new_events, latest_block)
        
        # Combine cached events with new events
        all_events = _convert_cached_price_feed_events_to_objects(cached_events, contract) + new_events
        
        logger.info(f"Total events (cached + new): {len(all_events)}")
        
        # Process events to extract price feeds
        return _process_cached_price_feed_events(all_events, web3)
            
    except Exception as e:
        logger.error(f"Error setting up contract for price oracle {address}: {str(e)}")
        return {}

def _convert_cached_price_feed_events_to_objects(cached_events, contract):
    """Convert cached price feed event dictionaries back to event-like objects for compatibility."""
    if not cached_events:
        return []
    
    converted_events = []
    for cached_event in cached_events:
        try:
            # Create a mock event object with the necessary attributes
            class MockEvent:
                def __init__(self, args_dict, block_number, transaction_hash):
                    self.args = args_dict
                    self.blockNumber = block_number
                    self.transactionHash = bytes.fromhex(transaction_hash[2:]) if transaction_hash and transaction_hash.startswith('0x') else None
                    
                def __getitem__(self, key):
                    if key == 'args':
                        return self.args
                    return getattr(self, key, None)
            
            # Convert cached args back to proper format
            args_dict = cached_event.get('args', {})
            block_number = cached_event.get('block_number')
            transaction_hash = cached_event.get('transaction_hash')
            
            mock_event = MockEvent(args_dict, block_number, transaction_hash)
            converted_events.append(mock_event)
            
        except Exception as e:
            logger = logging.getLogger(__name__)
            logger.error(f"Error converting cached price feed event: {str(e)}")
            continue
    
    return converted_events

def _process_cached_price_feed_events(events, web3):
    """Process events (cached or fresh) to extract price feeds."""
    price_feeds = {}
    
    for event in events:
        try:
            # Handle both cached events (dict-like) and fresh events (object-like)
            if hasattr(event, 'args'):
                asset = event.args['asset']
                source = event.args['source']
            elif isinstance(event, dict) and 'args' in event:
                asset = event['args']['asset']
                source = event['args']['source']
            else:
                asset = event['args']['asset']
                source = event['args']['source']
            
            symbol = get_token_symbol(web3, asset)
            if symbol:
                logger.info(f"Found price feed for {symbol} ({asset}) -> {source}")
            else:
                symbol = f"Unknown-{asset[-6:]}"

            price_feeds[asset] = {
                "symbol": symbol,
                "source": source
            }
        except Exception as e:
            logger.error(f"Error processing price feed event: {str(e)}")
            continue
    
    logger.info(f"Found {len(price_feeds)} price feeds from events")
    return price_feeds


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
                "tac": {"price_oracles": []},
                "ink": {"price_oracles": []},
                "plasma": {"price_oracles": []},
                "avalanche": {"price_oracles": []}
            }

        blockchain_priceoracles = {
            "ethereum": {},
            "arbitrum": {},
            "base": {},
            "unichain": {},
            "tac": {},
            "ink": {},
            "plasma": {},
            "avalanche": {}
        }

        web3_connections = create_web3_connections()

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
            "tac": {},
            "ink": {},
            "plasma": {},
            "avalanche": {}
        }

        unique_addresses = {
            "ethereum": {},
            "arbitrum": {},
            "base": {},
            "unichain": {},
            "tac": {},
            "ink": {},
            "plasma": {},
            "avalanche": {}
        }

        address_to_date_key = {
            "ethereum": {},
            "arbitrum": {},
            "base": {},
            "unichain": {},
            "tac": {},
            "ink": {},
            "plasma": {},
            "avalanche": {}
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
            elif "ink" in file_path:
                chain = "ink"
            elif "plasma" in file_path:
                chain = "plasma"
            elif "avalanche" in file_path:
                chain = "avalanche"

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


def generate_markdown_list(addresses_file=None, readme_file="../../README.md"):
    if addresses_file is None:
        addresses_file = get_main_addresses_file()
    try:
        with open(addresses_file, 'r') as f:
            addresses_data = json.load(f)

        try:
            with open(readme_file, 'r') as f:
                readme_content = f.read()
        except FileNotFoundError:
            readme_content = "# Price Oracles Protocol\n\n"

        priceoracles_md = "## Price Oracles List\n\n"
        priceoracles_md += f"*Last updated: {get_current_utc_timestamp()} UTC*\n\n"
        
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

    ensure_output_dir()
    
    with open(OUTPUT_FILE, 'w') as f:
        json.dump(result, f, indent=2)

    logger.info(f"Processing complete. Results written to {OUTPUT_FILE}")

    update_addresses_json(OUTPUT_FILE, get_main_addresses_file())
    
    generate_markdown_list()


if __name__ == "__main__":
    main()
