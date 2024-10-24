#!/bin/bash

# Check if the user provided an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <library_name>"
    exit 1
fi

CONFIG_FILE="/etc/captain-slack/cptn-main.ini"

# Parse the ini file and export variables
function source_config() {
    local section=""
    while IFS="=" read -r key value; do
        if [[ $key =~ ^\[(.*)\]$ ]]; then
            section="${BASH_REMATCH[1]}"
        elif [[ -n $key && -n $value && $key != ";"* && $section != "" ]]; then
            key=$(echo "$key" | xargs)  # Trim whitespace
            value=$(echo "$value" | xargs)  # Trim whitespace
            value=$(eval echo "$value")  # Resolve variables like $APP_HOME
            export "$key"="$value"  # Export as environment variable
            echo "$key = $value"  # Automatically echo the key-value pair
        fi
    done < "$CONFIG_FILE"
}

source_config



# Store the library name argument
library_name=$1

# File path for the YAML file
yaml_file="$ALL_DB/libraries_dependencies.yaml" # Replace this with the actual path to your YAML file

# Flag to check if we are inside a matching block
inside_block=false

# Read the YAML file line by line
while IFS= read -r line; do

    # Check if the line contains the library name before ".so"
    if [[ $line =~ -\ name:.*$library_name.*\.so ]]; then
        # Print the matching line (library)
        echo "$line"
        inside_block=true
    elif [[ $line =~ -\ name: ]] && [[ $inside_block == true ]]; then
        # If we encounter a new `- name:` line and we are inside the block, stop
        break
    elif [[ $inside_block == true ]]; then
        # Print dependencies while inside the block
        echo "$line"
    fi

done < "$yaml_file"

