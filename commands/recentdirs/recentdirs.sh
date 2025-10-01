#!/usr/bin/env bash
# recentdirs - track and jump to recently visited directories
# Usage:
#   recentdirs --log                # log current PWD (internal)
#   recentdirs --list               # show recent directories
#   recentdirs --select             # interactive selector (uses fzf if present)
#   recentdirs [N]                  # print Nth recent entry (1 = newest)
#   recentdirs <pattern>            # search and print a matching path
#   recentdirs --setup-shell        # append shell helper functions to rc files
#   recentdirs --install/--uninstall

set -euo pipefail

SELF_PATH="$(realpath "$0")"
INSTALL_PATH="/usr/bin/recentdirs"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/recentdirs"
HISTORY_FILE="$DATA_DIR/history"
MAX_ENTRIES=1000

show_help(){
    cat <<'EOF'
recentdirs - track and jump to recently visited directories

Usage:
  recentdirs --log              # append current directory to history (used by helper)
  recentdirs --list             # show recent directories (newest first)
  recentdirs --select           # interactive chooser (uses fzf if available)
  recentdirs [N]               # print nth recent entry (1 = newest)
  recentdirs <pattern>         # search for a directory containing <pattern>
  recentdirs --setup-shell     # append helper functions to ~/.bashrc and ~/.zshrc
  recentdirs --install/--uninstall

Examples:
  recentdirs --select           # pick a directory and print its path
  cd "$(recentdirs 1)"         # go to most recent directory
  rcd projects                  # if helper installed, uses rcd to cd+log

Notes:
  - History is stored in $DATA_DIR/history with timestamps.
  - To make direct `recentdirs <name>` change your shell directory, run
    `recentdirs --setup-shell` and restart or source your shell rc.
EOF
}

# Auto-install when run as root for convenience
if [ "${EUID:-0}" -eq 0 ] && [ "$(realpath "$0")" != "$INSTALL_PATH" ]; then
    if [ ! -f "$INSTALL_PATH" ]; then
        cp -f "$SELF_PATH" "$INSTALL_PATH"
        chmod +x "$INSTALL_PATH" || true
        echo "recentdirs auto-installed to $INSTALL_PATH"
        exit 0
    fi
fi

# handle install/uninstall
if [ "${1:-}" = "--install" ]; then
    if [ "${EUID:-0}" -ne 0 ]; then
        echo "Installation requires sudo. Re-run with sudo." >&2; exit 1
    fi
    mkdir -p "$(dirname "$INSTALL_PATH")"
    cp -f "$SELF_PATH" "$INSTALL_PATH"
    chmod +x "$INSTALL_PATH" || true
    echo "Installed to $INSTALL_PATH"
    exit 0
fi
if [ "${1:-}" = "--uninstall" ]; then
    if [ "${EUID:-0}" -ne 0 ]; then
        echo "Uninstallation requires sudo. Re-run with sudo." >&2; exit 1
    fi
    if [ -f "$INSTALL_PATH" ]; then rm -f "$INSTALL_PATH" && echo "Removed $INSTALL_PATH" || true; else echo "$INSTALL_PATH not found"; fi
    exit 0
fi

# Ensure data dir exists
mkdir -p "$DATA_DIR"
touch "$HISTORY_FILE"

# helpers
trim_history(){
    # keep only the last $MAX_ENTRIES lines
    if [ -f "$HISTORY_FILE" ]; then
        tail -n $MAX_ENTRIES "$HISTORY_FILE" > "$HISTORY_FILE.tmp" || true
        mv "$HISTORY_FILE.tmp" "$HISTORY_FILE" || true
    fi
}

log_dir(){
    local dir="${1:-$PWD}"
    dir="$(realpath "$dir")" || return 1
    # avoid consecutive duplicates
    local last
    last=$(tail -n1 "$HISTORY_FILE" 2>/dev/null || true)
    if [ "$last" != "$dir" ]; then
        printf "%s\t%s\n" "$(date +%s)" "$dir" >> "$HISTORY_FILE"
        trim_history
    fi
}

list_entries(){
    # print newest first with index
    tac "$HISTORY_FILE" 2>/dev/null | nl -v1 -w3 -s": " | awk -F"\t" '{print $1 "  " strftime("%Y-%m-%d %H:%M:%S", $1) "  " $2}' 2>/dev/null || true
}

