# dock-volume-cleanup

## Description

This script, `dock-volume-cleanup`, helps you manage Docker volumes by:

1. **Cleaning up dangling volumes:** Removes unused volumes (not associated with any containers).
2. **Listing remaining volumes:** Provides an overview of all remaining Docker volumes after cleanup.
3. **(Optional) Force removal:** If needed, you can manually remove remaining volumes after reviewing the list. (Instructions included below)

**Important Note:** This script **does not** stop or remove Docker containers or images. It focuses solely on Docker volumes.

## Prerequisites

* Docker installed and running on your system.

## Usage

1.  **Save the script:**
    - Create a new file named `dock-volume-cleanup.sh`.
    - Paste the following script content into the file:

```bash
#!/bin/bash

# Check for root privileges (recommended)
if [ "<span class="math-inline">EUID" \-ne 0 \]; then
echo "This script is recommended to run with root privileges for optimal cleanup\."
echo "Consider using 'sudo dock\-volume\-cleanup'\."
fi
\#\# Cleanup function
cleanup\_volumes\(\) \{
echo "Cleaning up dangling Docker volumes\.\.\."
docker volume prune \-f
echo "Listing remaining Docker volumes\.\.\."
docker volume ls
echo "Docker volume cleanup complete\!"
\}
\# Installation \(optional\)
if \! command \-v dock\-volume\-cleanup &\> /dev/null; then
echo "Installing dock\-volume\-cleanup command\.\.\."
script\_path\=</span>(realpath "$0")

  # Consider using a dedicated directory for user-installed scripts (e.g., ~/.local/bin)
  # instead of /usr/local/bin (requires root privileges).
  install_path=~/.local/bin/dock-volume-cleanup

  cp "$script_path" "$install_path"

  chmod +x "$install_ path"

  echo "dock-volume-cleanup command installed successfully! You can now use it by typing 'dock-volume-cleanup'."

  exit 0
else
  echo "dock-volume-cleanup is already installed, running cleanup..."
  cleanup_volumes
fi