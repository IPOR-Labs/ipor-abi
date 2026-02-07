import json
import os
import sys
sys.path.append('..')
from shared_utils import *

OUTPUT_FILE = f'{OUTPUT_DIR}/prehooks.json'

NOT_PREHOOK_NAMES = [
    "UniversalReaderPreHooksInfo",
]

logger = setup_env_and_logging()

# get_contract_deployment_date and find_addresses_files are now imported from shared_utils


def extract_prehook_fields(file_path):
    try:
        with open(file_path, 'r') as f:
            data = json.load(f)

        extracted_data = {}
        for field in data:
            if "prehook" in field.lower() and data[field] != ZERO_ADDRESS:
                if field in NOT_PREHOOK_NAMES:
                    logger.info(f"Skipping field {field} as it's in NOT_PREHOOK_NAMES list")
                    continue
                extracted_data[field] = data[field]

        return extracted_data if extracted_data else None

    except Exception as e:
        logger.error(f"Error processing {file_path}: {str(e)}")
        return None


def update_addresses_json(prehooks_file, addresses_file):
    try:
        with open(prehooks_file, 'r') as f:
            prehooks_data = json.load(f)

        try:
            with open(addresses_file, 'r') as f:
                addresses = json.load(f)
        except FileNotFoundError:
            addresses = {
                "ethereum": {"prehooks": []},
                "arbitrum": {"prehooks": []},
                "base": {"prehooks": []},
                "unichain": {"prehooks": []},
                "tac": {"prehooks": []},
                "ink": {"prehooks": []},
                "plasma": {"prehooks": []},
                "avalanche": {"prehooks": []},
                "katana": {"prehooks": []}
            }

        blockchain_prehooks = {
            "ethereum": {},
            "arbitrum": {},
            "base": {},
            "unichain": {},
            "tac": {},
            "ink": {},
            "plasma": {},
            "avalanche": {},
            "katana": {}
        }

        web3_connections = create_web3_connections()

        existing_prehooks = {}
        for chain in addresses:
            existing_prehooks[chain] = {}
            if "prehooks" in addresses[chain]:
                for prehook in addresses[chain]["prehooks"]:
                    existing_prehooks[chain][prehook["name"]] = prehook["versions"]
                    blockchain_prehooks[chain][prehook["name"]] = prehook["versions"]

        for file_path, prehooks in prehooks_data.items():
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

            web3 = web3_connections[chain]
            
            for field_name, address in prehooks.items():
                address_already_known = False
                if field_name in existing_prehooks.get(chain, {}):
                    for date, existing_address in existing_prehooks[chain][field_name].items():
                        if existing_address.lower() == address.lower():
                            address_already_known = True
                            if field_name not in blockchain_prehooks[chain]:
                                blockchain_prehooks[chain][field_name] = {}
                            blockchain_prehooks[chain][field_name][date] = address
                            logger.info(f"Using existing date for {field_name} at {address} on {chain}")
                            break
                
                if not address_already_known:
                    deployment_date = get_contract_deployment_date(web3, address, chain)
                    
                    if field_name not in blockchain_prehooks[chain]:
                        blockchain_prehooks[chain][field_name] = {}
                    
                    blockchain_prehooks[chain][field_name][deployment_date] = address

        for chain, prehook_dict in blockchain_prehooks.items():
            if chain not in addresses:
                addresses[chain] = {}

            if "prehooks" not in addresses[chain]:
                addresses[chain]["prehooks"] = []

            prehook_entries = []
            
            for field_name, versions in prehook_dict.items():
                sorted_versions = sorted(versions.items(), key=lambda x: x[0])
                
                versions_dict = {date: address for date, address in sorted_versions}
                
                prehook_entries.append({
                    "name": field_name,
                    "versions": versions_dict
                })
            
            prehook_entries.sort(key=lambda x: x["name"])
            
            addresses[chain]["prehooks"] = prehook_entries

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
            readme_content = "# PreHook Protocol\n\n"

        prehooks_md = "## PreHooks List\n\n"
        prehooks_md += f"*Last updated: {get_current_utc_timestamp()} UTC*\n\n"
        
        for chain, chain_data in addresses_data.items():
            if "prehooks" in chain_data and chain_data["prehooks"]:
                prehooks_md += f"### {NAMES[chain]} PreHooks\n\n"
                
                explorer_base_url = EXPLORERS.get(chain.lower(), "")
                sorted_prehooks = sorted(chain_data["prehooks"], key=lambda x: x["name"])
                
                prehooks_md += f"| PreHook Name | Address / View in Explorer |\n"
                prehooks_md += "|-----------|---------------------------|\n"
                
                for prehook in sorted_prehooks:
                    prehook_name = prehook["name"]
                    
                    sorted_versions = sorted(prehook["versions"].items(), key=lambda x: x[0], reverse=True)
                    if sorted_versions:
                        newest_date, newest_address = sorted_versions[0]
                        if explorer_base_url:
                            address_display = f"`{newest_address}` [View]({explorer_base_url}{newest_address}#code)"
                        else:
                            address_display = f"`{newest_address}`"
                        prehooks_md += f"| `{prehook_name}` | {address_display} |\n"
                
                prehooks_md += "\n"
                
                has_older_versions = False
                for prehook in sorted_prehooks:
                    sorted_versions = sorted(prehook["versions"].items(), key=lambda x: x[0], reverse=True)
                    if len(sorted_versions) > 1:
                        has_older_versions = True
                        break
                
                if has_older_versions:
                    prehooks_md += f"#### {NAMES[chain]} Older PreHooks Versions\n\n"
                    prehooks_md += f"| PreHook Name | Address / View in Explorer |\n"
                    prehooks_md += "|-----------|---------------------------|\n"
                    
                    for prehook in sorted_prehooks:
                        prehook_name = prehook["name"]
                        
                        sorted_versions = sorted(prehook["versions"].items(), key=lambda x: x[0], reverse=True)
                        if len(sorted_versions) > 1:
                            for date, address in sorted_versions[1:]:
                                if explorer_base_url:
                                    address_display = f"`{address}` [View]({explorer_base_url}{address}#code)"
                                else:
                                    address_display = f"`{address}`"
                                prehooks_md += f"| `{prehook_name}` | {address_display} |\n"
                    
                    prehooks_md += "\n"

        import re
        sections = re.split(r'(^##\s+[^\n]+\n)', readme_content, flags=re.MULTILINE)
        
        prehooks_list_found = False
        for i in range(1, len(sections), 2):
            if "## PreHooks List" in sections[i]:
                sections[i+1] = "\n" + prehooks_md.replace("## PreHooks List\n\n", "")
                prehooks_list_found = True
                break
        
        if not prehooks_list_found:
            sections.append("\n\n## PreHooks List\n")
            sections.append("\n" + prehooks_md.replace("## PreHooks List\n\n", ""))
        
        new_readme_content = "".join(sections)
        
        with open(readme_file, 'w') as f:
            f.write(new_readme_content.strip() + "\n")
            
        logger.info(f"PreHooks list updated in {readme_file}")
        
        output_md_file = f"{OUTPUT_DIR}/prehooks_list.md"
        os.makedirs(os.path.dirname(output_md_file), exist_ok=True)
        with open(output_md_file, 'w') as f:
            f.write(prehooks_md)
        
    except Exception as e:
        logger.error(f"Error generating markdown list: {str(e)}")


def main():
    result = {}

    addresses_files = find_addresses_files(MAINNET_PATH)
    addresses_files.extend(find_addresses_files(TESTNET_PATH))

    for file_path in addresses_files:
        relative_path = os.path.relpath(file_path, '.')
        prehook_data = extract_prehook_fields(file_path)

        if prehook_data:
            result[relative_path] = prehook_data

    ensure_output_dir()
    
    with open(OUTPUT_FILE, 'w') as f:
        json.dump(result, f, indent=2)

    logger.info(f"Processing complete. Results written to {OUTPUT_FILE}")

    update_addresses_json(OUTPUT_FILE, get_main_addresses_file())
    
    generate_markdown_list()


if __name__ == "__main__":
    main()