print_nth(){
    local n=${1}
    if ! printf "%s" "$n" | grep -Eq '^[0-9]+$'; then return 1; fi
    # convert to line number in file (1 = newest)
    local line
    line=$(tac "$HISTORY_FILE" | sed -n "${n}p" || true)
    if [ -z "$line" ]; then return 2; fi
    awk -F"\t" '{print $2}' <<< "$line"
}

search_pattern(){
    local pat="$1"
    tac "$HISTORY_FILE" | awk -F"\t" '{print $2}' | grep -i --color=never -F "$pat" | awk '!seen[$0]++' || true
}

select_interactive(){
    # prefer fzf if available
    local chosen
    if command -v fzf >/dev/null 2>&1; then
        # present: timestamp | path
        chosen=$(tac "$HISTORY_FILE" | awk -F"\t" '{printf "%s\t%s\n", strftime("%Y-%m-%d %H:%M:%S", $1), $2}' | fzf --ansi --tac --height=40% --reverse --prompt="recentdirs> " | awk -F"\t" '{print $2}')
    else
        # fallback: simple numbered menu
        nl -w3 -s": " -ba < <(tac "$HISTORY_FILE" | awk -F"\t" '{print $2}')
        printf "Choose number: " >&2
        read -r idx
        chosen=$(print_nth "$idx" 2>/dev/null || true)
    fi
    if [ -n "$chosen" ]; then
        printf "%s\n" "$chosen"
        return 0
    fi
    return 1
}

# Setup helper in shell rc files
if [ "${1:-}" = "--setup-shell" ]; then
    helper_marker="# recentdirs helper (auto-added by recentdirs)"
    helper_fn='recentdirs() { if [ "$#" -eq 0 ]; then /usr/bin/recentdirs --select; return 0; fi; case "$1" in --log) /usr/bin/recentdirs --log ;; --list) /usr/bin/recentdirs --list ;; --select) /usr/bin/recentdirs --select ;; *) /usr/bin/recentdirs --select "$@" ;; esac }\n\nrcd() { cd "$@" && /usr/bin/recentdirs --log; }\n\n# If you prefer to automatically log every cd, uncomment the following line:\n# alias cd=rcd'

    for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
        if [ -f "$rc" ]; then
            if ! grep -Fq "$helper_marker" "$rc"; then
                printf "\n%s\n%s\n" "$helper_marker" "$helper_fn" >> "$rc"
                echo "Appended helper to $rc"
            else
                echo "Helper already present in $rc"
            fi
        else
            printf "%s\n%s\n" "$helper_marker" "$helper_fn" >> "$rc"
            echo "Created $rc with helper"
        fi
    done
    echo "Restart your shell or run 'source ~/.bashrc' to use the 'recentdirs' helper and the 'rcd' function." >&2
    exit 0
fi

# parse options
case "${1:-}" in
    --help|-h)
        show_help; exit 0;;
    --log)
        log_dir "${2:-$PWD}"; exit 0;;
    --list)
        list_entries; exit 0;;
    --select|--fzf)
        select_interactive; exit $?;;
    --install|--uninstall|--setup-shell)
        # handled earlier
        ;;
esac

# If no args: show list
if [ $# -eq 0 ]; then
    list_entries
    exit 0
fi

# If numeric single arg: print nth
if printf "%s" "$1" | grep -Eq '^[0-9]+$'; then
    print_nth "$1"
    exit $?
fi

# If single arg, treat as pattern search and print first match
if [ $# -eq 1 ]; then
    pat="$1"
    # try exact match first
    match=$(search_pattern "$pat" | head -n1 || true)
    if [ -n "$match" ]; then
        printf "%s\n" "$match"
        exit 0
    fi
    # fallback to interactive selector filtered by pattern
    if command -v fzf >/dev/null 2>&1; then
        tac "$HISTORY_FILE" | awk -F"\t" '{print $2}' | grep -i --color=never -F "$pat" | awk '!seen[$0]++' | fzf --height=40% --reverse --prompt="recentdirs> " | awk '{print $0}'
        exit 0
    else
        # show matches and print first
        tac "$HISTORY_FILE" | awk -F"\t" '{print $2}' | grep -i --color=never -F "$pat" | awk '!seen[$0]++' | head -n1
        exit 0
    fi
fi

# default
show_help
exit 1
