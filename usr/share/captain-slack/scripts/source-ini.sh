#!/bin/bash

CONFIG_FILE="your_config_file.ini"

# Parse the config file and export variables
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

# Call the function to source the config
source_config

