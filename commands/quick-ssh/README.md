# ssh-connect

**Script name:** `ssh_access.sh`

---

## Description
A Bash script that automates the verification, setup, and interactive usage of SSH connections. It provides an easy-to-use menu to either connect to remote systems (like PCs or Termux-enabled Android devices) or search for files on the remote machine from your local terminal.

---

## Syntax
```bash
chmod +x ssh_access.sh
./ssh_access.sh
````

---

## Features of the custom command

**Feature 1: Automatic SSH Setup and Verification**
Checks for and installs necessary SSH components (`openssh-client` and `openssh-server`), enables the SSH service, and ensures readiness for remote connections.

**Feature 2: Direct Remote Terminal Access**
Allows instant connection to any remote device by interactively providing its username, IP address, and SSH port (e.g., `22` for PC, `8022` for Termux-enabled Android devices).

**Feature 3: Remote File Search by Name**
Executes a case-insensitive file search (`find` command) on the remote system based on a user-specified name and directory, displaying all matching paths and saving the results locally to `/tmp/ssh_search_results.txt`.

### Supported Distros
This command has been tested and works on:
- **Ubuntu 22.04** and above
- Debian-based systems (like **Linux Mint**)
- Termux on Android (with **openssh package** (use command **pkg install openssh**))



