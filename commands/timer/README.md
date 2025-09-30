# Timer.sh

## Description

This script provides a simple countdown **timer** and a **stopwatch** mode.  
You can set a timer in seconds, minutes, or hours, or use it as a stopwatch.

## Syntax

```bash
bash timer.sh

timer.sh 10s   # 10 seconds
timer.sh 5m    # 5 minutes
timer.sh 1h    # 1 hour
timer.sh start # Stopwatch mode
```

## Features

1] Accepts time in s, m, or h (e.g., 10s, 5m, 1h).<br/>
2] Countdown mode displays remaining time until completion.<br/>
3] Stopwatch mode (start) shows elapsed time until stopped (Ctrl+C).<br/>
4] Plays a system notification sound when the timer ends (if available).<br/>
5] Self-installs to /usr/local/bin/timer on first run.<br/>
