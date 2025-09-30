#!/usr/bin/env bash

# === Self-installation ===
command_name="timer"
script_path=$(realpath "$0")
install_path="/usr/local/bin/$command_name"

if [ ! -f "$install_path" ]; then
  cp "$script_path" "$install_path"
  chmod +x "$install_path"
  echo "✅ Installed $command_name to $install_path"
fi

# === Timer/Stopwatch Logic ===

show_usage() {
    echo "Usage: $command_name [duration]"
    echo "Examples:"
    echo "  $command_name 10s   # 10 seconds"
    echo "  $command_name 5m    # 5 minutes"
    echo "  $command_name 1h    # 1 hour"
    echo "  $command_name start # Stopwatch mode"
    exit 1
}

if [ -z "$1" ]; then
    show_usage
fi

# Stopwatch mode
if [[ "$1" == "start" ]]; then
    echo "⏱ Stopwatch started. Press Ctrl+C to stop."
    start_time=$(date +%s)
    trap 'end_time=$(date +%s); elapsed=$((end_time - start_time)); echo -e "\nElapsed: $elapsed seconds"; exit' INT
    while true; do sleep 1; done
fi

# Timer mode
DURATION=$1
if [[ $DURATION =~ ^([0-9]+)([smh])$ ]]; then
    TIME=${BASH_REMATCH[1]}
    UNIT=${BASH_REMATCH[2]}
    case $UNIT in
        s) total=$TIME ;;
        m) total=$((TIME * 60)) ;;
        h) total=$((TIME * 3600)) ;;
    esac
else
    echo "Invalid format. Use 10s, 5m, or 1h."
    exit 1
fi

echo "⏳ Timer set for $DURATION..."
while [ $total -gt 0 ]; do
    echo -ne "\rTime left: $total seconds "
    sleep 1
    total=$((total - 1))
done

echo -e "\n⏰ Time's up!"
if command -v paplay >/dev/null 2>&1; then
    paplay /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga 2>/dev/null &
fi
