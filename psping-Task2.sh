#!/bin/bash

# This script pings processes for a given executable and user
# Usage: ./psping.sh [-c count] [-t timeout] [-u username] executable
# -c: Number of times the script should ping (default: infinite)
# -t: Time interval between pings in seconds (default: 1)
# -u: Username to filter the processes (default: all users)
# executable: Name of the executable to ping

# Set default values
count=-1
timeout=1
user=""

# Parse command-line arguments
while getopts "c:t:u:" opt; do
  case $opt in
    c)
      # Validate that count is a positive integer
      if [[ $OPTARG =~ ^[0-9]+$ ]]; then
        count=$OPTARG
      else
        echo "Error: -c option requires a positive integer argument." >&2
        exit 1
      fi
      ;;
    t)
      # Validate that timeout is a positive integer
      if [[ $OPTARG =~ ^[0-9]+$ ]]; then
        timeout=$OPTARG
      else
        echo "Error: -t option requires a positive integer argument." >&2
        exit 1
      fi
      ;;
    u)
      # Validate that user exists
      if id "$OPTARG" &>/dev/null; then
        user=$OPTARG
      else
        echo "Error: User $OPTARG does not exist." >&2
        exit 1
      fi
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# Shift the command-line arguments to get the executable name
shift $((OPTIND-1))
exe_name=$1

# Check if the executable name is provided
if [ -z "$exe_name" ]; then
  echo "Usage: psping [-c count] [-t timeout] [-u username] executable" >&2
  echo "  -c: Number of times to ping (positive integer, default: infinite)" >&2
  echo "  -t: Time interval between pings in seconds (positive integer, default: 1)" >&2
  echo "  -u: Username to filter the processes (default: all users)" >&2
  echo "  executable: Name of the executable to ping" >&2
  exit 1
fi

# Initialize the counter
ping_count=0

# Loop indefinitely or until the ping count is reached
while [ "$count" -lt 0 ] || [ $ping_count -lt "$count" ]; do
  # Count the number of live processes for the user and executable
  if [ -z "$user" ]; then
    # No user specified, search for processes from all users
    live_count=$(pgrep "$exe_name" 2>/dev/null | wc -l)
  else
    # User specified, filter the processes
    live_count=$(pgrep -u "$user" "$exe_name" 2>/dev/null | wc -l)
  fi

  # Check for errors in pgrep
  if [ $? -ne 0 ]; then
    echo "Error: Could not execute pgrep. Check permissions and executable name." >&2
    exit 1
  fi
  
  # Echo the number of live processes
  if [ $live_count -eq 1 ]; then
    echo "$exe_name: $live_count instance..."
  else
    echo "$exe_name: $live_count instances..."
  fi

  # Increment the ping count
  ping_count=$((ping_count+1))

  # Sleep for the specified timeout
  sleep "$timeout"
done

