# lazy-commit.sh

**Auto commit script for Git with per-file commit messages**

`lazy-commit.sh` is a Bash script that simplifies committing changes in a Git repository. It automatically generates a smart commit message based on modified file names and optionally allows you to override it. After committing, it can also push the changes to the remote repository with a simple prompt.

---

## Features

* ✅ Detects changed files in the Git repository.
* 📝 Automatically generates commit messages like:

  ```
  update file1.txt, file2.js — 2025-10-23 13:45:12
  ```
* 💡 Optionally allows overriding the auto-generated message.
* 🚀 Prompts to push changes to remote after committing.
* 🛡 Works only inside a valid Git repository.

---

## Requirements

* Git installed and configured.
* Bash shell (Linux, macOS, or Git Bash on Windows).

---

## Installation

1. Clone or download the script:

```bash
wget https://path-to-your-script/lazy-commit.sh
```

2. Make it executable:

```bash
chmod +x lazy-commit.sh
```

3. Move it to a directory in your PATH (optional):

```bash
sudo mv lazy-commit.sh /usr/local/bin/lazy-commit
```

Now you can run it from any Git repository:

```bash
lazy-commit
```

---

## Usage

### Basic usage

```bash
./lazy-commit.sh
```

* Detects changes.
* Stages all modified files.
* Generates a commit message automatically.
* Prompts to push changes to remote.

### Override the commit message

```bash
./lazy-commit.sh "Fix login bug and update README"
```

* Ignores the auto-generated message and uses your custom message.

---

## Example

```bash
$ ./lazy-commit.sh
🔍 Detected changed files:
   • index.html
   • style.css
   • app.js

📝 Commit message:
   update index.html, style.css, app.js — 2025-10-23 13:45:12

🚀 Push to remote? (y/n): y
✅ Changes pushed!
```

---