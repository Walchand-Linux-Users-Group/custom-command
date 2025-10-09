#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' 


HOSTNAME=$(hostname)
DATE=$(date)
UPTIME_INFO=$(uptime -p)
KERNEL=$(uname -r)
CPU_MODEL=$(lscpu | grep 'Model name' | sed 's/Model name:\s*//')
CPU_CORES=$(nproc)
MEMORY=$(free -h | awk '/Mem:/ {print $3 "/" $2}')
DISK=$(df -h --total | grep total | awk '{print $3 "/" $2 " (" $5 ")"}')
TOP_PROC=$(ps -eo pid,comm,%mem,%cpu --sort=-%mem | head -n 6)
IP_ADDR=$(hostname -I | awk '{print $1}')
NETWORK_INTERFACE=$(ip -o -4 route show to default | awk '{print $5}')


generate_html() {
  FILE="sysreport_$(date +%F_%H-%M-%S).html"
  cat <<EOF > "$FILE"
<html>
<head>
  <title>System Report - $HOSTNAME</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 30px; background: #f8f9fa; }
    h1 { color: #007bff; }
    table { border-collapse: collapse; width: 70%; }
    th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
    th { background-color: #007bff; color: white; }
    pre { background-color: #f1f1f1; padding: 10px; border-radius: 6px; }
  </style>
</head>
<body>
  <h1>System Health Report</h1>
  <p><b>Generated on:</b> $DATE</p>
  <h2>System Information</h2>
  <table>
    <tr><th>Hostname</th><td>$HOSTNAME</td></tr>
    <tr><th>Kernel</th><td>$KERNEL</td></tr>
    <tr><th>Uptime</th><td>$UPTIME_INFO</td></tr>
    <tr><th>CPU</th><td>$CPU_MODEL ($CPU_CORES cores)</td></tr>
    <tr><th>Memory Usage</th><td>$MEMORY</td></tr>
    <tr><th>Disk Usage</th><td>$DISK</td></tr>
    <tr><th>IP Address</th><td>$IP_ADDR ($NETWORK_INTERFACE)</td></tr>
  </table>

  <h2>Top Memory Processes</h2>
  <pre>$TOP_PROC</pre>
</body>
</html>
EOF

  echo -e "${GREEN}✅ HTML report generated: $FILE${NC}"
  echo -e "${YELLOW}Opening report in default browser...${NC}"
  xdg-open "$FILE" &>/dev/null
}

generate_text() {
  echo -e "${CYAN}========================================"
  echo -e "     System Resource Summary - $HOSTNAME"
  echo -e "========================================${NC}"
  echo -e "${YELLOW}Generated on:${NC} $DATE"
  echo -e "${YELLOW}Kernel:${NC} $KERNEL"
  echo -e "${YELLOW}Uptime:${NC} $UPTIME_INFO"
  echo -e "${YELLOW}CPU:${NC} $CPU_MODEL ($CPU_CORES cores)"
  echo -e "${YELLOW}Memory Usage:${NC} $MEMORY"
  echo -e "${YELLOW}Disk Usage:${NC} $DISK"
  echo -e "${YELLOW}IP Address:${NC} $IP_ADDR ($NETWORK_INTERFACE)"
  echo ""
  echo -e "${BLUE}Top Memory Consuming Processes:${NC}"
  echo "$TOP_PROC"
  echo ""
  echo -e "${GREEN}Report generation complete.${NC}"
}

case "$1" in
  --html)
    generate_html
    ;;
  --text|"")
    generate_text
    ;;
  *)
    echo -e "${RED}Usage: $0 [--text | --html]${NC}"
    exit 1
    ;;
esac

