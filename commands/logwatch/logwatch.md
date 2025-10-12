# logwatch

## Description
Real-time log file monitoring tool with color-coded output for different log levels, supporting multiple log files simultaneously with customizable display options.

## Syntax
```bash
logwatch [OPTIONS] <log-file> [log-file2] ...
```

## Features of the custom command
- **Color-Coded Output**: Automatic color highlighting - Red for ERROR/FATAL, Yellow for WARN, Green for INFO, Blue for DEBUG
- **Multiple File Support**: Monitor multiple log files simultaneously with unified output
- **Customizable Display**: Configure number of lines to display with `-n` flag (default: 10 lines)
- **Follow Mode**: Real-time log tailing with `-f` flag for continuous monitoring
- **Pattern Recognition**: Intelligent keyword detection for log level identification across different log formats
