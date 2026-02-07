"""
Shared utilities for IPOR ABI scripts.
Contains common constants, functions, and configurations used across multiple scripts.
"""

import json
import os
import datetime
import logging
import yaml
from dotenv import load_dotenv
from web3 import Web3
from web3.exceptions import ContractLogicError

# Load environment variables - will be called by individual scripts
# load_dotenv() is called in setup_env_and_logging() function

# Common constants
ADDRESSES_FILENAME = 'addresses.json'
MAINNET_PATH = '../../mainnet'
TESTNET_PATH = '../../testnet'
OUTPUT_DIR = 'output'
ZERO_ADDRESS = "0x0000000000000000000000000000000000000000"
CONTRACT_CREATION_CACHE_FILE = 'contract_creation_blocks_cache.yaml'
FUSION_EVENTS_CACHE_FILE = 'fusion_events_cache.yaml'
PRICE_FEED_EVENTS_CACHE_FILE = 'price_feed_events_cache.yaml'

# RPC URLs configuration - will be initialized after environment loading
def get_rpc_urls():
    """Get RPC URLs from environment variables."""
    return {
        "ethereum": os.getenv("ETHEREUM_RPC_URL"),
        "arbitrum": os.getenv("ARBITRUM_RPC_URL"),
        "base": os.getenv("BASE_RPC_URL"),
        "unichain": os.getenv("UNICHAIN_RPC_URL"),
        "tac": os.getenv("TAC_RPC_URL"),
        "ink": os.getenv("INK_RPC_URL"),
        "plasma": os.getenv("PLASMA_RPC_URL"),
        "avalanche": os.getenv("AVALANCHE_RPC_URL"),
        "katana": os.getenv("KATANA_RPC_URL")
    }

def validate_rpc_urls():
    """Validate that all required RPC URLs are set."""
    rpc_urls = get_rpc_urls()
    for chain, url in rpc_urls.items():
        if not url:
            raise ValueError(f"Missing RPC URL for {chain}. Please add {chain.upper()}_RPC_URL to your .env file.")
    return rpc_urls

# Chain start blocks for deployment date detection
CHAIN_START_BLOCKS = {
    "ethereum": 20733870,
    "arbitrum": 218743859,
    "base": 21704649,
    "unichain": 17867366,
    "tac": 239,
    "ink": 19102371,
    "plasma": 1901043,
    "avalanche": 69330233,
    "katana": 23646820
}

# Chunk sizes for event fetching per chain
CHUNK_SIZES = {
    "ethereum": 500000,
    "arbitrum": 10000000,
    "base": 10000000,
    "unichain": 10000,
    "tac": 10000,
    "ink": 10000,
    "plasma": 10000,
    "avalanche": 10000,
    "katana": 10000,
    "default": 10000    # Default chunk size for any unlisted chains
}

# Explorer URLs
EXPLORERS = {
    "ethereum": "https://etherscan.io/address/",
    "arbitrum": "https://arbiscan.io/address/",
    "base": "https://basescan.org/address/",
    "unichain": "https://uniscan.xyz/address/",
    "tac": "https://explorer.tac.build/address/",
    "ink": "https://explorer.inkonchain.com/address/",
    "plasma": "https://plasmascan.to/address/",
    "avalanche": "https://snowscan.xyz/address/",
    "katana": "https://katanascan.com/address/"
}

# Explorer types for URL generation
EXPLORER_TYPES = {
    "ethereum": "etherscan",
    "arbitrum": "etherscan",
    "base": "etherscan",
    "unichain": "etherscan",
    "tac": "blockscout",
    "ink": "blockscout",
    "plasma": "routescan",
    "avalanche": "etherscan",
    "katana": "etherscan"
}

# Chain IDs
CHAIN_IDS = {
    "ethereum": "1",
    "arbitrum": "42161",
    "base": "8453",
    "unichain": "130",
    "tac": "239",
    "ink": "57073",
    "plasma": "9745",
    "avalanche": "43114",
    "katana": "747474"
}

# Chain display names
NAMES = {
    "ethereum": "Ethereum",
    "arbitrum": "Arbitrum",
    "base": "Base",
    "unichain": "Unichain",
    "tac": "TAC",
    "ink": "Ink",
    "plasma": "Plasma",
    "avalanche": "Avalanche",
    "katana": "Katana"
}

