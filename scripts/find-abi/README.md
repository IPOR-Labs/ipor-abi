# [find-abi.sh](find-abi.sh) script

## Script Overview

This Bash script is designed to fetch smart contract ABI (Application Binary Interface) files for a specified `chain-id` and `address` from a GitHub repository. It supports two formats of ABI files: normal  `.abi.json` and pretty `.abi.sol`, which are stored under `normal` and `pretty` directories, respectively. The script also includes functionality to handle GitHub API rate limits through the use of an optional `GITHUB_TOKEN` environment variable.

## Prerequisites

- A working installation of `curl`.
- A GitHub account (if using an API token to avoid rate limiting).
- Optionally, a `.env` file with a valid GitHub API token if needed.

## Usage

```bash
./find-abi.sh <chain-id> <address>
```

### Arguments

- `<chain-id>`: The chain ID to search for ABI files in the GitHub repository.
- `<address>`: The address to look for ABI files in the specified chain ID.

### Options

- `--help`, `-h`: Show help message and usage instructions.

### Example

```bash
./find-abi.sh 42161 0x0ce06c57173b7E4079B2AFB132cB9Ce846dDAC9b
```

This will attempt to fetch ABI files for chain ID `42161` and the specified address: `0x0ce06c57173b7E4079B2AFB132cB9Ce846dDAC9b`.

### Help

To display the help message, run:

```bash
./find-abi.sh --help
```

## Environment Variables

An example `.env` file is in [.env.example](.env.example)

- `GITHUB_TOKEN`: A GitHub API token to authenticate API requests and avoid rate limits. The token should be stored in a `.env` file in the following format:

```bash
GITHUB_TOKEN=<your-token-here>
```

## Script Behavior

1. **Check for Arguments**: The script requires exactly two arguments: `<chain-id>` and `<address>`. If either is missing, it will display an error message.

2. **GitHub Repository Details**:
  - The ABI files are fetched from the GitHub repository `IPOR-Labs/ipor-abi`.
  - The script searches the `main` branch.
  - Two subdirectories, `normal` and `pretty`, are searched for ABI files.

3. **Check for Chain ID**: The script verifies if the provided `chain-id` exists in the repository by sending an API request to GitHub.

4. **Download ABI Files**:
  - If the `chain-id` exists, the script searches for the ABI files (in `normal` for `.abi.json` files and in `pretty` for `.abi.sol` files).
  - Files are downloaded to a local directory name`abi` into `chain-id` subdirectory.

## Error Handling

- If the provided `chain-id` does not exist in the repository, the script will display an error message.
- If no files are found for the given `address`, it will display a warning message.

## API Rate Limit Handling

If you encounter GitHub API rate limit issues, you can avoid them by setting the `GITHUB_TOKEN` in the `.env` file. The script will automatically use this token to authenticate requests.

## License

This script is licensed under the GNU General Public License, Version 2. You may redistribute and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 2 of the License, or (at your option) any later version.

For more details, see the [LICENSE](..%2F..%2FLICENSE) file.
