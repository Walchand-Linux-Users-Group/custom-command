#!/bin/bash

command_name="file-organize"
target_dir="${1:-.}"

file_organize() {
  echo "Organizing files in $target_dir..."

  find "$target_dir" -maxdepth 1 -type f | while read -r file; do
    ext="${file##*.}"
    mkdir -p "$target_dir/$ext"
    mv "$file" "$target_dir/$ext/"
  done

  echo "File organization complete!"
}

if ! command -v $command_name &> /dev/null; then
  script_path=$(realpath "$0")
  cp "$script_path" /usr/local/bin/$command_name
  chmod +x /usr/local/bin/$command_name
  echo "$command_name command installed successfully!"
  exit 0
else
  echo "$command_name is already installed, running organization..."
  file_organize
fi
