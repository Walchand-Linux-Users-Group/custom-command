#!/bin/bash

# Check for dependency: curl
if ! command -v curl &> /dev/null; then
    echo "Error: 'curl' command not found. Please install it to use this script."
    exit 1
fi

# Check if a city name was provided as an argument ($1)
if [ -z "$1" ]; then
    # If no city is provided, print usage instructions and exit
    echo "Usage: $0 [city_name]"
    echo "Example: $0 Satara"
    exit 1
fi

# If a city is provided, fetch the weather using curl and the wttr.in service
curl "wttr.in/$1"