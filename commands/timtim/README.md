# timtim

A cinematic ASCII terminal timer that displays a large countdown inside an oval/circle-like border with an optional title and colorized output.

## Description

`timtim` renders a big, modern-looking timer in the terminal. When `figlet` is available it uses large ASCII fonts; when `lolcat` is installed the output becomes colorful and animated. The timer displays a centered time inside an ASCII oval, a title banner, a progress bar and the remaining time.

## First-time Installation

Run the script once with sudo to install it globally:

```bash
sudo bash timtim.sh
```

The script also auto-installs the first time it is executed with sudo: it copies itself to `/usr/bin/timtim` and makes it executable.

## After Installation

Invoke the command directly:

```bash
timtim [DURATION] [--title "Message"] [--width N]
```

## Usage

- `DURATION` can be an integer number of seconds (e.g. `90`) or `MM:SS` (e.g. `01:30`). If omitted, defaults to 60 seconds.
- `--title "TEXT"` show a title banner above the timer.
- `--width N` pass a preferred width to `figlet` (when used).
- `--install` install to `/usr/bin/timtim` (requires sudo).
- `--uninstall` remove `/usr/bin/timtim` (requires sudo).

## Examples

- Run a simple 90-second timer:

```bash
timtim 90
```

- Run a 1 minute 30 second focus session with a custom title:

```bash
timtim 1:30 --title "Focus Session"
```

- Install system-wide:

```bash
sudo timtim --install
```

- Uninstall:

```bash
sudo timtim --uninstall
```

## Requirements

- Bash (the script is a POSIX-compatible bash script)
- Optional for improved display:
  - `figlet` — for large ASCII fonts (install with your package manager, e.g. `sudo apt install figlet`)
  - `lolcat` — for rainbow color output (optional; install via gem or package manager)
  - `tput` / `ncurses` — used for cursor control (usually present on Linux)

## Notes

- If `figlet` is not installed the script falls back to a simple numeric display inside the oval border.
- If `lolcat` is not present the output will be monochrome.
- The auto-install only happens when you run the script with sudo or explicitly use `--install`.
- The script writes to `/usr/bin` only with explicit user consent (sudo) — be cautious on multi-user systems.
- Intended for interactive terminals; output may be messy if redirected to files.

## License

MIT
