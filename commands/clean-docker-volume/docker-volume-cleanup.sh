#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or use sudo"
  exit 1
fi

command_name="dock-volume-cleanup"

cleanup_volumes() {

  echo "Cleaning up dangling Docker volumes..."
  docker volume prune -f

  echo "Listing remaining Docker volumes..."
  docker volume ls

  echo "Docker volume cleanup complete!"
}

if ! command -v $command_name &> /dev/null; then
  echo "Installing $command_name command..."

  script_path=$(realpath "$0")

  cp "$script_path" /usr/local/bin/$command_name

  chmod +x /usr/local/bin/$command_name

  echo "$command_name command installed successfully! You can now use it by typing '$command_name'."

  exit 0
else
  echo "$command_name is already installed, running cleanup..."

  cleanup_volumes
fi
