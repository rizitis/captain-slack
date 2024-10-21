#!/bin/bash

# Function to process the package line
process_package_line() {
    local line="$1"

    # Use regex to extract the parts
    if [[ $line =~ Package:\ ([^,]+),\ Version:\ ([^,]+),\ Architecture:\ ([^,]+),\ Build\ Version:\ ([^,]+)(,\ Tag:\ ([^,]+))? ]]; then
        local package_name="${BASH_REMATCH[1]}"
        local version="${BASH_REMATCH[2]}"
        local architecture="${BASH_REMATCH[3]}"
        local build_version="${BASH_REMATCH[4]}"
        local tag="${BASH_REMATCH[6]}"

        # Generate YAML entry
        echo "- package: ${package_name}" >> packages.yaml
        echo "  version: ${version}" >> packages.yaml
        echo "  build_version: ${build_version}" >> packages.yaml  # Added build_version here
        if [ -n "$tag" ]; then
            echo "  tag: ${tag}" >> packages.yaml
        fi
    else
        echo "Invalid format: $line"  # Debugging info
    fi
}

# Main script execution
input_file="installed_packages.txt"  # Change this to your actual file path

# Check if the input file exists
if [[ ! -f "$input_file" ]]; then
    echo "Input file not found!"
    exit 1
fi

# Create or clear the output YAML file
> packages.yaml

# Read the file and process each line
while IFS= read -r line; do
    process_package_line "$line"
done < "$input_file"

echo "File created: packages.yaml"
