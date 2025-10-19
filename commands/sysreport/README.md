# System Resource Summary Command

sysreport

---

## Description

A Bash script that generates a detailed summary report of system resources, including CPU, memory, disk usage, uptime, top processes, and network details.
It merges multiple Linux utilities like `lscpu`, `free`, `df`, `uptime`, `top`, and `ifconfig` (or `ip`) into one unified, easy-to-read report.

This enhanced Bash script provides a comprehensive system report featuring:

1.  **OS details**
2.  **CPU temperature**
3.  **Swap usage**
4.  **Default gateway & DNS info**
5.  **Logged-in users**
6.  **Battery status** 
7.  **Auto-installation of missing dependencies**

---
## Syntax

Before running, you must make the script executable:

```
chmod +x sysreport.sh
./sysreport.sh
```

---

## Usage Instructions
Execute the script with various flags to control the output:

| Command | Description |
| :--- | :--- |
| `./sysreport.sh` | **Generate a full system report** (Default action). Includes all system, CPU, disk, memory, and network data. |
| `./sysreport.sh --html` | Generate the full report in **HTML format** for easy viewing in a web browser. |
| `./sysreport.sh > report.txt` | **Save the entire output to a text file** (`report.txt`) instead of displaying it in the console. |

---

## Features of the custom command

* **Comprehensive Overview:** Consolidates CPU, memory (RAM and Swap), disk usage, and network statistics into a single, cohesive report.
* **Modular Reporting:** Allows generation of partial reports focusing only on specific components using command-line arguments like `--cpu`, `--disk`, or `--network`.
* **System Identification:** Displays essential information including the operating system distribution name, version, and the current kernel details.
* **CPU Thermal Monitoring:** Integrates with tools like `lm-sensors` to report real-time CPU temperature data.
* **Swap Utilization:** Provides clear metrics on total and used swap memory to assess memory pressure.
* **Network Insight:** Delivers detailed network topology information, including active interfaces, the default gateway, and configured DNS servers.
* **Session Tracking:** Lists all currently active user sessions and logged-in users.
* **Power Management Status:** Reports on battery charge level and status for portable devices and systems connected to a UPS.
* **Enhanced Readability:** Output is professionally formatted with clear section headers and consistent styling for easy analysis.
* **HTML Report Generation:** Supports an option to export the full report into a web-friendly HTML file.
* **Integration Ready:** Designed to be easily integrated into automated scripts, cron jobs, and centralized monitoring or auditing tools.
