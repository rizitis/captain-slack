#!/bin/bash

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
            #echo "$key = $value"  # Automatically echo the key-value pair
        fi
    done < "$CONFIG_FILE"
}

source_config

# YAML file path
yaml_file="$PKG_DB"/packages.yaml

# Function to search for a package by name
search_package() {
    local package_name="$package"
    


    # Use yq to find the package details with strict equality
    result=$(yq eval ".[] | select(.package == \"$package_name\")" "$yaml_file")

    # Debugging: print the result of the search
    echo "Search result: $result"

    # Check if result is empty
    if [[ -n "$result" ]]; then
        echo "Package found:"
        echo "$result"
    else
        echo "Package '$package_name' not found."
    fi
}

# Example usage: search for a package by name
pkg_name="$1"  # Take the package name from the first script argument
search_package "$pkg_name"

echo "More infos you might find in $PKG_DB :"
ls "$PKG_DB"
