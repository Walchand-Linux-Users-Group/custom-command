#!/bin/bash

kill_on_port() {
    if [ -z "$1" ]; then
        echo "Usage: kill_on_port <port-number>"
        return 1
    fi

    pids=$(lsof -ti :"$1")

    if [ -z "$pids" ]; then
        echo "No processes found on port $1."
    else
        echo "Killing processes on port $1..."
        kill -9 $pids
        echo "Killed processes: $pids"
    fi
}

chmod +x "$(realpath "$0")"

if [ ! -f /usr/bin/kill-on-port ]; then
    sudo mv "$(realpath "$0")" /usr/bin/kill-on-port
    echo "Command 'kill-on-port' has been added to /usr/bin."
else
    echo "Command 'kill-on-port' already exists in /usr/bin."
fi

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    kill_on_port "$@"
fi