# Common ABIs
TOKEN_ABI = [
    {
        "inputs": [],
        "name": "symbol",
        "outputs": [{"internalType": "string", "name": "", "type": "string"}],
        "stateMutability": "view",
        "type": "function"
    }
]

# Setup environment and logging
def setup_env_and_logging():
    """Setup environment variables and logging configuration."""
    # Setup logging first so we can log the .env loading process
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    logger = logging.getLogger(__name__)
    
    # Load .env files in order:
    # 1. From parent directory of shared_utils.py (scripts directory)
    # 2. From the same directory where the script is running
    
    # Get the directory where shared_utils.py is located
    shared_utils_dir = os.path.dirname(os.path.abspath(__file__))
    parent_env_file = os.path.join(shared_utils_dir, '.env')
    
    # Get the current working directory (where the script is run from)
    script_dir = os.getcwd()
    script_env_file = os.path.join(script_dir, '.env')
    
    # Load from parent directory first
    if os.path.exists(parent_env_file):
        load_dotenv(parent_env_file)
        logger.info(f"Loaded .env file from parent directory: {parent_env_file}")
    else:
        logger.info(f"No .env file found in parent directory: {parent_env_file}")
    
    # Load from script directory (this will override parent directory values if they exist)
    if os.path.exists(script_env_file):
        load_dotenv(script_env_file, override=True)
        logger.info(f"Loaded .env file from script directory: {script_env_file}")
    else:
        logger.info(f"No .env file found in script directory: {script_env_file}")
    
    # Validate RPC URLs after loading environment variables
    try:
        validate_rpc_urls()
        logger.info("All required RPC URLs are configured")
    except ValueError as e:
        logger.error(str(e))
        raise
    
    return logger

def setup_logging():
    """Setup logging configuration only (for backward compatibility)."""
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    return logging.getLogger(__name__)

# Common utility functions
def find_addresses_files(start_path):
    """Find all addresses.json files in the given path."""
    addresses_files = []
    for root, dirs, files in os.walk(start_path):
        if ADDRESSES_FILENAME in files:
            addresses_files.append(os.path.join(root, ADDRESSES_FILENAME))
    return addresses_files

def get_chain_from_path(path):
    """Extract chain name from path based on known chains."""
    chains = {
        "ethereum": "ethereum",
        "arbitrum": "arbitrum",
        "tac": "tac",
        "ink": "ink",
        "unichain": "unichain",
        "base": "base",
        "plasma": "plasma",
        "avalanche": "avalanche",
        "katana": "katana"
    }
    
    for chain in chains:
        if chain in path:
            return chains[chain]
    return None

def create_explorer_url(chain, address):
    """Create explorer URL for a given chain and address."""
    explorer_type = EXPLORER_TYPES.get(chain.lower(), "")
    explorer_base_url = EXPLORERS.get(chain.lower(), "")
    if explorer_type == "routescan":
        chain_id = CHAIN_IDS.get(chain.lower(), "")
        return f"{explorer_base_url}{address}/contract/{chain_id}/code"
    else:
        return f"{explorer_base_url}{address}#code"

def _load_contract_creation_cache():
    """Load contract creation block cache from YAML file."""
    logger = logging.getLogger(__name__)
    cache_file = os.path.join(OUTPUT_DIR, CONTRACT_CREATION_CACHE_FILE)
    
    try:
        if os.path.exists(cache_file):
            with open(cache_file, 'r') as f:
                cache = yaml.safe_load(f) or {}
            logger.info(f"Loaded contract creation cache with {len(cache)} chains from {cache_file}")
            return cache
        else:
            logger.info(f"No cache file found at {cache_file}, starting with empty cache")
            return {}
    except Exception as e:
        logger.error(f"Error loading contract creation cache: {str(e)}")
        return {}

