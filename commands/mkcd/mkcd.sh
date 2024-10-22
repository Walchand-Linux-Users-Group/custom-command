#!/bin/bash

command_name="mkcd"

mkcd_function() {
    if [ -z "$1" ]; then
        echo "Usage: mkcd <directory_name>"
        exit 1
    fi

    mkdir -p "$1" && cd "$1"

    if [ $? -eq 0 ]; then
        exec $SHELL
    else
        echo "Error: Failed to create or change to directory $1"
    fi
}

setup_command() {
    if [ "$EUID" -ne 0 ]; then
        echo "Please run as root or use sudo to set up the command"
        exit 1
    fi

    script_path=$(realpath "$0")
    cp "$script_path" /usr/local/bin/$command_name
    chmod +x /usr/local/bin/$command_name
    echo "Custom command 'mkcd' is now available."
}

if [ -n "$1" ]; then
    mkcd_function "$1"
else
    setup_command
fi
