#!/bin/sh

GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
RESET="\033[0m"

INSTALL_FLAG=0
OUTPUT_DIR=""
CONTAINER=""

while [ "$#" -gt 0 ]; do
    case "$1" in
        --output)
            shift
            OUTPUT_DIR="$1"
            ;;
        --install)
            INSTALL_FLAG=1
            ;;
        --help|-h)
            echo "Usage: docker-backup <container_name> [--output <dir>] [--install]"
            echo "  <container_name> : name of the container to back up"
            echo "  --output <dir>   : optional, specify backup directory (default: ~/docker-backups)"
            echo "  --install        : optional, installs this script globally to /usr/local/bin/docker-backup"
            exit 0
            ;;
        *)
            if [ -z "$CONTAINER" ]; then
                CONTAINER="$1"
            else
                echo "${RED}Unknown option or multiple container names: $1${RESET}"
                exit 1
            fi
            ;;
    esac
    shift
done

if [ $INSTALL_FLAG -eq 1 ]; then
    INSTALL_DIR="/usr/local/bin"
    TARGET_NAME="docker-backup"

    if [ "$(id -u)" != "0" ]; then
        echo "${RED}Please run this script with sudo to install globally${RESET}"
        exit 1
    fi

    cp "$0" "$INSTALL_DIR/$TARGET_NAME"
    chmod +x "$INSTALL_DIR/$TARGET_NAME"

    if [ $? -eq 0 ]; then
        echo "${GREEN}Installed successfully!${RESET}"
        echo "You can now run the command as 'docker-backup <container_name>' from anywhere."
        exit 0
    else
        echo "${RED}Installation failed!${RESET}"
        exit 1
    fi
fi

if [ -z "$CONTAINER" ]; then
    echo "${RED}Error: Please specify a container name${RESET}"
    exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
    echo "${RED}Error: Docker is not installed.${RESET}"
    exit 1
fi

BACKUP_DIR="${OUTPUT_DIR:-$HOME/docker-backups}"
mkdir -p "$BACKUP_DIR"

LOG_DIR="$HOME/.docker-backup"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/docker-backup.log"

CIDS=$(docker ps -a -q --filter "name=^/${CONTAINER}$")
COUNT=$(echo "$CIDS" | wc -w)
if [ "$COUNT" -eq 0 ]; then
    echo "${RED}Error: No container found with name '$CONTAINER'${RESET}"
    exit 1
elif [ "$COUNT" -gt 1 ]; then
    echo "${RED}Error: Multiple containers match '$CONTAINER'. Please use exact name.${RESET}"
    exit 1
fi
CID=$CIDS

VOLUMES=$(docker inspect --format '{{range .Mounts}}{{if eq .Type "volume"}}{{.Name}} {{end}}{{end}}' "$CID")
if [ -z "$VOLUMES" ]; then
    echo "${YELLOW}No named volumes found for container '$CONTAINER'. Nothing to back up.${RESET}"
    exit 0
fi

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/${CONTAINER}_volumes_backup_$TIMESTAMP.tar.gz"

echo "${GREEN}Backing up volumes for container '$CONTAINER'...${RESET}"
echo "$(date '+%Y-%m-%d %H:%M:%S') Backing up container: $CONTAINER, volumes: $VOLUMES" >> "$LOG_FILE"

VOLUME_FLAGS=""
VOLUME_PATHS=""
for VOL in $VOLUMES; do
    VOLUME_FLAGS="$VOLUME_FLAGS -v $VOL:/vol_$VOL"
    VOLUME_PATHS="$VOLUME_PATHS /vol_$VOL"
done

docker run --rm $VOLUME_FLAGS -v "$BACKUP_DIR:/backup" alpine \
    sh -c "tar czf /backup/backup.tar.gz $VOLUME_PATHS"

if [ -f "$BACKUP_DIR/backup.tar.gz" ]; then
    mv "$BACKUP_DIR/backup.tar.gz" "$BACKUP_FILE"
    echo "${GREEN}Backup completed successfully:${RESET} $BACKUP_FILE"
    echo "$(date '+%Y-%m-%d %H:%M:%S') Backup completed: $BACKUP_FILE" >> "$LOG_FILE"
else
    echo "${RED}Backup failed for container '$CONTAINER'!${RESET}"
    echo "$(date '+%Y-%m-%d %H:%M:%S') Backup failed for container $CONTAINER" >> "$LOG_FILE"
    exit 1
fi

