#!/bin/bash
# logwatch - Real-time log monitoring with color-coded output
# Description: Tails multiple log files with color-coded log levels

# Color codes
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display usage
usage() {
    echo "Usage: logwatch [OPTIONS] <log-file> [log-file2] ..."
    echo ""
    echo "Monitor log files in real-time with color-coded output"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -n, --lines N  Output the last N lines (default: 10)"
    echo "  -f, --follow   Continue following the log file"
    echo ""
    echo "Color codes:"
    echo "  ERROR/FATAL  - Red"
    echo "  WARN/WARNING - Yellow"
    echo "  INFO         - Green"
    echo "  DEBUG        - Blue"
    echo ""
    echo "Examples:"
    echo "  logwatch /var/log/syslog"
    echo "  logwatch -n 20 /var/log/apache2/error.log"
    echo "  logwatch -f /var/log/syslog /var/log/auth.log"
    exit 1
}

# Default values
LINES=10
FOLLOW=""
LOG_FILES=()

# Parse options
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            ;;
        -n|--lines)
            LINES=$2
            shift 2
            ;;
        -f|--follow)
            FOLLOW="-f"
            shift
            ;;
        *)
            if [ -f "$1" ]; then
                LOG_FILES+=("$1")
            elif [ ! -e "$1" ]; then
                echo "❌ Error: File not found: $1"
                exit 1
            fi
            shift
            ;;
    esac
done

# Check if log files are provided
if [ ${#LOG_FILES[@]} -eq 0 ]; then
    echo "❌ Error: No log files specified"
    usage
fi

# Function to colorize log output
colorize_log() {
    while IFS= read -r line; do
        if echo "$line" | grep -iE '(ERROR|FATAL|FAIL)' > /dev/null; then
            echo -e "${RED}$line${NC}"
        elif echo "$line" | grep -iE '(WARN|WARNING)' > /dev/null; then
            echo -e "${YELLOW}$line${NC}"
        elif echo "$line" | grep -iE '(INFO|SUCCESS)' > /dev/null; then
            echo -e "${GREEN}$line${NC}"
        elif echo "$line" | grep -iE 'DEBUG' > /dev/null; then
            echo -e "${BLUE}$line${NC}"
        else
            echo "$line"
        fi
    done
}

echo "🔍 Monitoring log files..."
echo "======================================"
for log_file in "${LOG_FILES[@]}"; do
    echo "📄 $log_file"
done
echo "======================================"
echo ""

# If following multiple files, use tail -f with multiple files
if [ ${#LOG_FILES[@]} -gt 1 ]; then
    if [ -n "$FOLLOW" ]; then
        tail -n "$LINES" $FOLLOW "${LOG_FILES[@]}" | colorize_log
    else
        tail -n "$LINES" "${LOG_FILES[@]}" | colorize_log
    fi
else
    # Single file monitoring
    if [ -n "$FOLLOW" ]; then
        tail -n "$LINES" -f "${LOG_FILES[0]}" | colorize_log
    else
        tail -n "$LINES" "${LOG_FILES[0]}" | colorize_log
    fi
fi
