# take

Jump to a directory by name. Searches upward first (ancestors), then downward (recursive) from the current directory.

## Description

`take` helps you quickly navigate a project tree by directory name. It looks for an ancestor directory matching the name first — useful for jumping to repository roots or parent modules. If not found, it searches downward and returns the shallowest matching directory.

Supports being sourced so it can change your current shell directory directly, or run as a command that prints a path you can `cd` into.

## First-time Installation

Run once with sudo to install system-wide:

```bash
sudo bash take.sh
```

The script will copy itself to `/usr/bin/take` and make it executable. It also auto-installs the first time it's run with sudo.

## Usage

- Source to change the current shell immediately:

```bash
source take.sh <name>
# or
. take.sh <name>
```

- After installation, run directly to print a path:

```bash
take <name>
cd "$(take <name>)"
```

Options

- `-a`, `--all` — print all matches found (downward search)
- `--install`, `--uninstall` — install/uninstall to/from `/usr/bin/take`
- `--help` — show help

## Examples

```bash
take src
cd "$(take project-name)"
source take.sh hooks
```

## Requirements

- Bash shell
- find command (standard on Unix)

## Notes

- Matching is case-insensitive and supports partial matches when searching downward.
- When multiple matches are found, the script prefers the shallowest directory (fewest path components).
- If used as a normal command (not sourced) the script prints the path and exits; to change directory, use `cd "$(take name)"` or source it.

## License

MIT
