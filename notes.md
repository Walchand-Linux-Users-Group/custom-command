# Notes.sh

## Description

This script allows you to quickly add timestamped notes to a file named `quicknotes.txt` located in your home directory. It's a convenient way to log notes with the current date and time.

## Syntax

```bash
./quicknote.sh "Your note"
```

## Features

1] Adds a timestamp to each note in the format YYYY-MM-DD HH:MM:SS.<br/>
2] Appends the note to ~/quicknotes.txt in your home directory.<br/>
3] Provides feedback if no note is supplied.
<br/>

code 
#!/bin/bash
# Usage: ./quicknote.sh "Your note"
if [ -z "$1" ]; then
    echo "Please provide a note."
    exit 1
fi
NOTE=$1
echo "$(date +'%Y-%m-%d %H:%M:%S') - $NOTE" >> ~/quicknotes.txt
echo "Note added to ~/quicknotes.txt"


Notes.sh