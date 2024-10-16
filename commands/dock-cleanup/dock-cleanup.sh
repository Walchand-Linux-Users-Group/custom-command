#!/bin/bash


if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or use sudo"
  exit 1
fi


command_name="dock-cleanup"

cleanup_command() {

  echo "Stopping The Running Containers..."
  docker stop $(docker ps -aq)


  echo "Removing All Containers..."
  docker rm -f $(docker ps -aq)

  
  echo "Removing All Images Forcefully..."
  docker rmi -f $(docker images -aq)

  echo "Docker cleanup complete!!!!"
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

  cleanup_command
fi