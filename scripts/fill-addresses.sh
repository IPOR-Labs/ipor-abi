#!/bin/bash

set -e -o pipefail

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DIRECTORIES=(
  "fill-fuses"
  "fill-prehooks"
  "fill-price-feeds"
  "fill-vaults"
  "fill-factory-vaults"
)

for DIRECTORY in "${DIRECTORIES[@]}"; do
  echo -e "\n================================================\n"
  echo "Starting process in $DIRECTORY directory..."
  cd "$SCRIPTS_DIR/$DIRECTORY"
  
  echo "Executing ./$DIRECTORY.py"
  ./"$DIRECTORY.sh"

  echo "Completed process in $DIRECTORY directory"
done

echo "All processes completed successfully"
