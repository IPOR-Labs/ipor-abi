import json
import os
import sys
import logging
sys.path.append('..')
from shared_utils import *

logger = setup_env_and_logging()

# Chains to skip when fetching events
SKIP_CHAINS = {}

FACTORY_ABI = [
    {
        "anonymous": False,
        "inputs": [
            {"indexed": False, "internalType": "uint256", "name": "index", "type": "uint256"},
            {"indexed": False, "internalType": "uint256", "name": "version", "type": "uint256"},
            {"indexed": False, "internalType": "string", "name": "assetName", "type": "string"},
            {"indexed": False, "internalType": "string", "name": "assetSymbol", "type": "string"},
            {"indexed": False, "internalType": "uint8", "name": "assetDecimals", "type": "uint8"},
            {"indexed": False, "internalType": "address", "name": "underlyingToken", "type": "address"},
            {"indexed": False, "internalType": "string", "name": "underlyingTokenSymbol", "type": "string"},
            {"indexed": False, "internalType": "uint8", "name": "underlyingTokenDecimals", "type": "uint8"},
            {"indexed": False, "internalType": "address", "name": "initialOwner", "type": "address"},
            {"indexed": False, "internalType": "address", "name": "plasmaVault", "type": "address"},
            {"indexed": False, "internalType": "address", "name": "plasmaVaultBase", "type": "address"},
            {"indexed": False, "internalType": "address", "name": "feeManager", "type": "address"}
        ],
        "name": "FusionInstanceCreated",
        "type": "event"
    }
]

# get_contract_creation_block is now imported from shared_utils

def get_fusion_events(web3, factory_address, chain):
    """Fetch all FusionInstanceCreated events for a factory in chunks, using cache to avoid redundant queries."""
    logger.info(f"Fetching FusionInstanceCreated events for factory: {factory_address}")
    
    try:
        # Check cache first
        cached_events, last_read_block = get_cached_fusion_events(chain, factory_address)
        
        contract = web3.eth.contract(address=Web3.to_checksum_address(factory_address), abi=FACTORY_ABI)
        
        # Get the event signature with 0x prefix
        event_signature = '0x' + web3.keccak(text="FusionInstanceCreated(uint256,uint256,string,string,uint8,address,string,uint8,address,address,address,address)").hex()
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
            # No cache, start from contract creation block
            from_block = get_contract_creation_block(web3, factory_address, chain)
            logger.info(f"No cache found, starting from contract creation block: {from_block}")
        
        # If we're already up to date, return cached events
        if from_block > latest_block:
            logger.info(f"Cache is up to date (last read block {last_read_block} >= latest block {latest_block})")
            # Convert cached events back to event-like objects for compatibility
            return _convert_cached_events_to_objects(cached_events, contract)
        
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
                    'address': Web3.to_checksum_address(factory_address),
                    'topics': [event_signature],
                    'fromBlock': current_from_block,
                    'toBlock': current_to_block
                })
                
                logger.info(f"Found {len(logs)} logs in this chunk")
                
                # Process each log
                for log in logs:
                    try:
                        # Decode the event data
                        event_data = contract.events.FusionInstanceCreated().process_log(log)
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
            cache_fusion_events(chain, factory_address, new_events, latest_block)
        
        # Combine cached events with new events
        all_events = _convert_cached_events_to_objects(cached_events, contract) + new_events
        
        logger.info(f"Total events (cached + new): {len(all_events)}")
        return all_events
            
    except Exception as e:
        logger.error(f"Error setting up contract for factory {factory_address}: {str(e)}")
        return []

def _convert_cached_events_to_objects(cached_events, contract):
    """Convert cached event dictionaries back to event-like objects for compatibility."""
    if not cached_events:
        return []
    
    converted_events = []
    for cached_event in cached_events:
        try:
            # Create a mock event object with the necessary attributes
            class MockEvent:
                def __init__(self, args_dict, block_number, transaction_hash):
                    self.args = type('Args', (), args_dict)()
                    self.blockNumber = block_number
                    self.transactionHash = bytes.fromhex(transaction_hash[2:]) if transaction_hash and transaction_hash.startswith('0x') else None
                    
                def get(self, key, default=None):
                    return getattr(self, key, default)
            
            # Convert cached args back to proper format
            args_dict = cached_event.get('args', {})
            block_number = cached_event.get('block_number')
            transaction_hash = cached_event.get('transaction_hash')
            
            mock_event = MockEvent(args_dict, block_number, transaction_hash)
            converted_events.append(mock_event)
            
        except Exception as e:
            logger = logging.getLogger(__name__)
            logger.error(f"Error converting cached event: {str(e)}")
            continue
    
    return converted_events

# find_addresses_files and get_chain_from_path are now imported from shared_utils

