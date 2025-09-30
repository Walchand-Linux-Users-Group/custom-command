#!/usr/bin/env bash

# === Self-installation ===
command_name="finddup"
script_path=$(realpath "$0")
install_path="/usr/local/bin/$command_name"

if [ ! -f "$install_path" ]; then
  cp "$script_path" "$install_path"
  chmod +x "$install_path"
  echo "✅ Installed $command_name to $install_path"
fi

# === Actual command logic ===
dir="${1:-.}"   # default to current directory if no arg

if [ ! -d "$dir" ]; then
  echo "Error: '$dir' is not a directory!"
    exit 1
  fi

echo "🔎 Scanning for duplicate files in: $dir"
echo

# Find duplicates by hashing file contents (sha256)
find "$dir" -type f -print0 | xargs -0 sha256sum 2>/dev/null \
  | sort | awk '{
      if ($1 in seen) {
          print "Duplicate:", $2, "==", seen[$1]
      } else {
          seen[$1] = $2
      }
  }'
