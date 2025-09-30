#!/bin/bash

# share - Host a file locally and print a public URL
# Self-installs to /usr/bin/share when run with sudo

command_name="share"

install_self() {
  if [ "$EUID" -ne 0 ]; then
    echo "Please run with sudo to install: sudo bash share.sh"
    exit 1
  fi
  script_path=$(realpath "$0")
  echo "Installing $command_name to /usr/bin/ ..."
  cp "$script_path" /usr/bin/$command_name
  chmod +x /usr/bin/$command_name
  echo "Installed. You can now run: share <file> [name] [port]"
  exit 0
}

# If not installed, run installer when invoked directly (not when /usr/bin/share)
if ! command -v "$command_name" &>/dev/null; then
  if [ "$(realpath "$0")" != "/usr/bin/$command_name" ]; then
    install_self
  fi
fi

usage() {
  cat <<EOF
Usage: share <file|-> [remote_name] [port]

Hosts <file> locally over HTTP and prints a public IP:port URL.
If you pass '-' the script reads from stdin and serves the piped content.
If <file> is a directory it will be archived (tar.gz) before serving.

Examples:
  share myfile.pdf
  share mydir
  cat notes.txt | share - notes.txt
  share large.iso my.iso 8080

Notes:
- Default port: 8000 (or an available random port if 0 is passed)
- You can set SHARE_TTL (seconds) to automatically stop serving after that time.
EOF
}

if [ "$#" -eq 0 ]; then
  usage
  exit 1
fi

if ! command -v python3 &>/dev/null && ! command -v python &>/dev/null; then
  echo "Error: python3 (or python) is required to host files locally."
  exit 2
fi

target="$1"
remote_name="$2"
port_arg="$3"

# temp vars
tmpfile=""
tmpdir=""
server_pid=""

cleanup_tmp() {
  # stop server if running
  if [ -n "$server_pid" ]; then
    kill "$server_pid" 2>/dev/null || true
    wait "$server_pid" 2>/dev/null || true
  fi
  [ -n "$tmpfile" ] && [ -f "$tmpfile" ] && rm -f "$tmpfile"
  [ -n "$tmpdir" ] && [ -d "$tmpdir" ] && rm -rf "$tmpdir"
}
trap cleanup_tmp EXIT

# Prepare file to serve
if [ "$target" = "-" ]; then
  tmpfile=$(mktemp /tmp/share-stdin-XXXXXX)
  cat - > "$tmpfile"
  if [ -z "$remote_name" ]; then
    remote_name="stdin.txt"
  fi
  upload_path="$tmpfile"
else
  if [ ! -e "$target" ]; then
    echo "Error: '$target' does not exist."
    exit 3
  fi

  if [ -d "$target" ]; then
    base=$(basename "$target")
    tmpfile=$(mktemp /tmp/share-archive-XXXXXX).tar.gz
    tar -C "$(dirname "$target")" -czf "$tmpfile" "$base"
    upload_path="$tmpfile"
    if [ -z "$remote_name" ]; then
      remote_name="$base.tar.gz"
    fi
  else
    upload_path="$target"
    if [ -z "$remote_name" ]; then
      remote_name=$(basename "$target")
    fi
  fi
fi

# Create temporary directory to serve from
tmpdir=$(mktemp -d /tmp/share-dir-XXXXXX)
cp -a -- "$upload_path" "$tmpdir/$remote_name"

# Determine port
if [ -n "$port_arg" ]; then
  port_to_use="$port_arg"
else
  port_to_use=${SHARE_PORT:-8000}
fi

if [ "$port_to_use" = "0" ]; then
    port=$(python3 -c 'import socket; s=socket.socket(); s.bind(("",0)); print(s.getsockname()[1]); s.close()')
else
    port="$port_to_use"
fi


# Determine available python command
pycmd="$(command -v python3 || command -v python)"

# Determine public IP (best-effort) - prefer wireless (wlo*) interfaces
public_ip=""
public_ip=$(ip -4 -o addr show 2>/dev/null | awk '/\bwl[a-z0-9]*/{print $4; exit}' | cut -d/ -f1)

if [ -z "$public_ip" ]; then
  public_ip=$(hostname -I 2>/dev/null | awk '{print $1}')
fi

if [ -z "$public_ip" ]; then
  if command -v curl &>/dev/null; then
    public_ip=$(curl -s https://ifconfig.me/ip || curl -s https://icanhazip.com || true)
  elif command -v wget &>/dev/null; then
    public_ip=$(wget -qO- https://ifconfig.me/ip || wget -qO- https://icanhazip.com || true)
  fi
fi

if [ -z "$public_ip" ]; then
  public_ip="127.0.0.1"
fi

# Start HTTP server in background, telling it WHICH DIRECTORY to serve
nohup "$pycmd" -m http.server "$port" --bind 0.0.0.0 --directory "$tmpdir" >/dev/null 2>&1 &
server_pid=$!

# give it a moment to start
sleep 0.5

if ! kill -0 "$server_pid" >/dev/null 2>&1; then
  echo "Failed to start HTTP server."
  cleanup_tmp
  exit 5
fi

# URL-encode the filename for robustness
encoded_name=$(python3 -c "import urllib.parse; print(urllib.parse.quote(input()))" <<< "$remote_name")

# Compute URLs
public_url="http://$public_ip:$port/$encoded_name"
local_url="http://127.0.0.1:$port/$encoded_name"

echo "Hosting '$remote_name'..."
echo "Public URL: $public_url"
echo "Local URL:  $local_url"
echo
echo "Server PID: $server_pid"

if [ -n "$SHARE_TTL" ]; then
  if ! [[ "$SHARE_TTL" =~ ^[0-9]+$ ]]; then
    echo "Warning: SHARE_TTL is not a number; ignoring auto-stop."
  else
    echo "This share will automatically stop after $SHARE_TTL seconds."
    ( sleep "$SHARE_TTL"; kill "$server_pid" 2>/dev/null || true ) &
  fi
else
  echo "To stop hosting, press Ctrl+C or run: kill $server_pid"
fi

# Wait for server process; when it exits (or is killed), script will continue and cleanup
wait "$server_pid" 2>/dev/null || true

exit 0