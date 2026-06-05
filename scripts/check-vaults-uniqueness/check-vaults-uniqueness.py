#!/usr/bin/env python3
import json
import os
import sys
import logging
from collections import defaultdict

# This check only reads JSON, so it deliberately avoids importing shared_utils
# (which pulls in web3) to stay dependency-free and runnable with plain python3.
ADDRESSES_FILENAME = 'addresses.json'
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
# scripts/check-vaults-uniqueness/ -> ../../mainnet/addresses.json
MAINNET_PATH = os.path.normpath(os.path.join(SCRIPT_DIR, '..', '..', 'mainnet'))

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# ANSI colors for the duplicates banner
RED = '\033[1;31m'
GREEN = '\033[1;32m'
RESET = '\033[0m'


def find_duplicate_vaults(addresses):
    """Return {chain: {address_lower: [vault_entry, ...]}} for addresses seen more than once."""
    duplicates = {}

    for chain, chain_data in addresses.items():
        if not isinstance(chain_data, dict) or 'vaults' not in chain_data:
            continue

        by_address = defaultdict(list)
        for vault in chain_data['vaults']:
            address = vault.get('PlasmaVault')
            if not address:
                continue
            by_address[address.lower()].append(vault)

        chain_duplicates = {addr: vaults for addr, vaults in by_address.items() if len(vaults) > 1}
        if chain_duplicates:
            duplicates[chain] = chain_duplicates

    return duplicates


def print_duplicates_banner(duplicates):
    """Print a big red banner listing the duplicated vault addresses."""
    line = '=' * 70
    print(f"\n{RED}{line}")
    print("  !!!  DUPLICATE VAULT ADDRESSES DETECTED IN addresses.json  !!!")
    print(f"{line}{RESET}\n")

    total = 0
    for chain, chain_duplicates in duplicates.items():
        print(f"{RED}Chain: {chain}{RESET}")
        for address, vaults in chain_duplicates.items():
            total += 1
            names = ', '.join(v.get('name', '?') for v in vaults)
            print(f"{RED}  {address}  (x{len(vaults)})  ->  {names}{RESET}")
        print()

    print(f"{RED}{line}")
    print(f"  Total duplicated vault addresses: {total}")
    print(f"{line}{RESET}\n")


def main():
    addresses_file = os.path.join(MAINNET_PATH, ADDRESSES_FILENAME)

    try:
        with open(addresses_file, 'r') as f:
            addresses = json.load(f)
    except (FileNotFoundError, json.JSONDecodeError) as e:
        logger.error(f"Error reading {addresses_file}: {e}")
        sys.exit(2)

    duplicates = find_duplicate_vaults(addresses)

    if duplicates:
        print_duplicates_banner(duplicates)
        sys.exit(1)

    print(f"{GREEN}All vault addresses in {addresses_file} are unique.{RESET}")
    sys.exit(0)


if __name__ == "__main__":
    main()
