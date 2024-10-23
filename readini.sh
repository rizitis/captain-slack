#!/bin/bash

# Function to read INI file
function read_ini {
    ini_file="project-map.ini"
    if [[ ! -f "$ini_file" ]]; then
        echo "INI file not found!"
        exit 1
    fi

    # Read and print the contents
    while IFS='=' read -r key value
    do
        echo "$key : $value"
    done < "$ini_file"
}

# Call the function
read_ini
