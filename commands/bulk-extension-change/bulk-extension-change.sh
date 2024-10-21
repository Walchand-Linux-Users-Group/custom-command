#!/bin/bash

# Check if correct number of arguments is provided
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <directory> <old_extension> <new_extension>"
  exit 1
fi

# Assign arguments to variables
DIRECTORY=$1
OLD_EXT=$2
NEW_EXT=$3

# Check if the directory exists
if [ ! -d "$DIRECTORY" ]; then
  echo "Directory not found: $DIRECTORY"
  exit 1
fi

# Total renamed files
count=0

# Rename files
for FILE in "$DIRECTORY"/*."$OLD_EXT"; do
  if [ -f "$FILE" ]; then
    BASENAME=$(basename "$FILE" .$OLD_EXT)
    NEW_NAME="$DIRECTORY/$BASENAME.$NEW_EXT"
    mv "$FILE" "$NEW_NAME"
    echo "Renamed $FILE to $NEW_NAME"
    count=$((count + 1))
  fi
done
echo "Total files processed: $count"
echo "Batch renaming completed."