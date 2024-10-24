#!/bin/bash

# shellcheck disable=SC1091
. /etc/os-release

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

if [ ! -f "$LOC" ]; then
    echo "Your Captain-Slack package is broken..."
    echo "call 911"
    echo "..."
    exit 1
fi

if [ "$(cat "$LOC")" != 0 ]; then
cat "$LOC"
    echo ""
    echo "Captain-Slack:"
    echo "Last time you executed cptn something went wrong :("
    echo "Copy from the top of this message, error_code number."
    echo "Then execute it using 'cptn error' cmd. Example:"
    echo "cptn error -9"
    echo ""
    echo "If this doesn't work, please check:"
    echo "/etc/captain-slack/error.ini"
    exit 
fi

if [[ $(cat "$LOC") == 0 ]]; then
    echo "Hello I am Captain-Slack."
    echo "Appears this is your first time using cptn in your system."
    echo "If that's true, please confirm to continue..."
    echo ""

    # shellcheck disable=SC2162
    read -p "Do you want to continue? (y/n): " answer

    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
        echo "Continuing..."
        echo "error_code: -1" > "$LOC"
        bash /usr/local/bin/captain-slack/set-up.sh
    else
        echo "Exiting without making changes."
        exit 0
    fi
else
 exit 
fi

