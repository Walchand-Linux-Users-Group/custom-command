#!/bin/bash

if [ -z "$1" ]; then
    echo "Please provide a note."
    exit 1
fi
NOTE=$1
echo "$(date +'%Y-%m-%d %H:%M:%S') - $NOTE" >> ~/quicknotes.txt
echo "Note added to ~/quicknotes.txt"