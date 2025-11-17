#!/bin/bash
# ---------------------------------------------------------
# git-auto-init.sh
# A one-command Git + GitHub setup automation
# ---------------------------------------------------------

set -e

# ---- Default Configuration ----
VISIBILITY="public"    # Default repo visibility
BRANCH="main"
DESCRIPTION=""

# ---- Parse Command-Line Arguments ----
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --private)
            VISIBILITY="private"
            ;;
        --desc)
            DESCRIPTION="$2"
            shift
            ;;
        -*|--*)
            echo "❌ Unknown option: $1"
            echo "Usage: git-auto-init <repo_name> [--private] [--desc \"description\"]"
            exit 1
            ;;
        *)
            if [ -z "$REPO_NAME" ]; then
                REPO_NAME="$1"
            fi
            ;;
    esac
    shift
done

# ---- Check Required Tools ----
if ! command -v git &>/dev/null; then
    echo "❌ Git is not installed. Please install Git first."
    exit 1
fi

install_gh() {
    echo "⚙️  GitHub CLI (gh) not found. Installing..."

    if [ -x "$(command -v apt)" ]; then
        echo "🔍 Updating package list quietly..."
        sudo apt-get update -y -qq > /dev/null 2>&1

        echo "📦 Installing GitHub CLI..."
        sudo apt-get install -y gh | grep -E "Preparing|Unpacking|Setting up|gh"

    elif [ -x "$(command -v dnf)" ]; then
        echo "📦 Installing GitHub CLI via DNF..."
        sudo dnf install -y gh >/dev/null 2>&1 && echo "✅ Installed gh via DNF."

    elif [ -x "$(command -v brew)" ]; then
        echo "📦 Installing GitHub CLI via Homebrew..."
        brew install gh >/dev/null 2>&1 && echo "✅ Installed gh via Homebrew."

    else
        echo "❌ Unsupported package manager. Please install manually: https://cli.github.com/"
        exit 1
    fi

    echo "✅ GitHub CLI installed successfully!"
}

# ---- Check for GitHub CLI ----
if ! command -v gh &>/dev/null; then
    install_gh
else
    echo "✅ GitHub CLI detected: $(gh --version | head -n1)"
fi

# ---- Authenticate ----
if ! gh auth status &>/dev/null; then
    echo "🔑 GitHub authentication required."
    echo "Opening browser for authentication..."
    gh auth login --hostname github.com --web --git-protocol https
    echo "✅ Authenticated successfully!"
else
    echo "✅ Already authenticated with GitHub."
fi

# ---- Determine Repo Name ----
if [ -z "$REPO_NAME" ]; then
    REPO_NAME=$(basename "$(pwd)")
    echo "ℹ️  No repo name provided. Using current directory name: $REPO_NAME"
fi

# ---- Check if Repo Already Exists ----
USERNAME=$(gh api user --jq .login)
if gh repo view "$USERNAME/$REPO_NAME" &>/dev/null; then
    echo "⚠️  Repository '$REPO_NAME' already exists on GitHub."
    echo "🛑 Exiting to avoid overwriting or pushing to an existing repository."
    exit 0
fi

# ---- Create README if Missing ----
if [ ! -f "README.md" ]; then
    echo "# $REPO_NAME" > README.md
    echo "📝 Created README.md"
fi

# ---- Initialize Git Repository ----
if [ ! -d ".git" ]; then
    git init -b "$BRANCH"
    echo "✅ Initialized new Git repository."
else
    echo "⚠️  Git repository already exists."
fi

# ---- Add and Commit Changes ----
git add .
if git diff --cached --quiet; then
    echo "ℹ️  Nothing new to commit."
else
    git commit -m "Initial commit"
    echo "💾 Created initial commit."
fi

# ---- Create GitHub Repository ----
echo "🌐 Creating GitHub repository '$REPO_NAME' ($VISIBILITY)..."

if [ -n "$DESCRIPTION" ]; then
    echo "📝 Description: $DESCRIPTION"
    gh repo create "$REPO_NAME" --"$VISIBILITY" --description "$DESCRIPTION" --source=. --remote=origin --push
else
    gh repo create "$REPO_NAME" --"$VISIBILITY" --source=. --remote=origin --push
fi

echo "✅ GitHub repository created successfully."

# ---- Push to GitHub ----
if git remote -v | grep -q "origin"; then
    echo "🚀 Pushing to GitHub..."
    git push -u origin "$BRANCH"
else
    echo "⚠️  Remote not found. Adding origin and pushing..."
    git remote add origin "https://github.com/$USERNAME/$REPO_NAME.git"
    git push -u origin "$BRANCH"
fi

# ---- Final Summary ----
echo ""
echo "🚀 All done!"
echo "📁 Local path: $(pwd)"
echo "🌍 Repo URL: https://github.com/$USERNAME/$REPO_NAME"
echo "🎯 Visibility: $VISIBILITY"
if [ -n "$DESCRIPTION" ]; then
    echo "📝 Description: $DESCRIPTION"
fi