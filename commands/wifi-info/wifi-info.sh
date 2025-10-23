#!/usr/bin/env bash
# wifi-pass.sh — Print Wi-Fi password for current SSID (use only on networks you own/have permission)

set -e

OS=$(uname)

print_and_exit() {
  echo "$1"
  exit 0
}

if [[ "$OS" == "Darwin" ]]; then
  # macOS
  SSID=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I 2>/dev/null | awk -F': ' '/ SSID/{print $2}')
  if [[ -z "$SSID" ]]; then
    SSID=$(networksetup -getairportnetwork en0 2>/dev/null | sed -e 's/^Current Wi-Fi Network: //')
  fi
  if [[ -z "$SSID" ]]; then print_and_exit "Could not detect SSID."; fi
  echo "SSID: $SSID"
  # May prompt for Keychain permission
  security find-generic-password -D "AirPort network password" -a "$SSID" -w 2>/dev/null || \
    security find-generic-password -ga "$SSID" 2>&1 | sed -n 's/^password: "\(.*\)"/\1/p'
  exit 0
elif [[ "$OS" == "Linux" ]]; then
  SSID=$(nmcli -t -f active,ssid dev wifi | egrep '^yes' | cut -d: -f2)
  if [[ -z "$SSID" ]]; then print_and_exit "Could not detect SSID."; fi
  echo "SSID: $SSID"
  # Try nmcli secret first (may need sudo)
  if sudo nmcli -s -g 802-11-wireless-security.psk connection show "$SSID" 2>/dev/null | grep -q .; then
    sudo nmcli -s -g 802-11-wireless-security.psk connection show "$SSID"
    exit 0
  fi
  # Fallback: check system-connections files
  FILE=$(sudo bash -c "ls /etc/NetworkManager/system-connections/ 2>/dev/null | grep -m1 -F \"$SSID\" || true")
  if [[ -n "$FILE" ]]; then
    sudo bash -c "grep -i psk /etc/NetworkManager/system-connections/$FILE || true"
    exit 0
  fi
  # Fallback: wpa_supplicant
  sudo grep -i "psk=" /etc/wpa_supplicant/wpa_supplicant.conf 2>/dev/null || print_and_exit "Password not found; you may need root or the connection stores secrets elsewhere."
elif [[ "$OS" == MINGW* || "$OS" == MSYS* || "$OS" == CYGWIN* ]]; then
  # Windows via netsh (Git Bash)
  SSID=$(netsh wlan show interfaces | awk -F': ' '/^\s*SSID/{print $2; exit}')
  if [[ -z "$SSID" ]]; then print_and_exit "Could not detect SSID."; fi
  echo "SSID: $SSID"
  netsh wlan show profile name="$SSID" key=clear
else
  echo "Unsupported OS: $OS"
  exit 1
fi
