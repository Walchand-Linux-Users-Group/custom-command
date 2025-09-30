# Finddup.sh

## Description

Find duplicate files in a directory by hashing their contents. Useful for cleaning up storage and identifying duplicate files.

## Syntax

```bash
chmod +x finddup.sh

./finddup.sh /path/to/directory
```

## Features
1] Computes SHA-256 hash for each file.<br/>
2] Defaults to current directory if no path is supplied.<br/>
3] Lists duplicates in pairs with file paths.<br/>
4] Self-installs to /usr/local/bin/finddup on first run.<br/>
<br/>