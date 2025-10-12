#!/bin/bash
# portcheck - Check if specific ports are open/closed
# Description: Network utility to check port status on localhost or remote hosts

# Function to display usage
usage() {
    echo "Usage: portcheck [OPTIONS] <port> [host]"
    echo ""
    echo "Check if a port is open on localhost or a remote host"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -t, --tcp      Check TCP port (default)"
    echo "  -u, --udp      Check UDP port"
    echo ""
    echo "Examples:"
    echo "  portcheck 80              # Check port 80 on localhost"
    echo "  portcheck 22 example.com  # Check port 22 on example.com"
    echo "  portcheck -u 53           # Check UDP port 53 on localhost"
    exit 1
}

# Default values
PROTOCOL="tcp"
HOST="localhost"

# Parse options
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            ;;
        -t|--tcp)
            PROTOCOL="tcp"
            shift
            ;;
        -u|--udp)
            PROTOCOL="udp"
            shift
            ;;
        *)
            if [ -z "$PORT" ]; then
                PORT=$1
            else
                HOST=$1
            fi
            shift
            ;;
    esac
done

# Check if port is provided
if [ -z "$PORT" ]; then
    echo "❌ Error: Port number is required"
    usage
fi

# Validate port number
if ! [[ "$PORT" =~ ^[0-9]+$ ]] || [ "$PORT" -lt 1 ] || [ "$PORT" -gt 65535 ]; then
    echo "❌ Error: Invalid port number. Must be between 1 and 65535"
    exit 1
fi

echo "🔍 Checking ${PROTOCOL^^} port $PORT on $HOST..."
echo ""

# Check if running on localhost
if [ "$HOST" = "localhost" ] || [ "$HOST" = "127.0.0.1" ]; then
    # Check using netstat or ss
    if command -v ss &> /dev/null; then
        if [ "$PROTOCOL" = "tcp" ]; then
            result=$(ss -tln | grep ":$PORT ")
        else
            result=$(ss -uln | grep ":$PORT ")
        fi
    elif command -v netstat &> /dev/null; then
        if [ "$PROTOCOL" = "tcp" ]; then
            result=$(netstat -tln | grep ":$PORT ")
        else
            result=$(netstat -uln | grep ":$PORT ")
        fi
    else
        echo "❌ Error: Neither 'ss' nor 'netstat' command found"
        exit 1
    fi

    if [ -n "$result" ]; then
        echo "✅ Port $PORT is OPEN (LISTENING)"
        echo ""
        echo "Details:"
        echo "$result"
    else
        echo "❌ Port $PORT is CLOSED (NOT LISTENING)"
    fi
else
    # Check remote host using nc or timeout
    if command -v nc &> /dev/null; then
        if nc -z -w 2 "$HOST" "$PORT" 2>/dev/null; then
            echo "✅ Port $PORT is OPEN on $HOST"
        else
            echo "❌ Port $PORT is CLOSED on $HOST"
        fi
    elif command -v timeout &> /dev/null; then
        if timeout 2 bash -c "cat < /dev/null > /dev/tcp/$HOST/$PORT" 2>/dev/null; then
            echo "✅ Port $PORT is OPEN on $HOST"
        else
            echo "❌ Port $PORT is CLOSED on $HOST"
        fi
    else
        echo "❌ Error: 'nc' (netcat) command not found"
        echo "Install it with: sudo apt install netcat"
        exit 1
    fi
fi
