#!/bin/bash
# gitquick - Streamlined Git workflow command
# Description: Combines status, staging, committing, and pushing operations

# Function to display usage
usage() {
    echo "Usage: gitquick [commit message]"
    echo ""
    echo "Streamlined Git workflow that performs:"
    echo "  1. Shows current git status"
    echo "  2. Stages all changes"
    echo "  3. Commits with provided message"
    echo "  4. Pushes to current branch"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo ""
    echo "Examples:"
    echo "  gitquick \"Added new feature\""
    echo "  gitquick \"Fixed bug in authentication\""
    exit 1
}

# Check for help flag
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    usage
fi

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Error: Not a git repository"
    exit 1
fi

# Check if commit message is provided
if [ -z "$1" ]; then
    echo "❌ Error: Commit message is required"
    usage
fi

COMMIT_MSG="$*"

echo "🔍 Git Status:"
echo "======================================"
git status --short
echo ""

# Check if there are changes to commit
if [ -z "$(git status --porcelain)" ]; then
    echo "✅ Working tree clean - nothing to commit"
    exit 0
fi

echo "📦 Staging all changes..."
git add .
if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to stage changes"
    exit 1
fi
echo "✅ Changes staged"
echo ""

echo "💾 Committing with message: '$COMMIT_MSG'"
git commit -m "$COMMIT_MSG"
if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to commit changes"
    exit 1
fi
echo "✅ Changes committed"
echo ""

# Get current branch
BRANCH=$(git branch --show-current)
echo "🚀 Pushing to branch: $BRANCH"
git push origin "$BRANCH"
if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to push changes"
    echo "   You may need to set upstream: git push -u origin $BRANCH"
    exit 1
fi
echo "✅ Successfully pushed to $BRANCH"
echo ""
echo "🎉 All done!"