def _save_contract_creation_cache(cache):
    """Save contract creation block cache to YAML file."""
    logger = logging.getLogger(__name__)
    cache_file = os.path.join(OUTPUT_DIR, CONTRACT_CREATION_CACHE_FILE)
    
    try:
        # Ensure output directory exists
        ensure_output_dir()
        
        with open(cache_file, 'w') as f:
            yaml.dump(cache, f, default_flow_style=False, sort_keys=True)
        
        total_addresses = sum(len(addresses) for addresses in cache.values())
        logger.info(f"Saved contract creation cache with {total_addresses} addresses across {len(cache)} chains to {cache_file}")
        
    except Exception as e:
        logger.error(f"Error saving contract creation cache: {str(e)}")

def _get_cached_creation_block(cache, chain, address):
    """Get cached creation block for a contract."""
    return cache.get(chain, {}).get(address.lower())

def _cache_creation_block(cache, chain, address, block_number):
    """Cache creation block for a contract."""
    if chain not in cache:
        cache[chain] = {}
    cache[chain][address.lower()] = block_number

def _find_contract_creation_block(web3, address, chain):
    """Helper function to find the block number where the contract was created using binary search.
    Uses caching to avoid redundant blockchain queries."""
    logger = logging.getLogger(__name__)
    logger.info(f"Finding creation block for contract: {address} on {chain}")
    
    # Load cache
    cache = _load_contract_creation_cache()
    
    # Check if we already have this address cached
    if chain in cache and address.lower() in cache[chain]:
        cached_block = cache[chain][address.lower()]
        if cached_block is None:
            logger.info(f"Found cached result for {address} on {chain}: contract doesn't exist")
        else:
            logger.info(f"Found cached creation block for {address} on {chain}: {cached_block}")
        return cached_block
    
    checksum_address = Web3.to_checksum_address(address)
    logger.info(f"Calling web3: get_code for address {address}")
    
    # Check if contract exists at all
    code = web3.eth.get_code(checksum_address)
    if code == b'' or code == '0x':
        logger.info(f"No code found at {address}, contract doesn't exist")
        # Cache the fact that this contract doesn't exist (using None)
        _cache_creation_block(cache, chain, address, None)
        _save_contract_creation_cache(cache)
        return None
    
    left = CHAIN_START_BLOCKS.get(chain, 0)
    logger.info(f"Calling web3: get_block_number")
    right = web3.eth.block_number
    
    # Binary search to find the creation block
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
            logger.warning(f"Error checking block {mid}: {str(e)}")
            right = mid - 1
    
    creation_block = left
    logger.info(f"Found contract creation block: {creation_block}")
    
    # Cache the result
    _cache_creation_block(cache, chain, address, creation_block)
    _save_contract_creation_cache(cache)
    
    return creation_block

def get_contract_creation_block(web3, address, chain):
    """Get the block number where the contract was created."""
    logger = logging.getLogger(__name__)
    try:
        creation_block = _find_contract_creation_block(web3, address, chain)
        
        if creation_block is None:
            # Contract doesn't exist, return current block as fallback
            current_block = web3.eth.block_number
            logger.info(f"No code found at {address}, using current block: {current_block}")
            return current_block
        
        return creation_block

    except Exception as e:
        logger.error(f"Error finding contract creation block: {str(e)}")
        # If we can't find the creation block, start from a recent point
        recent_block = max(0, web3.eth.block_number - 100000)
        logger.warning(f"Using fallback block number: {recent_block}")
        return recent_block

def get_contract_deployment_date(web3, address, chain):
    """Get the deployment date of a contract."""
    logger = logging.getLogger(__name__)
    try:
        creation_block = _find_contract_creation_block(web3, address, chain)
        
        if creation_block is None:
            # Contract doesn't exist, return current date as fallback
            current_date = datetime.datetime.now().strftime('%Y-%m-%d')
            logger.info(f"No code found at {address}, using current date: {current_date}")
            return current_date
        
        # Get the block timestamp and convert to date
        logger.info(f"Calling web3: get_block for block {creation_block}")
        block = web3.eth.get_block(creation_block)
        timestamp = block['timestamp']
        
        date = datetime.datetime.fromtimestamp(timestamp).strftime('%Y-%m-%d')
        
        logger.info(f"Found deployment date for {address}: {date} (block {creation_block}) on {web3.provider.endpoint_uri}")
        
        return date
        
    except Exception as e:
        logger.error(f"Error getting deployment date for {address}: {str(e)}")
        return datetime.datetime.now().strftime('%Y-%m-%d')

