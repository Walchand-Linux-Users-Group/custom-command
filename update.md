# Update.sh

## Description

This script detects the package manager used by your Linux system and performs an update and upgrade of all packages. It supports `apt`, `dnf`, `yum`, `pacman`, and `zypper`.

## Syntax

```bash
./Update.sh
```

## Features

1] Automatically detects the package manager based on your system.<br/>
2] Runs the appropriate commands to update and upgrade packages.<br/>
3] Provides feedback on the package manager in use and confirms successful completion.
<br/>



code

#!/bin/bash

echo "Detecting package manager..."

# Check for the package manager and execute the respective update and upgrade commands
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


Update.sh