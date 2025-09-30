#!/bin/bash

# dramatic - Run a command with cinematic style
# Installs itself to /usr/bin/dramatic when run with sudo


command_name="dramatic"

install_self() {
  if [ "$EUID" -ne 0 ]; then
    echo "Please run with sudo to install: sudo bash dramatic.sh"
    exit 1
  fi



  script_path=$(realpath "$0")
  echo "Installing $command_name to /usr/bin/ ..."
  cp "$script_path" /usr/bin/$command_name
  chmod +x /usr/bin/$command_name
  echo "Installed. You can now run commands like: dramatic ls -la"
  exit 0
}


print_big_number() {
  local n="$1"
  if command -v figlet &>/dev/null; then
    figlet -c "$n"
    return
  fi

  case "$n" in
    3)
      cat <<'EOF'
   33333
      33
    333
      33
   33333
EOF
      ;;
    2)
      cat <<'EOF'
   22222
  22   22
    2222
   22
   222222
EOF
      ;;
    1)
      cat <<'EOF'
     11
   111
     11
     11
   11111
EOF
      ;;
    *)
      echo "$n"
      ;;
  esac
}

print_mission() {
  if command -v figlet &>/dev/null; then
    figlet -c "Mission Accomplished"
    return
  fi

  cat <<'EOF'

=========================
  MISSION ACCOMPLISHED
=========================

EOF
}

# If the command is not yet installed, perform installation (requires sudo)
if ! command -v "$command_name" &>/dev/null; then
  # If we're running from the installed location already, continue
  if [ "$(realpath "$0")" != "/usr/bin/$command_name" ]; then
    install_self
  fi
fi

# Normal execution: run the provided command with style
if [ "$#" -eq 0 ]; then
  echo "Usage: dramatic <command> [args...]"
  echo "Example: dramatic bash -c 'echo hello && sleep 1 && echo world'"
  exit 1
fi

# Prepare terminal
clear
# Countdown 3..2..1..
for num in 3 2 1; do
  clear
  # center vertically
  printf "\n\n\n"
  print_big_number "$num"
  sleep 1
done

# Small pause, then execute
clear
echo "Running: $*"
echo
# Execute the command and preserve its exit status
"$@"
status=$?

# Post-run message
sleep 1
print_mission

exit $status
