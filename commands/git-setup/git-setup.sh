#!/bin/bash

command_name="git-setup"

git_setup() {
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: git-setup <username> <email>"
    exit 1
  fi

  git config --global user.name "$1"
  git config --global user.email "$2"

  echo "Git user setup complete!"
  echo "Username: $1"
  echo "Email: $2"
}

if ! command -v $command_name &> /dev/null; then
  script_path=$(realpath "$0")
  cp "$script_path" /usr/local/bin/$command_name
  chmod +x /usr/local/bin/$command_name
  echo "$command_name command installed successfully!"
  exit 0
else
  echo "$command_name is already installed, setting up Git user..."
  git_setup "$@"
fi
