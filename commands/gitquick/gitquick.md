# gitquick

## Description
Streamlined Git workflow command that combines status checking, staging all changes, committing with a message, and pushing to the current branch in a single command.

## Syntax
```bash
gitquick "commit message"
```

## Features of the custom command
- **All-in-One Workflow**: Executes git status, add, commit, and push in one streamlined operation
- **Visual Status Display**: Shows git status with short format before performing operations
- **Error Handling**: Validates git repository, checks for changes, and handles push failures gracefully
- **Branch Detection**: Automatically detects current branch and pushes to the correct remote branch
- **Progress Feedback**: Provides clear emoji-based progress indicators for each step of the workflow
