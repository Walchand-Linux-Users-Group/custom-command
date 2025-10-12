#!/bin/bash
# cheatme - Terminal cheat sheet and command reference manager

CHEAT_DIR="$HOME/.cheats"
mkdir -p "$CHEAT_DIR"

usage() {
    echo "Usage: cheatme [COMMAND] [TOPIC]"
    echo ""
    echo "Instantly view, add, or search cheat sheets for code and tools"
    echo ""
    echo "Commands:"
    echo "  view <topic>           View a cheat sheet"
    echo "  search <keyword>       Search all cheat sheets"
    echo "  add <topic>            Create or edit a cheat sheet (opens editor)"
    echo "  list                   List all available cheat sheets"
    echo "  remove <topic>         Delete a cheat sheet"
    echo "  help                   Show this help message"
    echo ""
    echo "Examples:"
    echo "  cheatme view git"
    echo "  cheatme search array python"
    echo "  cheatme add awk"
    echo "  cheatme list"
    exit 1
}

[ "$#" -eq 0 ] && usage

COMMAND=$1; shift

case $COMMAND in
    help|-h|--help)
        usage
        ;;
    view)
        [ -z "$1" ] && { echo "Topic required."; exit 1; }
        file="$CHEAT_DIR/$1.cheat"
        [ ! -f "$file" ] && { echo "No cheat sheet found for '$1'."; exit 1; }
        less "$file"
        ;;
    add)
        [ -z "$1" ] && { echo "Topic required."; exit 1; }
        file="$CHEAT_DIR/$1.cheat"
        ${EDITOR:-nano} "$file"
        ;;
    search)
        [ -z "$1" ] && { echo "Keyword required."; exit 1; }
        echo "Searching for '$1' in all cheat sheets:"
        grep -ri --color=always "$1" "$CHEAT_DIR"
        ;;
    list)
        echo "Available cheat sheets:"
        ls "$CHEAT_DIR" | sed 's/\.cheat$//'
        ;;
    remove)
        [ -z "$1" ] && { echo "Topic required."; exit 1; }
        file="$CHEAT_DIR/$1.cheat"
        [ -f "$file" ] && rm -i "$file" || echo "No cheat sheet found for '$1'."
        ;;
    *)
        echo "Unknown command: $COMMAND"
        usage
        ;;
esac
