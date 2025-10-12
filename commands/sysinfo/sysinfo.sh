#!/bin/bash
# sysinfo - Display comprehensive system information
# Description: Shows CPU, memory, disk usage, uptime, and kernel version

echo "======================================"
echo "       SYSTEM INFORMATION"
echo "======================================"
echo ""

# Hostname
echo "🖥️  Hostname: $(hostname)"
echo ""

# Kernel and OS
echo "🐧 OS Information:"
echo "   Kernel: $(uname -r)"
echo "   Architecture: $(uname -m)"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "   Distribution: $PRETTY_NAME"
fi
echo ""

# Uptime
echo "⏱️  Uptime: $(uptime -p)"
echo ""

# CPU Information
echo "💻 CPU Information:"
cpu_model=$(lscpu | grep "Model name" | cut -d':' -f2 | xargs)
cpu_cores=$(nproc)
echo "   Model: $cpu_model"
echo "   Cores: $cpu_cores"
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
echo "   Usage: ${cpu_usage}%"
echo ""

# Memory Information
echo "💾 Memory Information:"
total_mem=$(free -h | awk 'NR==2{print $2}')
used_mem=$(free -h | awk 'NR==2{print $3}')
free_mem=$(free -h | awk 'NR==2{print $4}')
mem_percent=$(free | awk 'NR==2{printf "%.1f", $3*100/$2}')
echo "   Total: $total_mem"
echo "   Used: $used_mem (${mem_percent}%)"
echo "   Free: $free_mem"
echo ""

# Disk Usage
echo "💿 Disk Usage:"
df -h / | awk 'NR==2{printf "   Root (/): %s / %s (Used: %s)\n", $3, $2, $5}'
echo ""

# Network
echo "🌐 Network:"
ip_address=$(hostname -I | awk '{print $1}')
echo "   IP Address: $ip_address"
echo ""

echo "======================================"
