#!/usr/bin/env bash

# === Self-installation ===
command_name="qr"
script_path=$(realpath "$0")
install_path="/usr/local/bin/$command_name"

if [ ! -f "$install_path" ]; then
  cp "$script_path" "$install_path"
  chmod +x "$install_path"
  echo "✅ Installed $command_name to $install_path"
fi

# === Dependency check & auto-install ===
if ! command -v qrencode &>/dev/null; then
  echo "⚠️  'qrencode' not found, attempting to install..."

  if command -v apt &>/dev/null; then
    sudo apt update && sudo apt install -y qrencode
  elif command -v dnf &>/dev/null; then
    sudo dnf install -y qrencode
  elif command -v pacman &>/dev/null; then
    sudo pacman -Sy --noconfirm qrencode
  elif command -v brew &>/dev/null; then
    brew install qrencode
  else
    echo "❌ Could not detect package manager. Please install qrencode manually."
    exit 1
  fi

  # Verify installation
  if ! command -v qrencode &>/dev/null; then
    echo "❌ qrencode installation failed. Please install manually."
    exit 1
  fi

  echo "✅ qrencode installed successfully!"
fi

# === Actual command logic ===
input="$*"

if [ -z "$input" ]; then
  echo "Usage: $command_name <text or URL>"
  exit 1
fi

# Generate QR code in terminal
qrencode -t ANSIUTF8 "$input"
