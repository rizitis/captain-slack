#!/bin/bash

# ldd-explorer-scan.sh
# Script to explore library dependencies for all shared libraries in /usr/lib and /usr/lib64

# Try to source the configuration file ini and see if it works
CONFIG_FILE=/etc/captain-slack/cptn-main.ini

# Parse the config file and export variables ;)
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
            #echo "$key = $value"  # Automatically echo the key-value pair for testing not need in real.. 
        fi
    done < "$CONFIG_FILE"
}

# Call the function to source the config
source_config


# Output file
###output_file="$PKG_DB/library_dependencies.txt"
output_file="$PKG_DB"/library_dependencies.txt
> "$output_file"

# Function to check dependencies of a given library
check() {
    local lib="$1"
    {
        echo "NEEDED by $lib:"
        objdump -p "$lib" | grep NEEDED | sed 's/ *NEEDED *//;s/$/ /;s/\./\\\./g' > "$NEEDED"
        ldd "$lib" | grep -f "$NEEDED" | sed 's/ (.*//'
        echo
    } >> "$output_file"  # Append results to output file
}

# Remove existing output file if it exists
[ -f "$output_file" ] && rm "$output_file"

# Temporary file for needed symbols
NEEDED=$(mktemp)
trap 'rm -f "$NEEDED"' EXIT

# Find all shared libraries in /usr/lib and /usr/lib64
find /usr/{lib,lib64} -name "*.so*" | while read -r lib; do
    # Check if the library is a valid binary or shared library
    if objdump -p "$lib" > /dev/null 2>&1; then
        check "$lib" &  # Run check in the background
    else
        echo "Note: $lib is not a valid binary or shared library." >> "$output_file"
        file $lib
    fi
done

wait  # Wait for all background jobs to finish

echo "Library dependencies have been written to $output_file."
