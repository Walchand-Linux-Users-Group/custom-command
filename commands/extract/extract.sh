#!/usr/bin/env bash

# === Self-installation ===
command_name="extract"
script_path=$(realpath "$0")
install_path="/usr/local/bin/$command_name"

if [ ! -f "$install_path" ]; then
  cp "$script_path" "$install_path"
  chmod +x "$install_path"
  echo "✅ Installed $command_name to $install_path"
fi

# === Actual command logic ===
file="$1"

if [ -z "$file" ]; then
  echo "Usage: $command_name <file>"
  exit 1
fi

if [ ! -f "$file" ]; then
  echo "Error: '$file' not found!"
  exit 1
fi

case "$file" in
  *.tar.bz2)   tar xvjf "$file"   ;;
  *.tar.gz)    tar xvzf "$file"   ;;
  *.tar.xz)    tar xvJf "$file"   ;;
  *.tar)       tar xvf "$file"    ;;
  *.tbz2)      tar xvjf "$file"   ;;
  *.tgz)       tar xvzf "$file"   ;;
  *.bz2)       bunzip2 "$file"    ;;
  *.gz)        gunzip "$file"     ;;
  *.zip)       unzip "$file"      ;;
  *.rar)       unrar x "$file"    ;;
  *.7z)        7z x "$file"       ;;
  *.xz)        unxz "$file"       ;;
  *)
    echo "extract: '$file' - unknown archive format"
    exit 1
    ;;
esac