    #!/bin/bash
    #
    # dockstart - A simple wrapper to pull a Docker image if it doesn't exist and then run it.
    #

    set -e # Exit immediately if a command fails.
    set -o pipefail # Fail a pipeline if any command fails.

    # --- Script Functions ---
    function print_usage() {
        echo "Usage: $0 -i <image_name> -n <container_name> [-p <port_mapping>] [other docker args...]"
        echo ""
        echo "A simple wrapper to pull and run a Docker container in one step."
        echo ""
        echo "Required Flags:"
        echo "  -i    The full name of the Docker image (e.g., 'ubuntu:latest')."
        echo "  -n    The name to give the new container."
        echo ""
        echo "Optional Flags:"
        echo "  -p    Port mapping in 'host_port:container_port' format."
        echo "  -h    Display this help message."
        echo ""
        echo "Any additional arguments are passed directly to 'docker run'."
        exit 1
    }

    # --- Main Script ---
    IMAGE_NAME=""
    CONTAINER_NAME=""
    PORT_MAPPING=""

    while getopts "i:n:p:h" opt; do
        case ${opt} in
            i) IMAGE_NAME="${OPTARG}" ;;
            n) CONTAINER_NAME="${OPTARG}" ;;
            p) PORT_MAPPING="-p ${OPTARG}" ;;
            h) print_usage ;;
            \?) print_usage ;;
        esac
    done
    shift $((OPTIND -1))

    if [[ -z "${IMAGE_NAME}" || -z "${CONTAINER_NAME}" ]]; then
        echo "Error: Image name (-i) and container name (-n) are required." >&2
        print_usage
    fi

    echo "--> Checking for Docker image: ${IMAGE_NAME}"
    if [[ "$(docker images -q "${IMAGE_NAME}" 2> /dev/null)" == "" ]]; then
        echo "--> Image not found locally. Pulling..."
        docker pull "${IMAGE_NAME}"
        echo "--> Image pulled successfully."
    else
        echo "--> Image already exists locally."
    fi

    echo "--> Starting container '${CONTAINER_NAME}'..."
    # shellcheck disable=SC2086
    docker run --rm --name "${CONTAINER_NAME}" ${PORT_MAPPING} "$@" "${IMAGE_NAME}"
    echo "--> Container command finished."
    
