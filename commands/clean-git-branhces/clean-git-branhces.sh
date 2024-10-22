#!/bin/bash

# Git Branch Cleaner
# Lists merged branches and offers to delete them

# Ensure we are in a Git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo "This is not a Git repository."
  exit 1
fi

# Get the current branch name
current_branch=$(git branch --show-current)

# List merged branches, excluding the current branch and master/main
merged_branches=$(git branch --merged | grep -vE "^\*|master|main")

if [ -z "$merged_branches" ]; then
  echo "No merged branches to delete."
  exit 0
fi

echo "Merged branches:"
echo "$merged_branches"
echo

# Prompt to delete each merged branch
while IFS= read -r branch; do
  read -p "Do you want to delete branch '$branch'? [y/N]: " confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    git branch -d "$branch"
  fi
done <<< "$merged_branches"

echo "Branch cleanup complete."