def find_fusion_factory_proxies(start_path):
    """Find all IporFusionFactoryProxy addresses and map them to chain names."""
    logger.info("Finding IporFusionFactoryProxy addresses...")
    factory_proxies = {}
    addresses_files = find_addresses_files(start_path)
    
    for file_path in addresses_files:
        try:
            with open(file_path, 'r') as f:
                data = json.load(f)
                
            # Skip if no IporFusionFactoryProxy in the file
            if 'IporFusionFactoryProxy' not in data:
                continue
                
            chain = get_chain_from_path(file_path)
            if chain and data['IporFusionFactoryProxy'] != ZERO_ADDRESS:
                factory_proxies[chain] = data['IporFusionFactoryProxy']
                logger.info(f"Found IporFusionFactoryProxy for {chain}: {data['IporFusionFactoryProxy']}")
                
        except Exception as e:
            logger.error(f"Error processing {file_path}: {str(e)}")
            
    return factory_proxies

def process_factory_events(factory_proxies):
    """Process events for all factory proxies and collect vault addresses."""
    all_vaults = {}
    
    for chain, factory_address in factory_proxies.items():
        # Skip specified chains
        if chain in SKIP_CHAINS:
            logger.info(f"Skipping chain: {chain} (in skip list)")
            continue
        
        rpc_url = get_rpc_urls()[chain]
            
        logger.info(f"\nProcessing events for chain: {chain}")
        logger.info(f"Using RPC URL: {rpc_url}")
        
        # Initialize Web3 for the chain
        web3 = Web3(Web3.HTTPProvider(rpc_url))
        if not web3.is_connected():
            logger.error(f"Failed to connect to {chain} RPC")
            continue
        
        logger.info(f"Successfully connected to {chain} RPC")
            
        # Get events for this factory
        events = get_fusion_events(web3, factory_address, chain)
        
        if not events:
            logger.warning(f"No events found for {chain} factory at {factory_address}")
            continue
            
        # Extract vault addresses from events
        chain_vaults = []
        for event in events:
            vault_address = event.args.plasmaVault
            vault_info = {
                "address": vault_address,
                "underlying_token": event.args.underlyingToken,
                "underlying_symbol": event.args.underlyingTokenSymbol,
                "asset_name": event.args.assetName,
                "asset_symbol": event.args.assetSymbol
            }
            chain_vaults.append(vault_info)
            
        all_vaults[chain] = chain_vaults
        logger.info(f"Found {len(chain_vaults)} vaults for {chain}")
    
    return all_vaults

def update_addresses_files(all_vaults):
    """Update main addresses.json file with found vaults for all chains."""
    logger.info("Updating main addresses.json file with found vaults...")
    
    try:
        # Read existing addresses file
        with open(get_main_addresses_file(), 'r') as f:
            addresses = json.load(f)
            
        # Add or update vaults for each chain
        for chain, vaults in all_vaults.items():
            # Skip if chain not in addresses file
            if chain not in addresses:
                logger.warning(f"Chain {chain} not found in addresses.json")
                continue
                
            # Initialize vaults array if it doesn't exist
            if 'vaults' not in addresses[chain]:
                addresses[chain]['vaults'] = []
                
            # Process each vault
            for vault in vaults:
                # Try to find existing vault by PlasmaVault address
                existing_vault = next(
                    (v for v in addresses[chain]['vaults'] if v.get('PlasmaVault') == vault['address']),
                    None
                )
                
                vault_data = {
                    'name': vault['asset_name'],
                    'token': vault['asset_symbol'],
                    'asset': vault['underlying_token'],
                    'PlasmaVault': vault['address']
                }
                
                if existing_vault:
                    # Update existing vault
                    existing_vault.update(vault_data)
                    logger.info(f"Updated vault {vault['asset_name']} in {chain}")
                else:
                    # Add new vault
                    addresses[chain]['vaults'].append(vault_data)
                    logger.info(f"Added new vault {vault['asset_name']} to {chain}")
                
        # Write updated addresses back to file
        with open(get_main_addresses_file(), 'w') as f:
            json.dump(addresses, f, indent=2)
            
        logger.info(f"Successfully updated main addresses.json file")
        
    except Exception as e:
        logger.error(f"Error updating main addresses file: {str(e)}")

def main():
    # Create output directory if it doesn't exist
    ensure_output_dir()
    
    # Find all fusion factory proxies
    factory_proxies = find_fusion_factory_proxies(MAINNET_PATH)
    logger.info(f"Found factory proxies: {json.dumps(factory_proxies, indent=2)}")
    
    # Process events and collect vault addresses
    all_vaults = process_factory_events(factory_proxies)
    
    # Update addresses.json file with found vaults
    update_addresses_files(all_vaults)
    
    # Save results to file
    output_path = os.path.join(OUTPUT_DIR, 'fusion_vaults.json')
    with open(output_path, 'w') as f:
        json.dump(all_vaults, f, indent=2)
    
    logger.info(f"Results saved to {output_path}")
    
    # Print summary
    print("\nFusion Vaults Summary:")
    for chain, vaults in all_vaults.items():
        print(f"\n{chain.upper()}:")
        for vault in vaults:
            print(f"  - {vault['asset_name']} ({vault['asset_symbol']}):")
            print(f"    Address: {vault['address']}")
            print(f"    Underlying: {vault['underlying_symbol']} ({vault['underlying_token']})")

if __name__ == "__main__":
    main()
