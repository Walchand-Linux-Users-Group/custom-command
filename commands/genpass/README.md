# genpass

A custom command to generate secure random passwords.

## Description

`genpass` generates a random password of specified length using `/dev/urandom` for security. It includes uppercase, lowercase, numbers, and special characters.

## Usage

### First-time Installation
Run the script with sudo to install it globally:

```bash
sudo bash genpass.sh
```

This will copy the script to `/usr/bin/genpass` and make it executable.

### After Installation
Use the command directly:

```bash
genpass [length]
```

- `length`: Optional. The length of the password (default: 12). Must be a positive integer.

### Examples
- Generate a default 12-character password:
  ```bash
  genpass
  ```

- Generate a 16-character password:
  ```bash
  genpass 16
  ```

## Requirements
- Bash shell
- `/dev/urandom` (available on most Linux systems)
- Root privileges for installation

## Notes
- The password is printed to stdout. You can pipe it to other commands, e.g., `genpass | xclip` to copy to clipboard (if `xclip` is installed).
- For security, avoid using predictable lengths or reusing passwords.