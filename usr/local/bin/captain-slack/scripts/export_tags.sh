#!/bin/bash

# Output file
output_file="tags_packages.txt"

# Create or clear the output file
> "$output_file"

# Loop through each installed package file in the specified directory
for package in /var/lib/pkgtools/packages/*; do
    # Get the filename without the path
    package_name=$(basename "$package")

    # Split the package name by '-' into an array
    IFS='-' read -r -a parts <<< "$package_name"

    # Count the number of parts
    num_parts=${#parts[@]}

    # Initialize variables for the last few components
    version=""
    arch=""
    build_version=""
    tag=""
    app_name=""

    # Check if there are at least four parts (to expect arch, version, and build_version)
    if [ "$num_parts" -ge 4 ]; then
        build_version="${parts[-1]}"
        arch="${parts[-2]}"
        version="${parts[-3]}"
        # Join the rest as the app name, using a hyphen instead of space
        app_name=$(IFS=-; echo "${parts[*]:0:$(($num_parts-3))}")

        # Check for an optional tag
        if [[ "$build_version" == *_* ]]; then
            tag="${build_version#*_}"   # Extract tag from build_version
            build_version="${build_version%_*}" # Remove tag from build_version
        fi

        # Output the formatted package information in the new format
        if [[ -n $tag ]]; then
            echo "Package=${app_name}_$tag" >> "$output_file"
        else
            echo "Package=${app_name}" >> "$output_file"
        fi
    elif [ "$num_parts" -eq 3 ]; then
        # Handle cases with only 3 parts (assumed to be app_name-version-architecture)
        app_name="${parts[0]}"
        version="${parts[1]}"
        arch="${parts[2]}"
        build_version="1"  # Default build version if not provided

        # Output the formatted package information in the new format
        echo "Package=${app_name}" >> "$output_file"
    else
        # Handle unexpected format
        echo "Unexpected package format: $package_name" >> "$output_file"
    fi
done

# Output the results
cat "$output_file"
