#!/bin/bash
# git_helper.sh - A powerful Git helper script 🚀
# Usage:
#   ./git_helper.sh status         -> Show repo status
#   ./git_helper.sh commit "msg"   -> Add & commit with message
#   ./git_helper.sh push           -> Push changes to remote
#   ./git_helper.sh sync           -> Pull latest changes
#   ./git_helper.sh log            -> Pretty git log

set -e

function show_status() {
    echo "📌 Current branch: $(git branch --show-current)"
    echo "📂 Changed files:"
    git status -s
}

function do_commit() {
    if [ -z "$1" ]; then
        echo "❌ Commit message required"
        exit 1
    fi
    git add .
    git commit -m "$1"
    echo "✅ Changes committed with message: $1"
}

function do_push() {
    branch=$(git branch --show-current)
    git push origin "$branch"
    echo "🚀 Pushed to $branch"
}

function do_sync() {
    branch=$(git branch --show-current)
    git pull origin "$branch"
    echo "🔄 Synced with remote branch: $branch"
}

function show_log() {
    git log --oneline --graph --decorate --all -n 15
}

case "$1" in
    status) show_status ;;
    commit) do_commit "$2" ;;
    push)   do_push ;;
    sync)   do_sync ;;
    log)    show_log ;;
    *)
        echo "Usage: $0 {status|commit 'msg'|push|sync|log}"
        exit 1
        ;;
esac

