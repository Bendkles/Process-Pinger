#!/bin/bash

# Default values
COUNT=-1
TIMEOUT=1
USERNAME=""
EXENAME=""

# Function to display script usage
usage() {
    echo "Usage: psping [-c COUNT] [-t TIMEOUT] [-u USERNAME] EXENAME"
    exit 1
}

# Process command-line arguments
while getopts "c:t:u:" opt; do
    case $opt in
        c)
            COUNT=$OPTARG
            ;;
        t)
            TIMEOUT=$OPTARG
            ;;
        u)
            USERNAME=$OPTARG
            ;;
        *)
            usage
            ;;
    esac
done

# Shift the processed options
shift $((OPTIND-1))

# Check if EXENAME is provided
if [ $# -eq 0 ]; then
    usage
fi

EXENAME=$1

# Function to count and echo live processes
count_processes() {
    local count=0
    if [ -z "$USERNAME" ]; then
        count=$(ps -ef | grep -v grep | grep -c "$EXENAME")
    else
        count=$(ps -fu "$USERNAME" | grep -v grep | grep -c "$EXENAME")
    fi
    echo "$EXENAME: $count instance(s)..."
}

# Start pinging
if [ $COUNT -eq -1 ]; then
    echo "Pinging '$EXENAME' for any user"
    while true; do
        count_processes
        sleep "$TIMEOUT"
    done
else
    echo "Pinging '$EXENAME' for user '$USERNAME'"
    for ((i=0; i<COUNT; i++)); do
        count_processes
        sleep "$TIMEOUT"
    done
fi
