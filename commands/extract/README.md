## Description

The `extract()` and `compress()` commands are custom bash functions that simplify working with compressed files. The `extract()` command handles extracting files from various formats, while the `compress()` command allows users to compress files or directories into different formats. These commands make managing archives easier by automatically detecting and applying the correct operations based on file types or user specifications.

---

## Syntax

### Extract
```bash
extract <file_name>
```
- `<file_name>`: The name of the file to be extracted.
    - For Example:
        ```bash
        extract archive.tar.gz
        ```
        This will extract the contents of `archive.tar.gz` in the current directory.

### Compress
```bash
compress <file_or_directory> <compression_format>
```
- `<file_or_directory>`: The file or directory to compress.
- `<compression_format>`: The desired format for compression.
    - For Example:
        ```bash
        compress myfolder tar.gz
        ```
        This will compress `myfolder` into `myfolder.tar.gz`.

---

## Features

### Extract Command Features
- **Supports multiple formats**: Automatically detects and extracts a variety of compressed files based on their extension, including `.tar.bz2`, `.tar.gz`, `.bz2`, `.rar`, `.gz`, `.tar`, `.tbz2`, `.tgz`, `.zip`, `.Z`, and `.7z`.

### Compress Command Features
- **Supports various compression formats**: Easily compress files or directories into formats like `.tar.bz2`, `.tar.gz`, `.bz2`, `.rar`, `.gz`, `.tar`, `.tbz2`, `.tgz`, `.zip`, and `.7z`.

---