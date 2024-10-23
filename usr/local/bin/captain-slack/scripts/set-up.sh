#!/bin/bash

# shellcheck disable=SC1091
. /etc/os-release

CONFIG_FILE="/etc/captain-slack/cptn-main.ini"

# Now parse the ini file and export ONLY the key-value pairs as environment variables
# we dont need differentiate between sections, if we needed that means we have 
# the same $var for 2 or more srtings and that not accepted in my logic...even if we can do it.
# If for any reason some day you want this option,
# use the commented function in case you dont have a better idea ;)

##======================= For future use if needed ===================================##
 # Parse the ini file and export variables
#function source_config() {
#    local section=""
#    while IFS="=" read -r key value; do
#        if [[ $key =~ ^\[(.*)\]$ ]]; then
#            section="${BASH_REMATCH[1]}"  # Capture section name
#        elif [[ -n $key && -n $value && $key != ";"* && $section != "" ]]; then
#            key=$(echo "$key" | xargs)  # Trim whitespace
#            value=$(echo "$value" | xargs)  # Trim whitespace
#            value=$(eval echo "$value")  # Resolve variables like $APP_HOME
#            export "$key"="$value"  # Export as environment variable
#            echo "$key = $value"  # Automatically echo the key-value pair
#        fi
#    done < "$CONFIG_FILE"
#}
##=====================================================================================##

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

ARCH="$( uname -m )"
echo "$ARCH"
echo "$VERSION_CODENAME"
echo "$ID"
echo "$VERSION"

 if [[ "$ARCH" == "aarch64" ]] && [[ "$VERSION_CODENAME" == "current" ]]; then
  # shellcheck disable=SC2154
  echo "SLACKKEY=${SLACKKEY:-"Slackware Linux Project <security@slackware.com>"}" > "$system_file"
  # shellcheck disable=SC2086
  # shellcheck disable=SC2129
  echo "SYSTEM_URL="http://ftp.arm.slackware.com/slackwarearm/slackwareaarch64-$VERSION_CODENAME/$ID"" >> "$system_file"
  echo "AARCH64=ON" >> "$system_file"
  echo "MIRROR_LIST=OFF" >> "$system_file"
  else
  [[ "$ARCH" == "aarch64" ]] && [[ "$VERSION_CODENAME" == "stable" ]]
  echo "Captain-Slack: Sorry your $VERSION_CODENAME is currently not supported..."
  exit 0
  # shellcheck disable=SC2154
  # shellcheck disable=SC2317
  echo "SLACKKEY=${SLACKKEY:-"Slackware Linux Project <security@slackware.com>"}" > "$system_file"
  # shellcheck disable=SC2086
  # shellcheck disable=SC2129
  # shellcheck disable=SC2317
  echo "SYSTEM_URL="http://ftp.arm.slackware.com/slackwarearm/slackwareaarch64-$VERSION_CODENAME/$ID"" >> "$system_file"
  # shellcheck disable=SC2317
  echo "AARCH64=ON" >> "$system_file"
  # shellcheck disable=SC2317
  echo "MIRROR_LIST=OFF" >> "$system_file"
 fi 

  if [[  "$VERSION_CODENAME" == "stable" ]] && [[ "$ARCH" == "x86_64" ]]; then
  PKGMAIN=${PKGMAIN:-slackware64}
  # shellcheck disable=SC2129
  echo "SLACKKEY=${SLACKKEY:-"Slackware Linux Project <security@slackware.com>"}" >> "$system_file"
  # shellcheck disable=SC2086
  echo "SYSTEM_URL="http://mirror.nl.leaseweb.net/slackware/$PKGMAIN-$VERSION/$PKGMAIN"" >> "$system_file"
  # shellcheck disable=SC2086
  echo "mirror_url=""http://mirror.nl.leaseweb.net/slackware"/$PKGMAIN-$VERSION"" >> "$system_file"
  else
  [[ "$VERSION_CODENAME" == "current" ]] && [[ "$ARCH" == "x86_64" ]]
  PKGMAIN=${PKGMAIN:-slackware64}
  # shellcheck disable=SC2129
  echo "SLACKKEY=${SLACKKEY:-"Slackware Linux Project <security@slackware.com>"}" >> "$system_file"
  # shellcheck disable=SC2086
  echo "SYSTEM_URL="http://mirror.nl.leaseweb.net/slackware/$PKGMAIN-$VERSION_CODENAME/$PKGMAIN"" >> "$system_file"
  # shellcheck disable=SC2086
  # shellcheck disable=SC2140
  echo "mirror_url=$PKGMAIN"-$VERSION_CODENAME"" >> "$system_file"
  fi 

if [[ "$ARCH" == "i?86" ]] && [[  "$VERSION_CODENAME" == "stable" ]]; then
PKGMAIN=${PKGMAIN:-slackware}
  # shellcheck disable=SC2129
  echo "SLACKKEY=${SLACKKEY:-"Slackware Linux Project <security@slackware.com>"}" >> "$system_file"
  # shellcheck disable=SC2140
  echo "SYSTEM_URL="http://mirror.nl.leaseweb.net/slackware/"$PKGMAIN"-"$VERSION"/"$PKGMAIN""" >> "$system_file"
  # shellcheck disable=SC2140
  echo "mirror_url=$PKGMAIN"-"$VERSION""" >> "$system_file"
  else
[[ "$VERSION_CODENAME" == "stable" ]] && [[ "$ARCH" == "i?86" ]]
  PKGMAIN=${PKGMAIN:-slackware64}
  # shellcheck disable=SC2129
  echo "SLACKKEY=${SLACKKEY:-"Slackware Linux Project <security@slackware.com>"}" >> "$system_file"
  # shellcheck disable=SC2140
  echo "SYSTEM_URL=$PKGMAIN"-"$VERSION_CODENAME"/"$PKGMAIN""" >> "$system_file"
  # shellcheck disable=SC2140
  echo "mirror_url=$PKGMAIN"-"$VERSION_CODENAME""" >> "$system_file"
fi

if [ "$ARCH" = "arm*" ]; then 
 echo "Captain-Slack: Sorry your $ARCH is not supported..."
 exit 0
fi

echo "$SLACKKEY"
echo "$PKGMAIN"


echo "Captain-Slack: I will now scan your system to create my database..."
echo "Unfortunatly this need some time... please be pation!"
cd "$APP_TOOLS" || exit
echo ""
echo "scan installed for packages..."
bash export-installed.sh
wait
bash create_db.sh
echo ""
echo "snan for installed libaries..."
bash ldd-explorer.sh
wait
bash create_libs_yaml.sh
echo ""
echo "Captain-Slack: Although I have already set up a Slackware mirror for you in $system_file"
echo "I will check in Mirrolist for faster servers... give me a minute please."
bash show-mirrors.sh

