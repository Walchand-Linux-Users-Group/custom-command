# docker-reset.sh

**Smartly Reset Docker Projects or Entire Environment**

`docker-reset.sh` is a Bash script that helps you clean and rebuild your Docker setup effortlessly. It can reset a specific project or completely wipe all Docker data from your system for a clean slate — like a factory reset for Docker.

---

## Features

* ✅ Works in two modes
    * Project-specific cleanup:
        ```
        docker-reset myapp
        ```
    * Full Docker cleanup:
        ```
        docker-reset
        ```
* Removes all containers (running or stopped)
* Deletes images (built or pulled)
* Cleans up volumes to free disk space
* Removes custom Docker networks
* Performs a deep system prune
* Safety prompts before destructive actions

---

## Requirements

* Docker installed and configured.
* Bash shell (Linux, macOS, or Git Bash on Windows).

---

## Installation

1. Clone or download the script:

```bash
wget https://github.com/Walchand-Linux-Users-Group/custom-command/blob/master/commands/docker-reset/docker-reset.sh
```

2. Make it executable:

```bash
chmod +x docker-reset.sh
```

3. Move it to a directory in your PATH:

```bash
sudo mv docker-reset.sh /usr/local/bin/docker-reset
```

Now you can run it globally:

```bash
docker-reset myapp
```
```bash
docker-reset
```

---

## Usage

### Reset a specific project

```bash
./docker-reset.sh myapp
```

* Removes all Docker containers, images, volumes, and networks associated with ```myapp```.
* Confirms before deletion to prevent accidental cleanup.
* Optionally performs a ```docker system prune``` for dangling resources.


### Reset everything

```bash
./docker-reset.sh
```

* Performs a complete cleanup of all Docker resources on your system.
* Deletes all containers, images, volumes, and custom networks.
* Runs a deep system prune to free up disk space.

---

## Example

```bash
$ ./docker-reset.sh myapp
Resetting Docker resources for project: myapp

Containers to remove:
  myapp_backend_1
  myapp_db_1

Images to remove:
  myapp:latest

Volumes to remove:
  myapp_data

Networks to remove:
  myapp_default

Proceed with reset of project 'myapp'? (y/n): y
✅ Containers removed.
✅ Images removed.
✅ Volumes removed.
✅ Networks removed.
✅ Dangling resources cleaned up.
✅ Reset complete for project: myapp
```

```bash
$ ./docker-reset.sh
⚠️  No project name provided — this will remove *all* Docker resources!
Do you want to continue with a full Docker reset? (y/n): y
✅ All containers removed.
✅ All images removed.
✅ All volumes removed.
✅ All custom networks removed.
✅ System prune complete.
✅ Docker environment fully reset — it’s as clean as new!
```

---