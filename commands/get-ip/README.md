# Get IP Script

## Description

A lightweight, feature-rich Bash command that logs the machine’s public IP (with timestamp), gathers optional geolocation/ISP and local network info, and provides search, history and statistics capabilities with automatic log rotation.

## Syntax
``` bash 
# Basic log with description
./get-ip.sh "Daily morning check"

# Search logs
./get-ip.sh --search "VPN"

# Show history or stats
./get-ip.sh --history
./get-ip.sh --stats

# Show recent entries or use custom file
./get-ip.sh --recent 
./get-ip.sh --file /var/log/my_iplog.txt "Custom location"

```
## Features

1. **Reliable public IP detection:** Tries multiple public IP services (fallbacks) and validates the result before logging.
2. **Rich contextual logging:** Records timestamp, description, public IP, IP geolocation/ISP (when available) and local network details (interface, local IP, gateway, MAC).
3. **Log management & analysis:** Automatic log rotation when the file exceeds a size threshold, plus built-in search, IP-change history and summary statistics.

## Installation

To make the script executable, use the following command:

```bash
chmod +x get-ip.sh
./get-ip.sh "Your description here"

```