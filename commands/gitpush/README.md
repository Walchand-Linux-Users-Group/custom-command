# Gitpush.sh

## Description

This script stages all changes, commits them with a provided message, and pushes them to the remote Git repository. It's a convenient way to automate the `git add`, `git commit`, and `git push` commands in one go.

## Syntax

```bash
chmod +x gitpush.sh

./gitpush.sh "commit message"
```

## Features

1] Stages all changes in the current directory with git add.<br/>
2] Commits the changes using the specified commit message.<br/>
3] Pushes the commit to the remote repository.
<br/>
4] Provides feedback if no commit message is supplied.
<br/>

`Note`:
#### When It Works:
- The script will work if you are running it in a directory that is already initialized as a Git repository 
- A remote repository is configured (`git remote -v`).
- You have proper authentication configured (e.g SSH keys or cached credentials).
