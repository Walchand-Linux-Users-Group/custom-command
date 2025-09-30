#!/bin/bash

# global values
BACKUP_DIR="$HOME/backups"
VERBOSE=false
CHECK=false
EXCLUDE_PATTERNS=()
SOURCE_DIR=""
CUSTOM_BACKUP_DIR=""

show_help() {
    cat << EOF
Usage: backup <directory_to_backup> [backup_destination] [options]

Create compressed tar backup of a directory with timestamp.

Arguments:
  directory_to_backup   Source directory to backup (required)
  backup_destination    Custom backup location (optional, default: ~/backups)

Options:
  --exclude <pattern>   Exclude files/directories matching pattern
  --verbose, -v         Show detailed output during backup
  --check, -c           Show what would be backed up without creating archive
  --help, -h            Show this help message

Examples:
  backup /home/user/documents
  backup /home/user/projects /media/backups
  backup /home/user/code --exclude "node_modules" --exclude ".git"
  backup /home/user/photos --verbose --check
EOF
}

# verbose
log() {
    if [ "$VERBOSE" = true ]; then
        echo "[$(date '+%H:%M:%S')] $1"
    fi
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --help|-h)
            show_help
            exit 0
            ;;
        --verbose|-v)
            VERBOSE=true
            shift
            ;;
        --check|-c)
            CHECK=true
            shift
            ;;
        --exclude)
            if [ -n "$2" ]; then
                EXCLUDE_PATTERNS+=("$2")
                shift 2
            else
                echo "Error: --exclude requires a pattern"
                exit 1
            fi
            ;;
        -*)
            echo "Error: Unknown option $1"
            echo "Use --help for usage information"
            exit 1
            ;;
        *)
            if [ -z "$SOURCE_DIR" ]; then
                SOURCE_DIR="$1"
            elif [ -z "$CUSTOM_BACKUP_DIR" ]; then
                CUSTOM_BACKUP_DIR="$1"
            else
                echo "Error: Too many arguments"
                echo "Use --help for usage information"
                exit 1
            fi
            shift
            ;;
    esac
done

if [ -z "$SOURCE_DIR" ]; then
    echo "Error: Directory to backup is required"
    echo "Use --help for usage information"
    exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Directory '$SOURCE_DIR' not found."
    exit 1
fi

# set custom dir if given
if [ -n "$CUSTOM_BACKUP_DIR" ]; then
    BACKUP_DIR="$CUSTOM_BACKUP_DIR"
fi

# take absolute path
SOURCE_DIR=$(realpath "$SOURCE_DIR")
log "Source directory: $SOURCE_DIR"

# backup details
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BASENAME=$(basename "$SOURCE_DIR")
BACKUP_FILE="${BACKUP_DIR}/${BASENAME}_${TIMESTAMP}.tar.gz"

log "Backup file will be: $BACKUP_FILE"

TAR_CMD="tar -czf"
if [ "$VERBOSE" = true ]; then
    TAR_CMD="$TAR_CMD -v"
fi

for pattern in "${EXCLUDE_PATTERNS[@]}"; do
    TAR_CMD="$TAR_CMD --exclude='$pattern'"
    log "Excluding pattern: $pattern"
done

# --- Check Mode ---
if [ "$CHECK" = true ]; then
    echo "backup.sh - Would create a backup of:"
    echo "  Source: $SOURCE_DIR"
    echo "  Destination: $BACKUP_FILE"
    echo "  Exclude patterns: ${EXCLUDE_PATTERNS[*]:-none}"
    echo ""
    echo "Files that would be included (first 20):"
    
    find_cmd="find '$SOURCE_DIR' -type f"
    for pattern in "${EXCLUDE_PATTERNS[@]}"; do
        find_cmd="$find_cmd -not -path \"*/$pattern*\""
    done
    
    eval "$find_cmd" | head -20
    
    file_count=$(eval "$find_cmd" | wc -l)
    echo ""
    echo "Total files: $file_count"
    exit 0
fi

echo "Creating backup of '$SOURCE_DIR' to '$BACKUP_FILE'..."
if [ "${#EXCLUDE_PATTERNS[@]}" -gt 0 ]; then
    echo "Excluding patterns: ${EXCLUDE_PATTERNS[*]}"
fi

mkdir -p "$BACKUP_DIR"
if [ $? -ne 0 ]; then
    echo "Error: Could not create backup directory '$BACKUP_DIR'"
    exit 1
fi

# backup
eval "$TAR_CMD '$BACKUP_FILE' -C '$(dirname "$SOURCE_DIR")' '$(basename "$SOURCE_DIR")'"

# if the backup was successful
if [ $? -eq 0 ]; then
    file_size=$(du -sh "$BACKUP_FILE" 2>/dev/null | cut -f1)
    echo "Backup successful!"
    echo "  File: $BACKUP_FILE"
    echo "  Size: ${file_size:-unknown}"

    # show creation time
    if command -v stat >/dev/null 2>&1; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            creation_time=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$BACKUP_FILE")
        else
            creation_time=$(stat -c "%y" "$BACKUP_FILE" | cut -d'.' -f1)
        fi
        echo "  Created: $creation_time"
    fi
else
    echo "Error: Backup failed."
    if [ -f "$BACKUP_FILE" ]; then
        echo "Cleaning up incomplete backup file..."
        rm -f "$BACKUP_FILE"
    fi
    exit 1
fi