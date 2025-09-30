#!/usr/bin/env bash

# === Self-installation ===
command_name="myip"
script_path=$(realpath "$0")
install_path="/usr/local/bin/$command_name"

if [ ! -f "$install_path" ]; then
  cp "$script_path" "$install_path"
  chmod +x "$install_path"
  echo "✅ Installed $command_name to $install_path"
fi

# === Actual command logic ===
echo "🌐 Fetching IP addresses..."

# Show all interfaces with IP addresses
echo "🏠 Local IPs by interface:"
ip -brief addr | while read -r iface status addr; do
  ip_only=$(echo $addr | awk '{print $1}')
  if [ -n "$ip_only" ]; then
    echo "  $iface: $ip_only"
  fi
done

# Public IP
if command -v curl &>/dev/null; then
  public_ip=$(curl -s https://api.ipify.org)
elif command -v wget &>/dev/null; then
  public_ip=$(wget -qO- https://api.ipify.org)
else
  public_ip="Unavailable (install curl or wget)"
fi

echo "🌍 Public IP: $public_ip"
