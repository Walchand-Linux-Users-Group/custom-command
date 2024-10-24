#!/bin/bash

command_name="apt-fix"

fix_apt_function() {
    echo "Fixing broken installs and managing locks..."
    
    sudo rm /var/lib/dpkg/lock-frontend
    sudo rm /var/cache/apt/archives/lock
    sudo dpkg --configure -a
    sudo apt update
    sudo apt install -f
    sudo apt autoremove
    sudo apt autoclean

    echo "System fixed successfully!"
}

setup_command() {
    if [ "$EUID" -ne 0 ]; then
        echo "Please run as root or use sudo to set up the command"
        exit 1
    fi

    script_path=$(realpath "$0")
    cp "$script_path" /usr/local/bin/$command_name
    chmod +x /usr/local/bin/$command_name
    echo "Custom command 'apt-fix' is now available."
}

if [ "$EUID" -eq 0 ]; then
    fix_apt_function
else
    setup_command
fi
