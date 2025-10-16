# docker-backup

**Script name:** `docker-backup.sh`

---

## Description
A shell script that automates the backup of **all named Docker volumes** for a specific container.  
It creates a compressed archive of the container’s volumes, making it easy to secure data or migrate containers safely.

---

## Installation

### 1. Make the script executable
```bash
chmod +x docker-backup.sh
chmod +x dockerbackup-installer.sh
```

### 2. Install
```bash
sudo ./dockerbackup-installer.sh
```

## Usage
```bash
./docker-backup.sh --container <container_name_or_id> [--output <directory>]
```

Options:

- --container : Name or ID of the container to back up. (required)

- --output : Directory where the backup file will be saved. Defaults to the current directory.

- --help : Displays usage information.

### Distributions
The script is tested on Kubuntu, a distribution based on Ubuntu.