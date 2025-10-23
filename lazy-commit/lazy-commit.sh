#!/bin/bash
# lazy-commit.sh — Auto commit with per-file message
# Author: Siddharth Swami
# Version: 3.0.0

set -e

# Ensure inside a git repo
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  echo "❌ Not a git repository!"
  exit 1
fi

# Get changed files
changed_files=$(git status --porcelain | awk '{print $2}')

if [ -z "$changed_files" ]; then
  echo "✅ No changes to commit!"
  exit 0
fi

echo "🔍 Detected changed files:"
echo "$changed_files" | sed 's/^/   • /'

# Stage everything
git add .

# Generate a smart commit message based on file names
commit_files=""
for f in $changed_files; do
  # Extract just the filename (not the path)
  filename=$(basename "$f")
  commit_files+="$filename, "
done

# Remove trailing comma and space
commit_files=${commit_files%, }

# Construct message
commit_msg="update $commit_files — $(date +'%Y-%m-%d %H:%M:%S')"

# If user provided a message manually, override auto message
if [ $# -gt 0 ]; then
  commit_msg="$*"
fi

echo ""
echo "📝 Commit message:"
echo "   $commit_msg"

# Commit
git commit -m "$commit_msg"

# Ask to push
echo ""
read -p "🚀 Push to remote? (y/n): " yn
if [[ $yn == [Yy]* ]]; then
  git push
  echo "✅ Changes pushed!"
else
  echo "💾 Local commit only."
fi
