#!/bin/bash


echo "Pushing changes to origin/main..."
git push origin main


if [ $? -eq 0 ]; then
    echo "Changes successfully pushed to 'main' branch."
else
    echo "Error: Failed to push changes."
    exit 1
fi


echo "Pulling latest changes from origin/main..."
git pull origin main


echo "Rebasing with origin/main..."
git rebase origin/main

if [ $? -eq 0 ]; then
    echo "Push, pull, and rebase process completed successfully!"
else
    echo "Error: Rebasing failed."
    exit 1
fi

