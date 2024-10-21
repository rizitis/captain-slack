#!/bin/bash

# YAML file path
yaml_file="packages.yaml"

# Function to search for a package by name
search_package() {
    local package_name="$1"

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
