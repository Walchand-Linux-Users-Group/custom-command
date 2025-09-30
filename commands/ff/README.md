# FF.sh

## Description

Fuzzy finder for files. Quickly locate files interactively in any directory using the terminal.

## Syntax

```bash
chmod +x ff.sh

./ff.sh /path/to/directory
```

## Features
1] Uses fzf for interactive fuzzy search.<br/>
2] Defaults to current directory if no path is supplied.<br/>
3] Self-installs to /usr/local/bin/ff on first run.<br/>
4] Auto-installs fzf if missing, detecting the package manager.<br/>
5] Prints the selected file path.<br/>
<br/>