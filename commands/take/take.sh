#!/usr/bin/env bash
# take - jump to a directory by name (searches upward then downward)
# Usage:
#   source take.sh <name>
#   . take.sh <name>
#   take <name>        # after installing or using cd "$(take name)"
# Options:
#   --install / --uninstall
#   --help

set -euo pipefail

SELF_PATH="$(realpath "$0")"
INSTALL_PATH="/usr/bin/take"

show_help(){
    cat <<'EOF'
Usage: take <dir-name>

Search upward from the current directory for an ancestor directory named <dir-name>.
If not found, search downward (recursively) from the current directory for matching directories.
If still not found, take will search the entire filesystem starting at / (may be slow).

If the script is sourced ("source take.sh name" or ". take.sh name"), it will change the current shell's directory directly.
If executed normally it will print the found path on stdout (so you can `cd "$(take name)"`).

Options:
  -g, --global   search from / (root) immediately instead of local search
  -a,--all       when searching downward print all matches (instead of choosing one)
  --install      install this script to /usr/bin/take (requires sudo)
  --uninstall    remove /usr/bin/take (requires sudo)
  --setup-shell  append a small shell helper function to your shell rc so `take name` will cd directly
  --internal     internal mode (prints only path; used by helper function)
  --help         show this message

Examples:
  # source to change your shell's directory immediately
  source take.sh projects

  # after installing, use directly (you may first run --setup-shell once)
  take projects
  cd "$(take projects)"

EOF
}

# Auto-install when run as root for convenience (mirrors other scripts in this repo)
if [ "$EUID" -eq 0 ] && [ "$(realpath "$0")" != "$INSTALL_PATH" ]; then
    if [ ! -f "$INSTALL_PATH" ]; then
        cp -f "$SELF_PATH" "$INSTALL_PATH"
        chmod +x "$INSTALL_PATH"
        echo "take auto-installed to $INSTALL_PATH"
        exit 0
    fi
fi

# handle install/uninstall when invoked directly
if [ "${1:-}" = "--install" ]; then
    if [ "$EUID" -ne 0 ]; then
        echo "Installation requires sudo. Re-run with sudo." >&2
        exit 1
    fi
    cp -f "$SELF_PATH" "$INSTALL_PATH"
    chmod +x "$INSTALL_PATH"
    echo "Installed to $INSTALL_PATH"
    exit 0
fi
if [ "${1:-}" = "--uninstall" ]; then
    if [ "$EUID" -ne 0 ]; then
        echo "Uninstallation requires sudo. Re-run with sudo." >&2
        exit 1
    fi
    if [ -f "$INSTALL_PATH" ]; then
        rm -f "$INSTALL_PATH" && echo "Removed $INSTALL_PATH" || true
    else
        echo "$INSTALL_PATH not found"
    fi
    exit 0
fi
if [ "${1:-}" = "--setup-shell" ]; then
    # append helper to user's shell rc files
    HOME_RC_BASH="$HOME/.bashrc"
    HOME_RC_ZSH="$HOME/.zshrc"
    helper_marker="# take helper (auto-added by take.sh)"
    helper_fn='take() { local _t; _t="$(/usr/bin/take --internal "$@" 2>/dev/null)"; if [ -n "$_t" ]; then cd "$_t" || return 1; else echo "take: not found" >&2; fi }'

    for rc in "$HOME_RC_BASH" "$HOME_RC_ZSH"; do
        if [ -f "$rc" ]; then
            if ! grep -Fq "$helper_marker" "$rc"; then
                printf "\n%s\n%s\n" "$helper_marker" "$helper_fn" >> "$rc"
                echo "Appended helper to $rc"
            else
                echo "Helper already present in $rc"
            fi
        else
            # create bashrc if missing
            printf "%s\n%s\n" "$helper_marker" "$helper_fn" >> "$rc"
            echo "Created $rc with helper"
        fi
    done
    echo "Restart your shell or source your rc file to start using 'take <name>' directly."
    exit 0
fi

# parse options
ALL_MATCHES=0
GLOBAL_SEARCH=0
INTERNAL_MODE=0
if [ "${1:-}" = "-a" ] || [ "${1:-}" = "--all" ]; then
    ALL_MATCHES=1
    shift || true
fi
if [ "${1:-}" = "-g" ] || [ "${1:-}" = "--global" ]; then
    GLOBAL_SEARCH=1
    shift || true
fi
if [ "${1:-}" = "--internal" ]; then
    INTERNAL_MODE=1
    shift || true
fi
if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
    show_help; exit 0
fi

