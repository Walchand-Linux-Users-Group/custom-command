#!/usr/bin/env bash

# === Self-installation ===
command_name="ff"
script_path=$(realpath "$0")
install_path="/usr/local/bin/$command_name"

if [ ! -f "$install_path" ]; then
  cp "$script_path" "$install_path"
  chmod +x "$install_path"
  echo "✅ Installed $command_name to $install_path"
fi

# === Dependency check & auto-install ===
if ! command -v fzf &>/dev/null; then
  echo "⚠️  fzf not found, attempting to install..."

  if command -v apt &>/dev/null; then
    sudo apt update && sudo apt install -y fzf
  elif command -v dnf &>/dev/null; then
    sudo dnf install -y fzf
  elif command -v pacman &>/dev/null; then
    sudo pacman -Sy --noconfirm fzf
  elif command -v brew &>/dev/null; then
    brew install fzf
  else
    echo "❌ Could not detect package manager. Please install fzf manually."
    exit 1
  fi

  # Verify installation worked
  if ! command -v fzf &>/dev/null; then
    echo "❌ fzf installation failed. Please install it manually."
    exit 1
  fi

  echo "✅ fzf installed successfully!"
fi

# === Actual command logic ===
dir="${1:-.}"   # default to current directory if no arg

if [ ! -d "$dir" ]; then
  echo "Error: '$dir' is not a directory!"
  exit 1
fi

echo "🔎 Searching files in: $dir"
selected=$(find "$dir" -type f 2>/dev/null | fzf)

if [ -n "$selected" ]; then
  echo "✅ You selected: $selected"
else
  echo "❌ No file selected."
fi
