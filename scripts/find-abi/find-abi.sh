#!/bin/bash

GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
RESET="\033[0m"

show_help() {
    echo -e "${GREEN}Usage: $0 <chain-id> <address>${RESET}"
    echo -e "${YELLOW}Options:${RESET}"
    echo -e "  --help, -h                Show this help message and exit"
    echo -e "${YELLOW}Description:${RESET}"
    echo -e "This script fetches ABI files for the specified <chain-id> and <address> from a GitHub repository."
    echo -e "If you experience GitHub API rate limit issues, set the GITHUB_TOKEN in the .env file."
    echo -e "${YELLOW}Arguments:${RESET}"
    echo -e "  <chain-id>                The chain ID to search for in the repository"
    echo -e "  <address>                 The address to look for ABI files in the specified chain ID"
    echo -e "${YELLOW}Environment Variables:${RESET}"
    echo -e "  GITHUB_TOKEN              Optional. GitHub API token to authenticate and avoid rate limit issues"
    exit 0
}

if [ "$#" -ne 2 ]; then
    if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
        show_help
    else
        echo "Usage: $0 <chain-id> <address>"
        echo "If you get rate limit issues from GitHub, please set GITHUB_TOKEN in .env file"
        echo "For more details, use --help or -h"
        exit 1
    fi
fi


CHAIN_ID=$1
ADDRESS=$2

REPO="IPOR-Labs/ipor-abi"
BRANCH="main"

SUBDIRECTORIES=("normal" "pretty")

source .env

check_chain_id_exists() {
    local chain_id_url=$1
    local response
    if [ -n "$GITHUB_TOKEN" ]; then
        response=$(curl -s -w "%{http_code}" -I -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" "$chain_id_url")
    else
        response=$(curl -s -w "%{http_code}" -I -H "Accept: application/vnd.github.v3+json" "$chain_id_url")
    fi
    http_code=$(echo "$response" | tail -n1)

    if [ "$http_code" -eq 403 ]; then
        echo -e "${RED}Error: GitHub API rate limit exceeded. Please wait or set the GITHUB_TOKEN in the .env file to avoid rate limit issues.${RESET}"
        exit 1
    elif [ "$http_code" -ne 200 ]; then
        echo -e "${RED}Error: Chain ID ${CHAIN_ID} does not exist in the repository. HTTP status: $http_code${RESET}"
        exit 1
    fi
}

download_file() {
    local file_url=$1
    local view_url=$2
    local local_file=$3

    if [ -n "$GITHUB_TOKEN" ]; then
        echo -e "${GREEN}Attempting to download RAW${RESET} using GITHUB_TOKEN from: $view_url"
    else
        echo -e "${GREEN}Attempting to download RAW${RESET} without GITHUB_TOKEN from: $view_url"
    fi

    if [ -n "$GITHUB_TOKEN" ]; then
        curl -s -H "Authorization: token $GITHUB_TOKEN" -o "$local_file" "$file_url"
    else
        curl -s -o "$local_file" "$file_url"
    fi

    if [ $? -ne 0 ]; then
        echo -e "${RED}Error downloading file from ${file_url}${RESET}"
        return 1
    else
        echo -e "${GREEN}Successfully downloaded ${local_file}${RESET}"
    fi
}

download_files_from_directory() {
    local folder_url=$1
    local local_folder=$2
    local file_type=$3
    local file_extension=$4

    local response
    if [ -n "$GITHUB_TOKEN" ]; then
        response=$(curl -s -w "%{http_code}" -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" "$folder_url")
    else
        response=$(curl -s -w "%{http_code}" -H "Accept: application/vnd.github.v3+json" "$folder_url")
    fi
    http_code=$(echo "$response" | tail -n1)
    response_body=$(echo "$response" | head -n-1)

    if [ "$http_code" -eq 403 ]; then
        echo -e "${RED}Error: GitHub API rate limit exceeded. Please wait or set the GITHUB_TOKEN in the .env file to avoid rate limit issues.${RESET}"
        return
    elif [ "$http_code" -ne 200 ]; then
        echo -e "${RED}Error: Unable to access${RESET} ${folder_url}. HTTP status: $http_code"
        return
    fi

    local file_found=false
    while read -r item_name; do
        if [[ "$(echo "$item_name" | tr '[:upper:]' '[:lower:]')" == "$(echo "$ADDRESS.abi.$file_extension" | tr '[:upper:]' '[:lower:]')" ]]; then
            if [ ! -d "$local_folder" ]; then
                mkdir -p "$local_folder"
            fi

            raw_url="https://raw.githubusercontent.com/$REPO/feature/$BRANCH/chain-id/$file_type/$CHAIN_ID/$item_name"
            view_url="https://github.com/$REPO/blob/feature/$BRANCH/chain-id/$file_type/$CHAIN_ID/$item_name"
            download_file "$raw_url" "$view_url" "$local_folder/$item_name"
            file_found=true
        fi
    done <<< "$(echo "$response_body" | grep -o '"name": "[^"]*' | cut -d '"' -f 4)"

    if [ "$file_found" = false ]; then
        echo -e "${YELLOW}No files found for address: ${ADDRESS} in ${file_type} files${RESET}"
    fi
}

for subdir in "${SUBDIRECTORIES[@]}"; do
    chain_id_url="https://api.github.com/repos/$REPO/contents/chain-id/$subdir/$CHAIN_ID?ref=feature/$BRANCH"
    check_chain_id_exists "$chain_id_url"
done

for subdir in "${SUBDIRECTORIES[@]}"; do
    folder_url="https://api.github.com/repos/$REPO/contents/chain-id/$subdir/$CHAIN_ID?ref=feature/$BRANCH"
    local_folder="abi/$CHAIN_ID/$subdir"

    if [ "$subdir" == "normal" ]; then
        download_files_from_directory "$folder_url" "$local_folder" "normal" "json"
    elif [ "$subdir" == "pretty" ]; then
        download_files_from_directory "$folder_url" "$local_folder" "pretty" "sol"
    fi
done
