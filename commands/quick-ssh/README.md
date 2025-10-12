# ssh-connect

## Description
`ssh-connect` is a Bash script that automates the setup and usage of SSH for connecting to remote systems (like PCs or Android devices via Termux).  
It also provides an easy-to-use interactive menu to either directly access the remote terminal or search for files on the remote machine — all from your local terminal.

---

## Syntax
```bash
./ssh-connect.sh

The script will guide you through:

Verifying and installing required SSH components.

Taking remote connection details (username, IP, port).

Providing an interactive menu to open an SSH session or search for files on the remote system.

Features of the Custom Command
Feature 1: Automatic SSH Setup and Verification

The script automatically checks if SSH is installed and running on your system.

If not, it installs openssh-client and openssh-server, enables the SSH service, and ensures readiness for remote connections.

Feature 2: Direct Remote Terminal Access

Connect instantly to any remote device using its IP address, username, and SSH port (e.g., 22 for PC, 8022 for Android Termux).

Eliminates the need to manually type the SSH command each time.

Feature 3: Remote File Search by Name

Allows searching for files by name on the remote system using the find command.

Supports case-insensitive search across the specified directory (defaults to /home/<user> if left blank).

Displays all matching file paths and saves results locally in /tmp/ssh_search_results.txt.