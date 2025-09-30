# dramatic

Run a command with cinematic style.

## Description

`dramatic` clears the screen, prints a large ASCII-art countdown (3...2...1...), runs your command, and then prints a "Mission Accomplished" banner. It optionally installs itself to `/usr/bin/dramatic` when you run it with sudo.

## Installation

Install by running with sudo:

```bash
sudo bash dramatic.sh
```

This will copy the script to `/usr/bin/dramatic` and make it executable.

## Usage

After installation you can run:

```bash
dramatic <command> [args...]
```

Examples:

```bash
# Run a simple command
dramatic ls -la


# Run a complex command
dramatic bash -c "echo Hello; sleep 1; echo World"
```


## Notes
- If `figlet` is installed, `dramatic` will use it to render the countdown and banner. Otherwise it falls back to simple ASCII art.
- The script preserves and returns the exit code of the executed command.


