# gacp

## Description
The gacp command simplifies the process of adding, committing, and pushing changes to a Git repository. It automates the three most common commands developers use:

git add .
git commit -m "message"
git push origin main
This saves time by avoiding repetitive manual inputs, especially for frequent commits.

## Syntax 
```bash
gacp "commit message" 
```

## Features of the Custom Command
1) Simple Workflow Automation </br>

Runs git add ., git commit -m "message", and git push origin main in a single command.</br>

2) Error Handling</br>

Checks if the user has provided a commit message and warns if it’s missing.</br>

3) Optional Branch Handling</br>

By default, pushes to the main branch, but the branch can be customized in future versions.</br>