#!/bin/bash
# lazy-commit.sh — Smart auto commit helper
# Author: Siddharth Swami
# Version: 1.0.0

# Exit on error
set -e

# Ensure inside a git repo
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  echo "❌ Not a git repository!"
  exit 1
fi

# Detect changed files
changed_files=$(git status --porcelain | awk '{print $2}')

if [ -z "$changed_files" ]; then
  echo "✅ No changes to commit!"
  exit 0
fi

echo "🔍 Detecting changes..."
echo "$changed_files" | sed 's/^/   • /'

# Stage all
git add .

# Function to detect commit type
detect_commit_type() {
  file=$1
  case "$file" in
    *.js|*.ts|*.jsx|*.tsx|*.java|*.py|*.cpp|*.c|*.h)
      echo "code";;
    *.html|*.css|*.scss|*.json|*.yml|*.yaml)
      echo "frontend";;
    *.md|*.txt)
      echo "docs";;
    *.env|*.config|*.ini|*.toml)
      echo "config";;
    *.png|*.jpg|*.jpeg|*.svg|*.gif)
      echo "assets";;
    *)
      echo "misc";;
  esac
}

# Determine dominant type
types=""
for f in $changed_files; do
  t=$(detect_commit_type "$f")
  types="$types $t"
done

# Count frequency
main_type=$(echo "$types" | tr ' ' '\n' | sort | uniq -c | sort -nr | head -1 | awk '{print $2}')

# Auto commit message
timestamp=$(date +"%Y-%m-%d %H:%M:%S")
commit_msg="lazy: update ${main_type} files — $timestamp"

# Allow custom message override
if [ $# -gt 0 ]; then
  commit_msg="$*"
fi

# Commit
echo "📝 Committing as:"
echo "   $commit_msg"
git commit -m "$commit_msg"

# Optional: Ask to push
read -p "🚀 Push to remote? (y/n): " yn
if [[ $yn == [Yy]* ]]; then
  git push
  echo "✅ Changes pushed!"
else
  echo "💾 Local commit only."
fi
