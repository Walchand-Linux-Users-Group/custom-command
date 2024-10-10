# Gitpush.sh

## Description

This script stages all changes, commits them with a provided message, and pushes them to the remote Git repository. It's a convenient way to automate the `git add`, `git commit`, and `git push` commands in one go.

## Syntax

```bash
./gitpush.sh "commit message"
```

## Features

1] Stages all changes in the current directory with git add.<br/>
2] Commits the changes using the specified commit message.<br/>
3] Pushes the commit to the remote repository.
<br/>
4] Provides feedback if no commit message is supplied.
<br/>


code 
#!/bin/bash
# Usage: ./gitpush.sh "commit message"
if [ -z "$1" ]; then
    echo "Please provide a commit message."
    exit 1
fi
git add .
git commit -m "$1"
git push
echo "Changes pushed to remote repository."


Git.sh