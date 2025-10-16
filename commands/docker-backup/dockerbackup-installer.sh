#!/bin/sh

SCRIPT_NAME="docker-backup.sh"
INSTALL_DIR="/usr/local/bin"
TARGET_NAME="docker-backup"

if [ ! -f "$SCRIPT_NAME" ]; then
    echo "Error: $SCRIPT_NAME not found in the current directory."
    exit 1
fi

if [ "$(id -u)" != "0" ]; then
    echo "Please run this script with sudo or as root"
    exit 1
fi

cp "$SCRIPT_NAME" "$INSTALL_DIR/$TARGET_NAME"
if [ $? -ne 0 ]; then
    echo "Error: Failed to copy $SCRIPT_NAME to $INSTALL_DIR"
    exit 1
fi

chmod +x "$INSTALL_DIR/$TARGET_NAME"

echo "Installation complete!"
echo "You can now run the command as 'docker-backup' from anywhere."