def create_web3_connections():
    """Create Web3 connections for all chains."""
    rpc_urls = get_rpc_urls()
    return {chain: Web3(Web3.HTTPProvider(url)) for chain, url in rpc_urls.items()}

def ensure_output_dir(output_dir=OUTPUT_DIR):
    """Ensure output directory exists."""
    os.makedirs(output_dir, exist_ok=True)

def get_main_addresses_file():
    """Get the path to the main addresses.json file."""
    return f'{MAINNET_PATH}/{ADDRESSES_FILENAME}'

def get_token_symbol(web3, address):
    """Get token symbol from contract address."""
    logger = logging.getLogger(__name__)
    logger.info(f"Executing web3 call: get_token_symbol for address {address}")
    try:
        contract = web3.eth.contract(address=Web3.to_checksum_address(address), abi=TOKEN_ABI)
        return contract.functions.symbol().call()
    except (ContractLogicError, Exception) as e:
        logger.error(f"Error getting symbol for {address}: {str(e)}")
        return None

def update_readme_section(readme_file, section_name, new_content):
    """Update a specific section in README.md file."""
    logger = logging.getLogger(__name__)
    try:
        try:
            with open(readme_file, 'r') as f:
                readme_content = f.read()
        except FileNotFoundError:
            readme_content = f"# {section_name.replace(' List', '')} Protocol\n\n"

        import re
        sections = re.split(r'(^##\s+[^\n]+\n)', readme_content, flags=re.MULTILINE)
        
        section_found = False
        for i in range(1, len(sections), 2):
            if f"## {section_name}" in sections[i]:
                sections[i+1] = "\n" + new_content.replace(f"## {section_name}\n\n", "")
                section_found = True
                break
        
        if not section_found:
            sections.append(f"\n\n## {section_name}\n")
            sections.append("\n" + new_content.replace(f"## {section_name}\n\n", ""))
        
        new_readme_content = "".join(sections)
        
        with open(readme_file, 'w') as f:
            f.write(new_readme_content.strip() + "\n")
            
        logger.info(f"{section_name} updated in {readme_file}")
        
    except Exception as e:
        logger.error(f"Error updating README section {section_name}: {str(e)}")

def get_current_utc_timestamp():
    """Get current UTC timestamp string."""
    return datetime.datetime.now(datetime.timezone.utc).strftime('%Y-%m-%d %H:%M:%S')

# Fusion Events Caching Functions
def _load_fusion_events_cache():
    """Load fusion events cache from YAML file.
    
    Cache structure:
    {
        'chain_name': {
            'factory_address': {
                'last_read_block': 12345678,
                'events': [
                    {
                        'block_number': 12345679,
                        'transaction_hash': '0x...',
                        'args': {
                            'index': 0,
                            'version': 1,
                            'assetName': 'Asset Name',
                            'assetSymbol': 'SYMBOL',
                            'assetDecimals': 18,
                            'underlyingToken': '0x...',
                            'underlyingTokenSymbol': 'USDC',
                            'underlyingTokenDecimals': 6,
                            'initialOwner': '0x...',
                            'plasmaVault': '0x...',
                            'plasmaVaultBase': '0x...',
                            'feeManager': '0x...'
                        }
                    }
                ]
            }
        }
    }
    """
    logger = logging.getLogger(__name__)
    cache_file = os.path.join(OUTPUT_DIR, FUSION_EVENTS_CACHE_FILE)
    
    try:
        if os.path.exists(cache_file):
            with open(cache_file, 'r') as f:
                cache = yaml.safe_load(f) or {}
            logger.info(f"Loaded fusion events cache with {len(cache)} chains from {cache_file}")
            return cache
        else:
            logger.info(f"No fusion events cache file found at {cache_file}, starting with empty cache")
            return {}
    except Exception as e:
        logger.error(f"Error loading fusion events cache: {str(e)}")
        return {}

