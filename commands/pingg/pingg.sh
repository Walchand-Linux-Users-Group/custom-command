#!/usr/bin/env bash

# === Self-installation ===
command_name="pingg"
script_path=$(realpath "$0")
install_path="/usr/local/bin/$command_name"

if [ ! -f "$install_path" ]; then
  cp "$script_path" "$install_path"
  chmod +x "$install_path"
  echo "✅ Installed $command_name to $install_path"
fi

# === Actual command logic ===
host="$1"
count="${2:-5}"  # default ping count

if [ -z "$host" ]; then
  echo "Usage: $command_name <host> [count]"
  echo "Example: $command_name google.com 10"
  exit 1
fi

echo "🔹 Pinging $host ($count times)..."

# Check if ping exists
if ! command -v ping &>/dev/null; then
  echo "❌ 'ping' command not found!"
  exit 1
fi

# Ping with clean output
ping -c "$count" "$host" | awk '
BEGIN { print "SEQ\tTIME(ms)"; }
/time=/ {
  match($0, /icmp_seq=([0-9]+).*time=([0-9.]+)/, a);
  if(a[1] && a[2]) print a[1] "\t" a[2];
}
END { print "✅ Ping finished."; }
'
