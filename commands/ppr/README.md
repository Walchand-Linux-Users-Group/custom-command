# Project Name

This project includes custom scripts that automate frequently used Git commands. Below, you will find information about the `ppr` command which simplifies the Git workflow.

## ppr

### Description
The `ppr` command automates the process of pushing changes, pulling the latest updates, and rebasing your branch with the remote `main` branch. It combines three commonly used Git commands into one, streamlining your workflow:

```bash
git push origin main
git pull origin main
git rebase origin/main

```
instead of all above just run following
```
./ppr.sh

```
