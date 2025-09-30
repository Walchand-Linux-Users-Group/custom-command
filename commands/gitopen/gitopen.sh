#!/usr/bin/env bash

# === Self-installation ===
command_name="gitopen"
script_path=$(realpath "$0")
install_path="/usr/local/bin/$command_name"

if [ ! -f "$install_path" ]; then
  cp "$script_path" "$install_path"
  chmod +x "$install_path"
  echo "✅ Installed $command_name to $install_path"
fi

# === Command logic ===

# Ensure we're inside a git repo
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "❌ Not inside a Git repository!"
    exit 1
fi

# Get remote URL
remote_url=$(git config --get remote.origin.url)

if [ -z "$remote_url" ]; then
    echo "❌ No remote origin found!"
    exit 1
fi

# Convert SSH to HTTPS
if [[ $remote_url =~ ^git@ ]]; then
    remote_url=$(echo "$remote_url" | sed -E 's#git@(.*):(.*).git#https://\1/\2#')
fi

# Remove .git if present
remote_url=${remote_url%.git}

echo "🌐 Opening $remote_url ..."

# Try opening with available method
if command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$remote_url" >/dev/null 2>&1
elif command -v open >/dev/null 2>&1; then # macOS
    open "$remote_url"
elif command -v wslview >/dev/null 2>&1; then # WSL
    wslview "$remote_url" >/dev/null 2>&1
else
    explorer.exe "$remote_url" >/dev/null 2>&1 || {
        echo "❌ Could not detect a way to open the browser."
        exit 1
    }
fi
