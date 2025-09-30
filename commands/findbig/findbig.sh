#!/bin/bash

# Default size limit if none is provided (50MB)
SIZE_LIMIT="${2:-50M}"
SEARCH_PATH="${1:-.}" # Default path is current directory

# Check if the search path is a valid directory
if [ ! -d "$SEARCH_PATH" ]; then
    echo "Error: Directory '$SEARCH_PATH' not found."
    exit 1
fi

echo "Searching for files larger than $SIZE_LIMIT in '$SEARCH_PATH'..."
echo "---"

# Find files and sort them by size in a human-readable format
find "$SEARCH_PATH" -type f -size +$SIZE_LIMIT -exec du -h {} + | sort -rh | head -n 10

echo "---"
echo "Top 10 largest files listed above."