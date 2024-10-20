# Get IP Script

## Description

The `get_ip.sh` script allows you to fetch your public IP address using `curl` and logs it along with a timestamp and an optional description in a file named `iplog.txt` in your home directory. If `curl` is not installed, the script will automatically install it based on your operating system.

## Syntax
``` bash 
    curl ifconfig.me "Your description here"
```
## Features

1. Fetches your public IP using `curl ifconfig.me`.
2. Logs the IP with a timestamp in the format `YYYY-MM-DD HH:MM:SS`.
3. Appends the log entry to `~/iplog.txt` in your home directory.
4. Accepts an optional description to log along with the IP.
5. Installs `curl` automatically if it's not present, using the appropriate package manager (supports Debian/Ubuntu, Red Hat/CentOS, Arch Linux, and Alpine Linux).

## Installation

To make the script executable, use the following command:

```bash
chmod +x get_ip.sh
