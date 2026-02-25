import json
import os
import sys
sys.path.append('..')
from shared_utils import *

OUTPUT_FILE = f'{OUTPUT_DIR}/fuses.json'

# List of field names to ignore when extracting fuse fields
IGNORED_FIELD_NAMES = [
  "IporFusionFuseWhitelistImpl",
  "IporFusionFuseWhitelistProxy"
]

logger = setup_env_and_logging()


# create_explorer_url, get_contract_deployment_date, and find_addresses_files are now imported from shared_utils


def extract_fuse_fields(file_path):
    try:
        with open(file_path, 'r') as f:
            data = json.load(f)

        extracted_data = {}
        for field in data:
            if ("fuse" in field.lower() and 
                data[field] != ZERO_ADDRESS and 
                field.lower() not in [name.lower() for name in IGNORED_FIELD_NAMES]):
                extracted_data[field] = data[field]

        return extracted_data if extracted_data else None

    except Exception as e:
        logger.error(f"Error processing {file_path}: {str(e)}")
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
                "base": {"fuses": []},
                "unichain": {"fuses": []},
                "tac": {"fuses": []},
                "ink": {"fuses": []},
                "plasma": {"fuses": []},
                "avalanche": {"fuses": []},
                "katana": {"fuses": []}
            }

        blockchain_fuses = {
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

        existing_fuses = {}
        for chain in addresses:
            existing_fuses[chain] = {}
            if "fuses" in addresses[chain]:
                for fuse in addresses[chain]["fuses"]:
                    existing_fuses[chain][fuse["name"]] = fuse["versions"]
                    blockchain_fuses[chain][fuse["name"]] = fuse["versions"]

        for file_path, fuses in fuses_data.items():
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
            
            for field_name, address in fuses.items():
                address_already_known = False
                if field_name in existing_fuses.get(chain, {}):
                    for date, existing_address in existing_fuses[chain][field_name].items():
                        if existing_address.lower() == address.lower():
                            address_already_known = True
                            if field_name not in blockchain_fuses[chain]:
                                blockchain_fuses[chain][field_name] = {}
                            blockchain_fuses[chain][field_name][date] = address
                            logger.info(f"Using existing date for {field_name} at {address} on {chain}")
                            break
                
                if not address_already_known:
                    deployment_date = get_contract_deployment_date(web3, address, chain)
                    
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
            readme_content = "# Fuse Protocol\n\n"

        fuses_md = "## Fuses List\n\n"
        fuses_md += f"*Last updated: {get_current_utc_timestamp()} UTC*\n\n"
        
        for chain, chain_data in addresses_data.items():
            if "fuses" in chain_data and chain_data["fuses"]:
                fuses_md += f"### {NAMES[chain]} Fuses\n\n"
                
                explorer_base_url = EXPLORERS.get(chain.lower(), "")
                sorted_fuses = sorted(chain_data["fuses"], key=lambda x: x["name"])
                
                fuses_md += f"| Fuse Name | Address / View in Explorer |\n"
                fuses_md += "|-----------|---------------------------|\n"
                
                for fuse in sorted_fuses:
                    fuse_name = fuse["name"]
                    
                    sorted_versions = sorted(fuse["versions"].items(), key=lambda x: x[0], reverse=True)
                    if sorted_versions:
                        newest_date, newest_address = sorted_versions[0]
                        if explorer_base_url:
                            address_display = f"`{newest_address}` [View]({create_explorer_url(chain, newest_address)})"
                        else:
                            address_display = f"`{newest_address}`"
                        fuses_md += f"| `{fuse_name}` | {address_display} |\n"
                
                fuses_md += "\n"
                
                has_older_versions = False
                for fuse in sorted_fuses:
                    sorted_versions = sorted(fuse["versions"].items(), key=lambda x: x[0], reverse=True)
                    if len(sorted_versions) > 1:
                        has_older_versions = True
                        break
                
                if has_older_versions:
                    fuses_md += f"#### {NAMES[chain]} Older Fuses Versions\n\n"
                    fuses_md += f"| Fuse Name | Address / View in Explorer |\n"
                    fuses_md += "|-----------|---------------------------|\n"
                    
                    for fuse in sorted_fuses:
                        fuse_name = fuse["name"]
                        
                        sorted_versions = sorted(fuse["versions"].items(), key=lambda x: x[0], reverse=True)
                        if len(sorted_versions) > 1:
                            for date, address in sorted_versions[1:]:
                                if explorer_base_url:
                                    address_display = f"`{address}` [View]({create_explorer_url(chain, address)})"
                                else:
                                    address_display = f"`{address}`"
                                fuses_md += f"| `{fuse_name}` | {address_display} |\n"
                    
                    fuses_md += "\n"

        import re
        sections = re.split(r'(^##\s+[^\n]+\n)', readme_content, flags=re.MULTILINE)
        
        fuses_list_found = False
        for i in range(1, len(sections), 2):
            if "## Fuses List" in sections[i]:
                sections[i+1] = "\n" + fuses_md.replace("## Fuses List\n\n", "")
                fuses_list_found = True
                break
        
        if not fuses_list_found:
            sections.append("\n\n## Fuses List\n")
            sections.append("\n" + fuses_md.replace("## Fuses List\n\n", ""))
        
        new_readme_content = "".join(sections)
        
        with open(readme_file, 'w') as f:
            f.write(new_readme_content.strip() + "\n")
            
        logger.info(f"Fuses list updated in {readme_file}")
        
        output_md_file = f"{OUTPUT_DIR}/fuses_list.md"
        os.makedirs(os.path.dirname(output_md_file), exist_ok=True)
        with open(output_md_file, 'w') as f:
            f.write(fuses_md)
        
    except Exception as e:
        logger.error(f"Error generating markdown list: {str(e)}")


def main():
    result = {}

    addresses_files = find_addresses_files(MAINNET_PATH)
    addresses_files.extend(find_addresses_files(TESTNET_PATH))

    for file_path in addresses_files:
        relative_path = os.path.relpath(file_path, '.')
        fuse_data = extract_fuse_fields(file_path)

        if fuse_data:
            result[relative_path] = fuse_data

    ensure_output_dir()
    
    with open(OUTPUT_FILE, 'w') as f:
        json.dump(result, f, indent=2)

    logger.info(f"Processing complete. Results written to {OUTPUT_FILE}")

    update_addresses_json(OUTPUT_FILE, get_main_addresses_file())
    
    generate_markdown_list()


if __name__ == "__main__":
    main()