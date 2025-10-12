# portcheck

## Description
Network utility to check if specific TCP or UDP ports are open or closed on localhost or remote hosts with detailed status information.

## Syntax
```bash
portcheck [OPTIONS] <port> [host]
```

## Features of the custom command
- **Local Port Scanning**: Check ports on localhost using ss or netstat with detailed listening status
- **Remote Port Checking**: Verify port accessibility on remote hosts using netcat or bash TCP connections
- **Protocol Support**: Check both TCP (default) and UDP ports with `-t` and `-u` flags
- **Port Validation**: Automatically validates port numbers (1-65535) with error handling
- **Flexible Host Options**: Works with localhost, IP addresses, or domain names with automatic detection
