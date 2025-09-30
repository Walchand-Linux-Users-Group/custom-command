# Findbig

---

## Description
Find and list the largest files in a directory. This command helps identify files that are taking up the most disk space, making it useful for disk cleanup and storage management.

---

## Syntax
```bash
./findbig.sh [directory] [size_limit]
```

**Parameters:**
- `directory` (optional): Directory to search in. Defaults to current directory (`.`)
- `size_limit` (optional): Minimum file size to search for. Defaults to `50M` (50 MB)

**Examples:**
```bash
# Find files larger than 50MB in current directory
./findbig.sh

# Find files larger than 50MB in /home/user directory
./findbig.sh /home/user

# Find files larger than 100MB in current directory
./findbig.sh . 100M

# Find files larger than 1GB in /var/log directory
./findbig.sh /var/log 1G
```

## Features of the custom command

- **Flexible directory search**: Search in any specified directory or current directory by default
- **Customizable size threshold**: Set minimum file size using standard units (K, M, G)
- **Top 10 results**: Shows only the 10 largest files to avoid overwhelming output
- **Human-readable sizes**: Displays file sizes in easy-to-read format (KB, MB, GB)
- **Error handling**: Validates directory existence before searching
- **Sorted output**: Files are sorted by size in descending order (largest first)

---