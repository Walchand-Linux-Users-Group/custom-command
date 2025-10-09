# Command name

`dockstart`

# Description

A custom command to simplify the process of running a Docker container. It automatically pulls the specified image if it doesn't exist locally, and then runs it with a given container name and optional port mappings.

# Syntax

```bash
./dockstart.sh -i <image_name> -n <container_name> [-p host:container] [docker_run_options]
```


# Features of the custom command

* **Automatic Image Pulling:** Checks if an image exists locally and pulls it from Docker Hub if it doesn't.
* **Simplified Execution:** Combines `docker pull` and `docker run` into a single, easy-to-use command.
* **Required Naming:** Enforces good practice by requiring a name for every container via the `-n` flag.
* **Flexible Passthrough:** Allows any additional `docker run` arguments (like `-d` for detached mode or `-v` for volumes) to be passed at the end of the command.












