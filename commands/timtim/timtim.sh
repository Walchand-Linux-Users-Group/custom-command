#!/usr/bin/env bash
# timtim - A cinematic, flicker-free, and accurate ASCII art terminal timer.
#
# Usage: timtim [DURATION] [--title "Message"] [--install] [--uninstall]
# Examples:
#   timtim 90
#   timtim 1:30 --title "Focus Session"
#   timtim --install

set -euo pipefail

SELF_PATH="$(realpath "$0")"
INSTALL_PATH="/usr/bin/timtim"

# --- AUTO-INSTALL LOGIC ---
# If the script is run with sudo and isn't already installed, install it.
if [ "$EUID" -eq 0 ] && [ "$SELF_PATH" != "$INSTALL_PATH" ]; then
    if [ ! -f "$INSTALL_PATH" ]; then
        echo "First time running with sudo. Auto-installing..."
        cp -f "$SELF_PATH" "$INSTALL_PATH"
        chmod +x "$INSTALL_PATH"
        echo "timtim has been installed to $INSTALL_PATH"
        echo "You can now run the command directly: timtim 90"
        exit 0
    fi
fi
# --- END AUTO-INSTALL ---

# --- HELPERS ---
show_help(){
    cat <<'EOF'
Usage: timtim [duration] [options]

A cinematic, flicker-free, and accurate ASCII art terminal timer.

duration:
  Seconds (e.g. 90) or MM:SS (e.g. 01:30). Defaults to 60 seconds.

options:
  --title "TEXT"   Set a title shown above the timer (default: timtim).
  --install        Copy this script to /usr/bin/timtim (requires sudo).
  --uninstall      Remove /usr/bin/timtim (requires sudo).
  --width N        Width for ASCII numbers when using figlet (default: 80).
  -h, --help       Show this help.

Dependencies (optional): figlet, lolcat
If figlet is missing, a simple fallback is used. If lolcat is present, it adds color.
EOF
}

# --- ARGUMENT PARSING ---
DURATION_RAW=""
TITLE="timtim"
WIDTH=80

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help; exit 0;;
        --title)
            if [ -z "${2:-}" ]; then echo "Error: --title requires an argument." >&2; exit 1; fi
            TITLE="$2"; shift 2;;
        --width)
            if [ -z "${2:-}" ]; then echo "Error: --width requires an argument." >&2; exit 1; fi
            WIDTH="$2"; shift 2;;
        --install)
            if [ "$EUID" -ne 0 ]; then echo "Error: Installation requires sudo." >&2; exit 1; fi
            cp -f "$SELF_PATH" "$INSTALL_PATH"
            chmod +x "$INSTALL_PATH"
            echo "Installed successfully to $INSTALL_PATH"
            exit 0;;
        --uninstall)
            if [ "$EUID" -ne 0 ]; then echo "Error: Uninstallation requires sudo." >&2; exit 1; fi
            if [ -f "$INSTALL_PATH" ]; then rm -f "$INSTALL_PATH"; echo "Uninstalled."; else echo "Not found."; fi
            exit 0;;
        -* )
            echo "Unknown option: $1" >&2; show_help; exit 1;;
        *)
            if [ -n "$DURATION_RAW" ]; then echo "Error: Duration already set." >&2; exit 1; fi
            DURATION_RAW="$1"; shift;;
    esac
done

# --- DURATION LOGIC ---
DURATION=60 # Default duration
if [ -n "$DURATION_RAW" ]; then
    if [[ "$DURATION_RAW" == *":"* ]]; then
        IFS=":" read -r MM SS <<< "$DURATION_RAW"
        MM=${MM:-0}; SS=${SS:-0} # handle empty values like :30 or 1:
        if ! [[ $MM =~ ^[0-9]+$ && $SS =~ ^[0-9]+$ && $SS -lt 60 ]]; then
            echo "Invalid time format. Use seconds or MM:SS (e.g., 01:30)." >&2; exit 1
        fi
        DURATION=$((10#$MM * 60 + 10#$SS))
    else
        if ! [[ $DURATION_RAW =~ ^[0-9]+$ ]]; then
            echo "Invalid duration. Use an integer for seconds." >&2; exit 1
        fi
        DURATION=$DURATION_RAW
    fi
fi

# --- DEPENDENCY & TERMINAL SETUP ---
HAS_FIGLET=0; HAS_LOLCAT=0
if command -v figlet &>/dev/null; then HAS_FIGLET=1; fi
if command -v lolcat &>/dev/null; then HAS_LOLCAT=1; fi

cleanup(){
    tput cnorm # Restore cursor visibility
}
trap cleanup EXIT

# --- DRAWING LOGIC ---
print_frame(){
    local remaining=$1
    local total=$2
    local mins=$((remaining/60))
    local secs=$((remaining%60))
    local time_str
    time_str=$(printf "%02d:%02d" "$mins" "$secs")

    local art
    if [ "$HAS_FIGLET" -eq 1 ]; then
        art=$(figlet -w "$WIDTH" -f big "$time_str" 2>/dev/null || figlet -w "$WIDTH" "$time_str")
    else
        art="$time_str"
    fi

    local title_art
    if [ "$HAS_FIGLET" -eq 1 ]; then
        title_art=$(figlet -w "$WIDTH" -f standard "$TITLE" 2>/dev/null || echo "$TITLE")
    else
        title_art="$TITLE"
    fi

    local pct=0
    if [ "$total" -gt 0 ]; then
        pct=$(( (total - remaining) * 100 / total ))
        if [ $pct -gt 100 ]; then pct=100; fi
    fi
    local bar_width=48
    local filled=$((pct * bar_width / 100))
    local empty=$((bar_width - filled))
    local bar="["$(printf '%0.s#' $(seq 1 $filled))$(printf '%0.s-' $(seq 1 $empty))"] $pct%"

    local out="\n$title_art\n\n$art\n\n  $bar\n  Remaining: $time_str\n"

    tput cup 0 0
    if [ "$HAS_LOLCAT" -eq 1 ]; then
        printf "%s" "$out" | lolcat
    else
        printf "%s" "$out"
    fi
}

# --- MAIN LOOP ---
tput civis # Hide cursor
tput clear # Initial clear

end_ts=$(( $(date +%s) + DURATION ))
while true; do
    now_ts=$(date +%s)
    remaining=$(( end_ts - now_ts ))
    if [ $remaining -lt 0 ]; then remaining=0; fi

    print_frame "$remaining" "$DURATION"

    if [ "$remaining" -le 0 ]; then break; fi
    sleep 1
done

# --- FINISH ---
tput cup 0 0; tput ed # Clear screen for final message
if [ "$HAS_FIGLET" -eq 1 ]; then
    final_msg=$(figlet -w "$WIDTH" -f standard "TIME UP!")
else
    final_msg="\n*** TIME UP! ***\n"
fi

if [ "$HAS_LOLCAT" -eq 1 ]; then
    printf "%s" "$final_msg" | lolcat
else
    printf "%s\n" "$final_msg"
fi

printf "\a" # Beep
exit 0