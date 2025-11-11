# git-auto-init.sh

**One-command Git + GitHub setup automation**

`git-auto-init.sh` initializes a local Git repository, creates a corresponding remote repository on GitHub, connects them, makes the first commit, and pushes — all automatically.  

No manual setup, no remote URL copying, and no wasted time. Just one command to go from *zero to GitHub*

---

## Features

* Checks if **GitHub CLI (`gh`)** is installed — installs automatically if missing.  
* Authenticates with GitHub (via browser OAuth) if not already logged in.  
* Initializes a local Git repository if one doesn’t exist.  
* Creates a **remote GitHub repository** (public or private).  
* Links local and remote repositories automatically.  
* Makes an initial commit and pushes to the `main` branch.  
* Supports custom repo descriptions.  
* Works system-wide for all users as a global command.  

---

## Requirements

* Git  
* GitHub CLI (`gh`)  
* Internet connection  
* GitHub account  

---

## Installation (System-Wide for All Users)

1. Download the script:
   ```bash
   wget https://raw.githubusercontent.com/Walchand-Linux-Users-Group/custom-command/master/commands/git-auto-init/git-auto-init.sh
   ```

2. Copy it to /usr/local/bin to make it globally available:
   ```bash
   sudo cp git-auto-init.sh /usr/local/bin/git-auto-init
   sudo chmod +x /usr/local/bin/git-auto-init
   ```
3. Now any user can run the command from anywhere:
   ```bash
   git-auto-init my-repo
   ```

---

## Authentication Flow (When Logging in for the First Time)
When the script runs for the first time, GitHub CLI will open your browser for authentication and show a
one-time code in the terminal, like this:
   ```bash
   ! First copy your one-time code: EEDB-3F6C
   - Press Enter to open github.com in your browser...
   ```

**What to do:**
1. Copy that code (e.g., EEDB-3F6C).
2. When the GitHub login page opens in your browser, paste the code there.
3. Click **Authorize**.

---

## Usage

**Auto Repository Naming (Default Behavior)**
  ```bash
  git-auto-init
  ```
  If you run the script without providing a repository name, like this
  then it automatically uses your current folder name as the GitHub repository name.

**Public repo with description**
   ```bash
   git-auto-init my-new-project --desc="This is my repo"
   ```

**Private repo**
   ```bash
   git-auto-init my-new-project --private
   ```

**Private repo with description**
  ```bash
  git-auto-init my-secret-project --private --desc "Internal automation scripts"
  ```

**Example Output**
   ```bash
   GitHub CLI detected: gh version 2.60.0
   Already authenticated with GitHub.
   Initialized new Git repository.
   Created README.md
   Created initial commit.
   Creating GitHub repository 'my-secret-project' (private)...
   Description: Internal automation scripts
   Repository created and pushed successfully!
   Repo URL: https://github.com/NareshAdhe/my-secret-project
   ```

---

## Notes
* Each user must authenticate once using, the login will persist securely for future runs.
* Works across all users after installation.
* No PATH configuration required (since /usr/local/bin is system-wide).