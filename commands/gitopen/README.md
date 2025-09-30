# GitOpen.sh

## Description

This script opens the **remote Git repository (origin)** in your default web browser.  
It automatically converts SSH remotes to HTTPS and removes `.git` suffixes.

## Syntax

```bash
bash gitopen.sh

gitopen.sh
```

## Features

1] Works inside any Git repository with a configured remote origin.<br/>
2] Supports both HTTPS and SSH remote URLs.<br/>
3] Automatically converts SSH (git@github.com:user/repo.git) into HTTPS (https://github.com/user/repo).<br/>
4] Opens the repo homepage in your default browser.<br/>
5] Self-installs to /usr/local/bin/gitopen on first run.<br/>

⚠️ Note: On WSL or headless servers, direct browser opening may not work.
In WSL, the script uses wslview or explorer.exe as a fallback.
