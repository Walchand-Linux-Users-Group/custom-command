#!/bin/bash

# Check if curl is installed
if ! command -v curl &> /dev/null; then
  echo "curl is not installed. Installing curl..."
  
  # Install curl based on the system's package manager
  if [ -f /etc/debian_version ]; then
    sudo apt update && sudo apt install -y curl
  elif [ -f /etc/redhat-release ]; then
    sudo yum install -y curl
  elif [ -f /etc/arch-release ]; then
    sudo pacman -S --noconfirm curl
  elif [ -f /etc/alpine-release ]; then
    sudo apk add --no-cache curl
  else
    echo "Unsupported operating system. Please install curl manually."
    exit 1
  fi
fi

# Check if a description is provided as an argument
if [ -z "$1" ]; then
  echo "Please provide a description for the IP log."
  echo "e.g. Checking home network."
  exit 1
fi

# Get the current timestamp
timestamp=$(date '+%Y-%m-%d %H:%M:%S')

# Fetch the public IP using curl
ip=$(curl -s ifconfig.me)

# Log file path
log_file=~/iplog.txt

# Append the timestamp, IP, and description to the log file
echo "$timestamp - IP: $ip - $1" >> $log_file

# Provide feedback to the user
echo "Logged IP address: $ip with description: $1"
