#!/bin/bash

if [ ! -f /usr/src/captain-slack/.evn ]; then
    echo "Your Captain-Slack package is broken..."
    echo "call 911"
    echo "..."
    exit 1
fi

if [[ $(cat /usr/src/captain-slack/.evn) == 0 ]]; then
    echo "Hello I am Captain-Slack."
    echo "Appears this is your first time using cptn in your system."
    echo "If that's true, please confirm to continue..."
    echo ""

    read -p "Do you want to continue? (y/n): " answer

    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
        echo "Continuing..."
        echo "error_code: 100" > /usr/src/captain-slack/.evn
        bash /usr/local/bin/captain-slack/set-up.sh
    else
        echo "Exiting without making changes."
        exit 0
    fi
else
    cat /usr/src/captain-slack/.evn
    echo "Last time you executed cptn something went wrong :("
    echo "Copy from the first line, the error_code number."
    echo "Then execute it using 'cptn error'. Example:"
    echo "cptn error 10"
    echo ""
    echo "If this doesn't work, please check"
    echo "/etc/captain-slack/error.ini"
    exit 0
fi

