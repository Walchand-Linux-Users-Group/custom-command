#!/bin/bash

echo "Detecting package manager..."


if command -v apt >/dev/null 2>&1; then
    echo "Using apt for Debian-based systems."
    sudo apt update && sudo apt upgrade -y
elif command -v dnf >/dev/null 2>&1; then
    echo "Using dnf for Fedora-based systems."
    sudo dnf check-update && sudo dnf upgrade -y
elif command -v yum >/dev/null 2>&1; then
    echo "Using yum for CentOS-based systems."
    sudo yum check-update && sudo yum upgrade -y
elif command -v pacman >/dev/null 2>&1; then
    echo "Using pacman for Arch-based systems."
    sudo pacman -Syu --noconfirm
elif command -v zypper >/dev/null 2>&1; then
    echo "Using zypper for openSUSE-based systems."
    sudo zypper refresh && sudo zypper update -y
else
    echo "Package manager not supported by this script."
    exit 1
fi

echo "Update and upgrade completed!"
