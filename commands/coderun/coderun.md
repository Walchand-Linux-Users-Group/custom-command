# coderun

## Description
Universal code runner that automatically detects file types and executes code in multiple programming languages with a single command, supporting compilation, execution time measurement, and memory usage tracking.

## Syntax
coderun [OPTIONS] <file> [arguments]

## Features of the custom command
- **Multi-Language Support**: Run Python, Java, C++, C, JavaScript, Bash, Go, and Rust files automatically
- **Smart Detection**: Automatically detects language from file extension and uses appropriate compiler/interpreter
- **Compilation Options**: Compile-only mode with `-c` flag for compiled languages (C++, Java, C, Go, Rust)
- **Performance Metrics**: Show execution time with `-t` and memory usage with `-m` flags for optimization analysis
- **Optimized Compilation**: Uses compiler optimization flags (C++: -O2, C: -O2) for better performance
- **Automatic Cleanup**: Removes compiled binaries after execution to keep workspace clean