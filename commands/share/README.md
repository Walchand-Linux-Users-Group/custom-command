# share

Upload a file quickly to transfer.sh and get a public download link.

## Description

`share` uploads a file (or stdin) to https://transfer.sh and prints the URL. If you pass a directory it archives it as a tar.gz before uploading.

## Installation

Run with sudo to install system-wide:

```bash
sudo bash share.sh
```

## Usage

```bash
share <file|-> [remote_name]
```

- `<file>`: Path to a file or directory. Use `-` to read from stdin.
- `[remote_name]`: Optional remote filename to use for the uploaded file.

Examples:

```bash
share myfile.pdf
share mydir
cat notes.txt | share - notes.txt
```

## Notes
- Requires `curl`.
- transfer.sh keeps files for a limited time; do not use for long-term storage.
- Consider alternatives if transfer.sh is blocked in your environment.
