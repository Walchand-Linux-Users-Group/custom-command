# Backup

Create compressed, timestamped backups of directories.

## Usage
```bash
backup <source_dir> [destination] [options]
```

### Options
- `--exclude <pattern>`: Exclude files/directories
- `--verbose, -v`: Detailed output
- `--check, -c`: Dry run
- `--help, -h`: Show help

## Features
- Timestamped archive: `{name}_{YYYY-MM-DD_HH-MM-SS}.tar.gz`
- Default destination: `$HOME/backups` (customizable)
- Exclude patterns supported
- Size and creation time reported
- Cleans up failed backups
- Cross-platform (Linux, macOS, WSL)

## Examples
```bash
backup ~/docs
backup ~/projects /media/backups
backup ~/myproject --exclude "node_modules" --exclude ".git"
backup ~/photos --verbose --exclude "*.tmp"
backup ~/code --check
```

## Install
```bash
chmod +x backup.sh
# Add to PATH or alias:
alias backup="/path/to/backup.sh"
```

## Notes
- Requires `tar` command
- Failed backups are auto-removed