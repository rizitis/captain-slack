#!/bin/bash

# shellcheck disable=SC1091
. /etc/os-release

CONFIG_FILE="/etc/captain-slack/cptn-main.ini"

# sourcing cptn-main.ini
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

# The python script filters repositories of type web and with a priority greater than 0.
# It prints the variables in KEY=VALUE format, which can be directly sourced in a bash script.
# It handles additional optional fields such as arch, branches, pkg_structure, and tag, and prints them if they exist.
# This way Captain-Slack need zero dependencies for run in Slackware, else it yq will needed. No big deal, but 0 deps is better. 
eval "$(python3 "$APP_TOOLS"/yaml2bash.py)"

ARCH="$( uname -m )"
echo "$ARCH"
echo "$VERSION_CODENAME"
echo "$ID"
echo "$VERSION"
