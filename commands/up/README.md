## Description

The `up()` command is a custom bash function that allows users to navigate up a specified number of directory levels from their current working directory. If the number of levels exceeds the root directory (`/`), it will stop at the root.

---
## Syntax
```bash
up <number_of_levels>
```
- `<number_of_levels>`: The number of directories to go up.
	- For Example:
		up 3 -> This will move up three directories.
---
## Features of the custom command
- **Navigate up multiple levels**: The `up()` command allows the user to move up several directories at once by specifying the number of levels.

- **Error handling**: If an invalid (non-numeric) argument is provided, the command will display an error message and not change directories.

- **Safe exit at root**: The command will automatically stop navigating upwards when it reaches the root (`/`), preventing errors from exceeding directory boundaries.
---