def _save_fusion_events_cache(cache):
    """Save fusion events cache to YAML file."""
    logger = logging.getLogger(__name__)
    cache_file = os.path.join(OUTPUT_DIR, FUSION_EVENTS_CACHE_FILE)
    
    try:
        # Ensure output directory exists
        ensure_output_dir()
        
        with open(cache_file, 'w') as f:
            yaml.dump(cache, f, default_flow_style=False, sort_keys=True)
        
        total_factories = sum(len(factories) for factories in cache.values())
        total_events = sum(
            len(factory_data.get('events', []))
            for chain_data in cache.values()
            for factory_data in chain_data.values()
        )
        logger.info(f"Saved fusion events cache with {total_events} events across {total_factories} factories in {len(cache)} chains to {cache_file}")
        
    except Exception as e:
        logger.error(f"Error saving fusion events cache: {str(e)}")

def get_cached_fusion_events(chain, factory_address):
    """Get cached fusion events and last read block for a factory.
    
    Returns:
        tuple: (events_list, last_read_block) or ([], None) if no cache exists
    """
    logger = logging.getLogger(__name__)
    cache = _load_fusion_events_cache()
    
    factory_address_lower = factory_address.lower()
    
    if chain in cache and factory_address_lower in cache[chain]:
        factory_data = cache[chain][factory_address_lower]
        events = factory_data.get('events', [])
        last_read_block = factory_data.get('last_read_block')
        
        logger.info(f"Found cached data for {factory_address} on {chain}: {len(events)} events, last read block: {last_read_block}")
        return events, last_read_block
    
    logger.info(f"No cached data found for {factory_address} on {chain}")
    return [], None

def cache_fusion_events(chain, factory_address, events, last_read_block):
    """Cache fusion events for a factory.
    
    Args:
        chain: Chain name
        factory_address: Factory contract address
        events: List of event data dictionaries
        last_read_block: Last block number that was read
    """
    logger = logging.getLogger(__name__)
    cache = _load_fusion_events_cache()
    
    factory_address_lower = factory_address.lower()
    
    # Initialize chain if it doesn't exist
    if chain not in cache:
        cache[chain] = {}
    
    # Initialize factory if it doesn't exist
    if factory_address_lower not in cache[chain]:
        cache[chain][factory_address_lower] = {
            'events': [],
            'last_read_block': None
        }
    
    # Convert events to serializable format
    serializable_events = []
    for event in events:
        event_data = {
            'block_number': event.get('blockNumber'),
            'transaction_hash': event.get('transactionHash').hex() if event.get('transactionHash') else None,
            'args': {}
        }
        
        # Extract event arguments
        if hasattr(event, 'args'):
            for key, value in event.args.items():
                # Convert bytes to hex string, keep other types as is
                if isinstance(value, bytes):
                    event_data['args'][key] = value.hex()
                else:
                    event_data['args'][key] = value
        
        serializable_events.append(event_data)
    
    # Update cache with new events (append to existing ones)
    existing_events = cache[chain][factory_address_lower].get('events', [])
    
    # Filter out duplicate events based on transaction hash and block number
    existing_tx_hashes = {(e.get('transaction_hash'), e.get('block_number')) for e in existing_events}
    new_events = [e for e in serializable_events if (e.get('transaction_hash'), e.get('block_number')) not in existing_tx_hashes]
    
    cache[chain][factory_address_lower]['events'] = existing_events + new_events
    cache[chain][factory_address_lower]['last_read_block'] = last_read_block
    
    logger.info(f"Cached {len(new_events)} new events for {factory_address} on {chain}, total events: {len(cache[chain][factory_address_lower]['events'])}, last read block: {last_read_block}")
    
    # Save updated cache
    _save_fusion_events_cache(cache)

# Price Feed Events Caching Functions
def _load_price_feed_events_cache():
    """Load price feed events cache from YAML file.
    
    Cache structure:
    {
        'chain_name': {
            'price_oracle_address': {
                'last_read_block': 12345678,
                'events': [
                    {
                        'block_number': 12345679,
                        'transaction_hash': '0x...',
                        'args': {
                            'asset': '0x...',
                            'source': '0x...'
                        }
                    }
                ]
            }
        }
    }
    """
    logger = logging.getLogger(__name__)
    cache_file = os.path.join(OUTPUT_DIR, PRICE_FEED_EVENTS_CACHE_FILE)
    
    try:
        if os.path.exists(cache_file):
            with open(cache_file, 'r') as f:
                cache = yaml.safe_load(f) or {}
            logger.info(f"Loaded price feed events cache with {len(cache)} chains from {cache_file}")
            return cache
        else:
            logger.info(f"No price feed events cache file found at {cache_file}, starting with empty cache")
            return {}
    except Exception as e:
        logger.error(f"Error loading price feed events cache: {str(e)}")
        return {}

