#!/bin/bash

# Check if xclip or pbcopy is installed
if command -v xclip &> /dev/null; then
  CLIP_CMD="xclip -selection clipboard"
elif command -v pbcopy &> /dev/null; then
  CLIP_CMD="pbcopy"
else
  echo "Please install xclip (Linux) or pbcopy (macOS) to use this script."
  exit 1
fi

# Check if a command is provided
if [ -z "\$1" ]; then
  echo "Usage: \$0 <command>"
  exit 1
fi

# Execute the command and copy the output to the clipboard
OUTPUT=$($@)
echo "$OUTPUT" | $CLIP_CMD

echo "Output of '$@' has been copied to the clipboard."