if [ $# -lt 1 ]; then
    show_help; exit 1
fi
NAME="$1"

# helper: detect if script is sourced
is_sourced() {
    # In bash, if BASH_SOURCE[0] != $0 then the file is sourced
    [ "${BASH_SOURCE[0]:-}" != "$0" ]
}

# if argument is an absolute or relative existing directory, use it
if [ -d "$NAME" ]; then
    TARGET="$(realpath "$NAME")"
    if is_sourced; then
        cd "$TARGET" || return 1
        return 0
    else
        printf "%s\n" "$TARGET"
        exit 0
    fi
fi

lower_name=$(printf "%s" "$NAME" | tr '[:upper:]' '[:lower:]')

# 1) search upward for ancestor directory whose basename matches name (case-insensitive)
cur="$PWD"
found_up=""
while [ "$cur" != "/" ] && [ -n "$cur" ]; do
    base=$(basename "$cur")
    base_l=$(printf "%s" "$base" | tr '[:upper:]' '[:lower:]')
    if [ "$base_l" = "$lower_name" ]; then
        found_up="$cur"
        break
    fi
    cur=$(dirname "$cur")
done

if [ -n "$found_up" ]; then
    if is_sourced; then
        cd "$found_up" || return 0
        return 0
    else
        printf "%s\n" "$found_up"
        exit 0
    fi
fi

# 2) search downward from current directory for directories matching name (case-insensitive, partial)
# use find and prefer the shallowest result
if [ "$GLOBAL_SEARCH" -eq 1 ]; then
    # search from root immediately
    mapfile -t candidates < <(find / -type d -iname "*${NAME}*" \
        -not -path "/proc/*" -not -path "/sys/*" -not -path "/dev/*" -not -path "/run/*" \
        -not -path "/tmp/*" -not -path "/var/run/*" -not -path "/var/tmp/*" 2>/dev/null | sed 's|^/||')
else
    mapfile -t candidates < <(find . -type d -iname "*${NAME}*" 2>/dev/null | sed 's|^./||')
fi

if [ ${#candidates[@]} -eq 0 ]; then
    # try case-insensitive using lowercased pattern locally
    if [ "$GLOBAL_SEARCH" -eq 0 ]; then
        mapfile -t candidates < <(find . -type d 2>/dev/null | while read -r p; do
            bn=$(basename "$p")
            if [ "$(printf '%s' "$bn" | tr '[:upper:]' '[:lower:]')" = "$lower_name" ] || \
               echo "$bn" | tr '[:upper:]' '[:lower:]' | grep -F -q "$lower_name" 2>/dev/null; then
               echo "${p#./}"
            fi
        done)
    fi
fi

# If still empty, fall back to searching from root (may be slow). This honors ALL_MATCHES.
if [ ${#candidates[@]} -eq 0 ]; then
    mapfile -t candidates < <(find / -type d -iname "*${NAME}*" \
        -not -path "/proc/*" -not -path "/sys/*" -not -path "/dev/*" -not -path "/run/*" \
        -not -path "/tmp/*" -not -path "/var/run/*" -not -path "/var/tmp/*" 2>/dev/null | sed 's|^/||')
fi

if [ ${#candidates[@]} -eq 0 ]; then
    echo "No directory found matching: $NAME" >&2
    exit 2
fi

if [ "$ALL_MATCHES" -eq 1 ]; then
    for c in "${candidates[@]}"; do
        realp="$(realpath "$c")"
        printf "%s\n" "$realp"
    done
    exit 0
fi

# choose shallowest candidate (fewest path components)
best=""
best_depth=99999
for c in "${candidates[@]}"; do
    # normalize path (strip leading ./)
    p="${c#./}"
    # compute depth
    depth=$(awk -F"/" '{print NF}' <<< "$p")
    if [ $depth -lt $best_depth ]; then
        best_depth=$depth
        best="$p"
    fi
done

TARGET="$(realpath "$best")"

if is_sourced; then
    cd "$TARGET" || return 1
    return 0
else
    # if internal mode just print path
    if [ "$INTERNAL_MODE" -eq 1 ]; then
        printf "%s\n" "$TARGET"
        exit 0
    fi

    # If helper is installed at /usr/bin/take we will still print the path so that the helper can change directory.
    # But for user convenience, if this script is run directly and stdout is a terminal, change the directory in a subshell
    # and print the path. Note: an executing script cannot change its parent's cwd, so users should either source this
    # script or use the helper function created by --setup-shell.

    printf "%s\n" "$TARGET"

    # If helper isn't present, and we're in an interactive terminal, append the helper to ~/.bashrc and ~/.zshrc
    if [ -t 1 ]; then
        helper_marker="# take helper (auto-added by take.sh)"
        helper_fn='take() { local _t; _t="$(/usr/bin/take --internal "$@" 2>/dev/null)"; if [ -n "$_t" ]; then cd "$_t" || return 1; else echo "take: not found" >&2; fi }'
        need_install=1
        for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
            if [ -f "$rc" ] && grep -Fq "$helper_marker" "$rc"; then
                need_install=0
                break
            fi
        done
        if [ $need_install -eq 1 ]; then
            for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
                if [ -f "$rc" ]; then
                    printf "\n%s\n%s\n" "$helper_marker" "$helper_fn" >> "$rc"
                    echo "Added take helper to $rc"
                else
                    printf "%s\n%s\n" "$helper_marker" "$helper_fn" >> "$rc"
                    echo "Created $rc with take helper"
                fi
            done
            echo "Run 'source ~/.bashrc' (or restart your shell) to enable direct 'take <name>' behavior." >&2
        fi

        # Helpful immediate workaround: show the command to change directory now
        printf "To change directory right now run:\n  cd \"%s\"\n" "$TARGET" >&2
    fi
    exit 0
fi