def _save_price_feed_events_cache(cache):
    """Save price feed events cache to YAML file."""
    logger = logging.getLogger(__name__)
    cache_file = os.path.join(OUTPUT_DIR, PRICE_FEED_EVENTS_CACHE_FILE)
    
    try:
        # Ensure output directory exists
        ensure_output_dir()
        
        with open(cache_file, 'w') as f:
            yaml.dump(cache, f, default_flow_style=False, sort_keys=True)
        
        total_oracles = sum(len(oracles) for oracles in cache.values())
        total_events = sum(
            len(oracle_data.get('events', []))
            for chain_data in cache.values()
            for oracle_data in chain_data.values()
        )
        logger.info(f"Saved price feed events cache with {total_events} events across {total_oracles} price oracles in {len(cache)} chains to {cache_file}")
        
    except Exception as e:
        logger.error(f"Error saving price feed events cache: {str(e)}")

def get_cached_price_feed_events(chain, oracle_address):
    """Get cached price feed events and last read block for a price oracle.
    
    Returns:
        tuple: (events_list, last_read_block) or ([], None) if no cache exists
    """
    logger = logging.getLogger(__name__)
    cache = _load_price_feed_events_cache()
    
    oracle_address_lower = oracle_address.lower()
    
    if chain in cache and oracle_address_lower in cache[chain]:
        oracle_data = cache[chain][oracle_address_lower]
        events = oracle_data.get('events', [])
        last_read_block = oracle_data.get('last_read_block')
        
        logger.info(f"Found cached data for {oracle_address} on {chain}: {len(events)} events, last read block: {last_read_block}")
        return events, last_read_block
    
    logger.info(f"No cached data found for {oracle_address} on {chain}")
    return [], None

def cache_price_feed_events(chain, oracle_address, events, last_read_block):
    """Cache price feed events for a price oracle.
    
    Args:
        chain: Chain name
        oracle_address: Price oracle contract address
        events: List of event data dictionaries
        last_read_block: Last block number that was read
    """
    logger = logging.getLogger(__name__)
    cache = _load_price_feed_events_cache()
    
    oracle_address_lower = oracle_address.lower()
    
    # Initialize chain if it doesn't exist
    if chain not in cache:
        cache[chain] = {}
    
    # Initialize oracle if it doesn't exist
    if oracle_address_lower not in cache[chain]:
        cache[chain][oracle_address_lower] = {
            'events': [],
            'last_read_block': None
        }
    
    # Convert events to serializable format
    serializable_events = []
    for event in events:
        event_data = {
            'block_number': event.get('blockNumber'),
            'transaction_hash': event.get('transactionHash').hex() if event.get('transactionHash') else None,
            'args': {}
        }
        
        # Extract event arguments
        if hasattr(event, 'args'):
            for key, value in event.args.items():
                # Convert bytes to hex string, keep other types as is
                if isinstance(value, bytes):
                    event_data['args'][key] = value.hex()
                else:
                    event_data['args'][key] = value
        
        serializable_events.append(event_data)
    
    # Update cache with new events (append to existing ones)
    existing_events = cache[chain][oracle_address_lower].get('events', [])
    
    # Filter out duplicate events based on transaction hash and block number
    existing_tx_hashes = {(e.get('transaction_hash'), e.get('block_number')) for e in existing_events}
    new_events = [e for e in serializable_events if (e.get('transaction_hash'), e.get('block_number')) not in existing_tx_hashes]
    
    cache[chain][oracle_address_lower]['events'] = existing_events + new_events
    cache[chain][oracle_address_lower]['last_read_block'] = last_read_block
    
    logger.info(f"Cached {len(new_events)} new events for {oracle_address} on {chain}, total events: {len(cache[chain][oracle_address_lower]['events'])}, last read block: {last_read_block}")
    
    # Save updated cache
    _save_price_feed_events_cache(cache)
