#!/bin/bash

LOG_FILE=~/iplog.txt
MAX_LOG_SIZE=10485760  
BACKUP_COUNT=5


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' 


print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARN]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_debug() { echo -e "${BLUE}[DEBUG]${NC} $1"; }


rotate_log_if_needed() {
    if [ -f "$LOG_FILE" ] && [ $(stat -f%z "$LOG_FILE" 2>/dev/null || stat -c%s "$LOG_FILE" 2>/dev/null) -gt $MAX_LOG_SIZE ]; then
        print_warning "Log file exceeds size limit, rotating..."
        
        for i in $(seq $((BACKUP_COUNT-1)) -1 1); do
            [ -f "${LOG_FILE}.$i" ] && mv "${LOG_FILE}.$i" "${LOG_FILE}.$((i+1))"
        done
        
        mv "$LOG_FILE" "${LOG_FILE}.1"
        print_status "Log file rotated successfully"
    fi
}


get_public_ip() {
    local ip_services=(
        "ifconfig.me"
        "ipinfo.io/ip"
        "api.ipify.org"
        "icanhazip.com"
        "ident.me"
    )
    
    for service in "${ip_services[@]}"; do
        print_debug "Trying IP service: $service"
        ip=$(curl -s --connect-timeout 5 "$service")
        
        
        if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            print_status "Successfully obtained IP from $service"
            echo "$ip"
            return 0
        fi
    done
    
    print_error "All IP services failed"
    return 1
}


get_ip_info() {
    local ip="$1"
    print_status "Fetching additional IP information..."
    
    
    if info=$(curl -s --connect-timeout 5 "ipinfo.io/$ip/json" 2>/dev/null); then
        city=$(echo "$info" | grep '"city"' | cut -d'"' -f4)
        region=$(echo "$info" | grep '"region"' | cut -d'"' -f4)
        country=$(echo "$info" | grep '"country"' | cut -d'"' -f4)
        org=$(echo "$info" | grep '"org"' | cut -d'"' -f4)
        
        echo "Location: $city, $region, $country | ISP: $org"
    else
        echo "Additional info: Not available"
    fi
}


get_local_network_info() {
    print_status "Gathering local network information..."
    
    
    local interface=$(ip route | grep default | awk '{print $5}' | head -1)
    
    if [ -n "$interface" ]; then
        local_ip=$(ip addr show "$interface" 2>/dev/null | grep -w inet | awk '{print $2}' | cut -d/ -f1 | head -1)
        gateway=$(ip route | grep default | awk '{print $3}' | head -1)
        mac_address=$(ip link show "$interface" 2>/dev/null | grep -oE 'link/ether [0-9a-f:]+' | cut -d' ' -f2)
        
        echo "Interface: $interface | Local IP: $local_ip | Gateway: $gateway | MAC: $mac_address"
    else
        echo "Local network: Not available"
    fi
}


search_logs() {
    local search_term="$1"
    print_status "Searching logs for: '$search_term'"
    
    if [ -f "$LOG_FILE" ]; then
        local results=$(grep -i "$search_term" "$LOG_FILE")
        if [ -n "$results" ]; then
            echo "$results"
        else
            print_warning "No matches found for '$search_term'"
        fi
    else
        print_error "Log file not found: $LOG_FILE"
    fi
}


show_ip_history() {
    print_status "IP Change History:"
    if [ -f "$LOG_FILE" ]; then
        
        grep "Public IP:" "$LOG_FILE" | awk -F'Public IP: ' '{print $2}' | awk '{print $1}' | sort | uniq -c | sort -nr
    else
        print_error "Log file not found: $LOG_FILE"
    fi
}


