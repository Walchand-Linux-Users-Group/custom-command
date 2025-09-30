#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or use sudo"
  exit 1
fi

command_name="genpass"

gen_pass() {
  length=${1:-12}
  # Generate a secure password using /dev/urandom
  password=$(< /dev/urandom tr -dc 'A-Za-z0-9!@#$%^&*()_+{}|:<>?[]\;,./'"'"'"' | head -c $length)
  echo "$password"
}

if ! command -v $command_name &> /dev/null; then
  echo "Installing $command_name command..."
  
  script_path=$(realpath "$0")
  
  cp "$script_path" /usr/bin/$command_name
  chmod +x /usr/bin/$command_name
  
  echo "$command_name command installed successfully! You can now use it by typing '$command_name'."
  
  exit 0
else
  gen_pass "$@"
fi