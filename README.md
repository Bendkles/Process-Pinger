# Process Pinger (psping)

Process Pinger (psping) is a simple bash script that monitors the number of instances of a specific process running in a Linux environment. It can be configured to run for a specified number of times or indefinitely, and you can set the time interval between checks.

## Prerequisites

- Bash shell
- Linux operating system

## Installation

Clone the repository:

```
git clone <repository-url>
```

Navigate to the repository:

```
cd <repository-directory>
```

Make the script executable:

```
chmod +x psping.sh
```

## Usage

Run the script by specifying the name of the process you want to monitor. You can also filter by username, set the number of times the script should check, and the time interval between checks.

```
./psping.sh [-c count] [-t timeout] [-u username] executable
```

Options:

- `-c` Number of times the script should ping (positive integer, default: infinite).
- `-t` Time interval between pings in seconds (positive integer, default: 1).
- `-u` Username to filter the processes (default: all users).
- `executable` Name of the executable to ping (required).

## Examples

Ping 'java' processes for any user indefinitely:

```
./psping.sh java
```

Ping 'chrome' processes for user 'mark' 3 times:

```
./psping.sh -u mark -c 3 chrome
```

Ping 'java' processes for any user 3 times with 5 seconds interval:

```
./psping.sh -t 5 -c 3 java
```

## Error Handling

The script validates input arguments and checks if the pgrep command succeeds. If it encounters an error, it prints an error message and exits.

