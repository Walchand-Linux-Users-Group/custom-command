# 🧠 man-ai

## Description
`man-ai` enhances the traditional `man` command by finding and suggesting the closest matching command when you mistype or don’t remember the exact name.  
It helps you quickly open the correct manual page with intelligent search and interactive suggestions.

---

## Syntax
```bash
man-ai <approx_command_name>
```

---

## Features of the custom command
- **Fuzzy Command Search:** Uses `compgen` and pattern matching to suggest similar command names.  
- **Interactive Selection:** Prompts the user to pick the right command if multiple matches are found.  
- **Auto Open:** Automatically opens the correct `man` page after selection.  

---

## About
This command improves the usability of Linux manual pages by handling typos and approximate searches more intuitively than the regular `man` command.  
It’s a helpful addition for anyone who frequently forgets exact command names.

---

### ✅ Example
```bash
$ man-ai gti
❌ No man page found for 'gti'. Searching similar commands...
Did you mean one of these?
1) git
2) gitk
3) git-rebase
4) Cancel
# Choosing 1 opens the man page for git.
```
