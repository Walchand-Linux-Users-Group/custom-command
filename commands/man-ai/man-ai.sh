#!/bin/bash
# man-ai.sh — Smart Manual Page Finder

# Ensure argument provided
if [ -z "$1" ]; then
    echo "Usage: man-ai <approx_command_name>"
    exit 1
fi

query="$1"

# Check if man page exists directly
if man "$query" >/dev/null 2>&1; then
    man "$query"
    exit 0
fi

# If not found, search for similar commands
echo "❌ No man page found for '$query'. Searching similar commands..."
suggestions=$(compgen -c | grep -i "^$query" | head -5)

if [ -z "$suggestions" ]; then
    suggestions=$(compgen -c | grep -i "$query" | head -5)
fi

if [ -z "$suggestions" ]; then
    echo "No similar commands found."
    exit 1
fi

echo "Did you mean one of these?"
select cmd in $suggestions "Cancel"; do
    case $cmd in
        "Cancel")
            echo "Cancelled."
            exit 0
            ;;
        *)
            echo "Opening man page for '$cmd'..."
            man "$cmd"
            break
            ;;
    esac
done
