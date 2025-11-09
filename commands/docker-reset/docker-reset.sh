#!/bin/bash
# docker-reset.sh — Reset Docker resources for a specific project or for all
# Author: Naresh Adhe
# WLUG Custom Command Contribution

project=$1

echo "🐳 Docker Reset Utility"
echo "-----------------------------------"

# 🧩 Global reset mode (no project name)
if [ -z "$project" ]; then
  echo "⚠️  No project name provided — this will remove *all* Docker resources!"
  echo ""
  read -p "Do you want to continue with a full Docker reset? (y/n): " all_confirm
  if [[ "$all_confirm" != "y" ]]; then
    echo "❌ Reset cancelled."
    exit 0
  fi

  echo ""
  echo "Removing all containers..."
  docker rm -f $(docker ps -aq) >/dev/null 2>&1 || echo "No containers to remove."
  echo "✅ All containers removed."

  echo ""
  echo "Removing all images..."
  docker rmi -f $(docker images -aq) >/dev/null 2>&1 || echo "No images to remove."
  echo "✅ All images removed."

  echo ""
  echo "Removing all volumes..."
  docker volume rm $(docker volume ls -q) >/dev/null 2>&1 || echo "No volumes to remove."
  echo "✅ All volumes removed."

  echo ""
  echo "Removing all custom networks..."
  docker network rm $(docker network ls | grep -v "bridge\|host\|none" | awk '{if(NR>1) print $1}') >/dev/null 2>&1 || echo "No custom networks to remove."
  echo "✅ All custom networks removed."

  echo ""
  echo "Performing deep cleanup..."
  docker system prune -af --volumes >/dev/null 2>&1
  echo "✅ System prune complete."

  echo ""
  echo "✅ Docker environment fully reset — it’s as clean as new!"
  exit 0
fi

# 🧩 Project-specific reset mode
echo "Resetting Docker resources for project: $project"
echo ""

# Find matching resources
containers=$(docker ps -a --filter "name=${project}" --format "{{.Names}}")
# Include both repository:tag and ID for display
images_full=$(docker images --format "{{.Repository}}:{{.Tag}} {{.ID}}" | grep -E "${project}" || true)
# Extract only image IDs for deletion
images=$(echo "$images_full" | awk '{print $2}' || true)
volumes=$(docker volume ls --format "{{.Name}}" | grep -E "${project}" || true)
networks=$(docker network ls --format "{{.Name}}" | grep -E "${project}" || true)

# Check if nothing to delete
if [ -z "$containers" ] && [ -z "$images" ] && [ -z "$volumes" ] && [ -z "$networks" ]; then
  echo "⚠️  No Docker resources found for project: $project"
  exit 0
fi

# Display summary
echo "Containers to remove:"
echo "${containers:-None}"
echo ""
echo "Images to remove:"
if [ -n "$images_full" ]; then
  echo "$images_full" | while read line; do
    repo_tag=$(echo "$line" | awk '{print $1}')
    id=$(echo "$line" | awk '{print $2}')
    echo "  $repo_tag (ID: $id)"
  done
else
  echo "None"
fi
echo ""
echo "Volumes to remove:"
echo "${volumes:-None}"
echo ""
echo "Networks to remove:"
echo "${networks:-None}"
echo ""

read -p "Proceed with reset of project '$project'? (y/n): " confirm
if [[ "$confirm" != "y" ]]; then
  echo "❌ Reset cancelled."
  exit 0
fi

# Remove containers
if [ -n "$containers" ]; then
  docker rm -f $containers >/dev/null 2>&1
  echo "✅ Containers removed."
fi

# Remove images (using IDs ensures <none> tags are removed too)
if [ -n "$images" ]; then
  docker rmi -f $images >/dev/null 2>&1
  echo "✅ Images removed."
fi

# Remove volumes
if [ -n "$volumes" ]; then
  docker volume rm $volumes >/dev/null 2>&1
  echo "✅ Volumes removed."
fi

# Remove networks
if [ -n "$networks" ]; then
  docker network rm $networks >/dev/null 2>&1
  echo "✅ Networks removed."
fi

echo ""
echo "✅ Reset complete for project: $project"