show_stats() {
    print_status "Log Statistics:"
    if [ -f "$LOG_FILE" ]; then
        total_entries=$(grep -c "Public IP:" "$LOG_FILE")
        unique_ips=$(grep "Public IP:" "$LOG_FILE" | awk -F'Public IP: ' '{print $2}' | awk '{print $1}' | sort -u | wc -l)
        first_entry=$(grep "Timestamp:" "$LOG_FILE" | head -1 | cut -d' ' -f2-)
        last_entry=$(grep "Timestamp:" "$LOG_FILE" | tail -1 | cut -d' ' -f2-)
        
        echo "Total entries: $total_entries"
        echo "Unique IPs: $unique_ips"
        echo "First log: $first_entry"
        echo "Last log: $last_entry"
        echo "Log file: $LOG_FILE ($(du -h "$LOG_FILE" | cut -f1))"
    else
        print_error "Log file not found: $LOG_FILE"
    fi
}


show_recent() {
    local count=${1:-5}
    print_status "Last $count log entries:"
    
    if [ -f "$LOG_FILE" ]; then
        
        tac "$LOG_FILE" | awk '
            /^=== IP Log Entry ===/ { if (entry) { print entry; count++ } entry=""; if (count >= '"$count"') exit }
            { entry = $0 "\n" entry }
        ' | tac
    else
        print_error "Log file not found: $LOG_FILE"
    fi
}


log_ip() {
    local description="$1"
    
    
    if ! command -v curl &> /dev/null; then
        print_error "curl is not installed. Installing curl..."
        
        
        if [ -f /etc/debian_version ]; then
            sudo apt update && sudo apt install -y curl
        elif [ -f /etc/redhat-release ]; then
            sudo yum install -y curl
        elif [ -f /etc/arch-release ]; then
            sudo pacman -S --noconfirm curl
        elif [ -f /etc/alpine-release ]; then
            sudo apk add --no-cache curl
        else
            print_error "Unsupported operating system. Please install curl manually."
            exit 1
        fi
    fi

    
    rotate_log_if_needed

    
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    
    print_status "Fetching public IP address..."
    local ip=$(get_public_ip)
    
    if [ -z "$ip" ]; then
        print_error "Failed to retrieve public IP address"
        exit 1
    fi

    
    local ip_info=$(get_ip_info "$ip")
    local network_info=$(get_local_network_info)

    
    {
        echo "=== IP Log Entry ==="
        echo "Timestamp: $timestamp"
        echo "Description: $description"
        echo "Public IP: $ip"
        echo "IP Info: $ip_info"
        echo "Network: $network_info"
        echo ""
    } >> "$LOG_FILE"

    
    print_status "IP logging completed successfully!"
    echo "Public IP: $ip"
    echo "Description: $description"
    echo "Additional Info: $ip_info"
    echo "Network Info: $network_info"
    echo "Log file: $LOG_FILE"
}


show_usage() {
    echo "Enhanced IP Logger - Version 2.0"
    echo "Usage: $0 [OPTIONS] [DESCRIPTION]"
    echo ""
    echo "Options:"
    echo "  DESCRIPTION          Log IP with description (main functionality)"
    echo "  --search TERM        Search logs for specific term"
    echo "  --history            Show IP change history"
    echo "  --stats              Show logging statistics"
    echo "  --recent [COUNT]     Show recent log entries (default: 5)"
    echo "  --file FILE          Use custom log file (default: ~/iplog.txt)"
    echo "  -h, --help          Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 \"Daily check\""
    echo "  $0 \"After router reboot\""
    echo "  $0 --search \"192.168\""
    echo "  $0 --history"
    echo "  $0 --stats"
    echo "  $0 --recent 10"
    echo "  $0 --file /var/log/iplog.txt \"Custom location\""
}


main() {
    case "$1" in
        -h|--help)
            show_usage
            exit 0
            ;;
        --search)
            search_logs "$2"
            exit 0
            ;;
        --history)
            show_ip_history
            exit 0
            ;;
        --stats)
            show_stats
            exit 0
            ;;
        --recent)
            show_recent "$2"
            exit 0
            ;;
        --file)
            LOG_FILE="$2"
            shift 2
            ;;
        -*)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
        *)
            if [ $# -eq 0 ]; then
                print_error "Please provide a description or option"
                show_usage
                exit 1
            else
                log_ip "$1"
            fi
            ;;
    esac
}


cleanup() {
    print_status "Script interrupted. Cleaning up..."
    exit 0
}

trap cleanup INT TERM


main "$@"