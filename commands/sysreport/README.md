# System Resource Summary Command

sysreport

---

## Description

A Bash script that generates a detailed summary report of system resources, including CPU, memory, disk usage, uptime, top processes, and network details.
It merges multiple Linux utilities like `lscpu`, `free`, `df`, `uptime`, `top`, and `ifconfig` (or `ip`) into one unified, easy-to-read report.

## Syntax

```
chmod +x sysreport.sh
./sysreport.sh
```

## Usage Instructions

* Run the command without arguments to generate a full system report.
* The report is displayed in the terminal and can also be saved to a file:

  ```
  ./sysreport.sh > report.txt
  ```
* Generate HTML page
  ```
  ./sysreport.sh --html
  ```


## Features of the custom command

* **Comprehensive Overview**: Combines CPU, memory, disk, and network stats in a single report.
* **Readable Format**: Neatly formatted output with section headers.
* **Automatic Browser Launch*: The HTML page opens automatically after generation.
* **Automation Ready**: Perfect for daily cron jobs or monitoring scripts.


