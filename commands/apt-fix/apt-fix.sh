#!/bin/bash

command_name="apt-fix"
script_path=$(realpath "$0")


if [ ! -f "/usr/local/bin/$command_name" ]; then
  cp "$script_path" /usr/local/bin/$command_name
  chmod +x /usr/local/bin/$command_name
  echo "Copied and made $command_name executable at /usr/local/bin"
fi


echo "Running apt-fix to manage locks and fix broken installs..."
sudo rm /var/lib/dpkg/lock-frontend /var/lib/dpkg/lock
sudo rm /var/cache/apt/archives/lock
sudo dpkg --configure -a
sudo apt-get install -f
sudo apt-get update


echo "$command_name executed successfully."
