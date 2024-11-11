gacp() {
  if [ -z "$1" ]; then
    echo "Error: Commit message is required."
    echo "Usage: gacp \"commit message\""
    return 1
  fi

  echo "Adding changes..."
  git add .

  echo "Committing with message: $1"
  git commit -m "$1"

  echo "Pushing to origin main..."
  git push origin main

  if [ $? -eq 0 ]; then
    echo "Changes successfully pushed to 'main' branch."
  else
    echo "Error: Failed to push changes."
  fi
}
