recentdirs

Track and jump to recently visited directories.

Features
- Keep a timestamped history of directories you visit.
- List recent directories, fuzzy-select (via fzf) and print paths for use in scripts.
- Helper functions to enable rcd and a friendly recentdirs wrapper in your shell.
- Self-install/uninstall to /usr/bin/recentdirs for convenience.

Installation
- Install to /usr/bin (requires sudo):
  sudo recentdirs --install

- Add helper functions to your shell rc files (bash/zsh):
  recentdirs --setup-shell
  then restart your shell or run `source ~/.bashrc`.

Usage
  recentdirs --log            # log current PWD (used by helper)
  recentdirs --list           # show recent directories (newest first)
  recentdirs --select         # interactive chooser (uses fzf if available)
  recentdirs [N]             # print Nth recent entry (1 = newest)
  recentdirs <pattern>       # search and print a matching path

Helper functions
- rcd <dir>: cd to dir and log the destination.
- recentdirs (no args): opens selector.

Notes
- The script stores history in ${XDG_DATA_HOME:-$HOME/.local/share}/recentdirs/history.
- To automatically log every cd, you can alias cd to rcd in your shell rc (commented in helper).
- fzf is optional but highly recommended for interactive selection.

Dependencies
- coreutils, bash
- optional: fzf for interactive selection

Security
- This tool writes to your home directory only. It does not execute found paths.
