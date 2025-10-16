#!/bin/sh

GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
BOLD="\033[1m"
RESET="\033[0m"

OUTPUT_DIR="."
CONTAINER=""

while [ "$#" -gt 0 ]; do
    case "$1" in
        --container)
            shift
            CONTAINER="$1"
            ;;
        --output)
            shift
            OUTPUT_DIR="$1"
            ;;
        --help)
            echo "Usage: docker-backup.sh --container <name_or_id> [--output <dir>]"
            exit 0
            ;;
        *)
            echo "${RED}Unknown option: $1${RESET}"
            exit 1
            ;;
    esac
    shift
done

if [ -z "$CONTAINER" ]; then
    echo "${RED}Error: Please specify a container using --container${RESET}"
    exit 1
fi

CID=$(docker ps -a -q -f "name=$CONTAINER")
if [ -z "$CID" ]; then
    echo "${RED}Error: No container found with name or ID '$CONTAINER'${RESET}"
    exit 1
fi

VOLUMES=$(docker inspect --format '{{range .Mounts}}{{if eq .Type "volume"}}{{.Name}} {{end}}{{end}}' "$CID")

if [ -z "$VOLUMES" ]; then
    echo "${YELLOW}No named volumes found for container '$CONTAINER'. Nothing to back up.${RESET}"
    exit 0
fi

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$OUTPUT_DIR/${CONTAINER}_volumes_backup_$TIMESTAMP.tar.gz"

echo "${GREEN}Backing up volumes for container '$CONTAINER'...${RESET}"

VOLUME_FLAGS=""
VOLUME_PATHS=""
for VOL in $VOLUMES; do
    VOLUME_FLAGS="$VOLUME_FLAGS -v $VOL:/vol_$VOL"
    VOLUME_PATHS="$VOLUME_PATHS /vol_$VOL"
done

docker run --rm $VOLUME_FLAGS -v "$OUTPUT_DIR:/backup" alpine \
    sh -c "tar czf /backup/backup.tar.gz $VOLUME_PATHS"

if [ -f "$OUTPUT_DIR/backup.tar.gz" ]; then
    mv "$OUTPUT_DIR/backup.tar.gz" "$BACKUP_FILE"
    echo "${GREEN}Backup completed successfully:${RESET} $BACKUP_FILE"
else
    echo "${RED}Backup failed! No file created.${RESET}"
    exit 1
fi