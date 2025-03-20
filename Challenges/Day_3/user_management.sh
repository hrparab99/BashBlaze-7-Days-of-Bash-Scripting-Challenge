#!/bin/bash

# Function to display usage information and available options
function display_usage {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -c, --create     Create a new user account."
    echo "  -d, --delete     Delete an existing user account."
    echo "  -r, --reset      Reset password for an existing user account."
    echo "  -l, --list       List all user accounts on the system."
    echo "  -h, --help       Display this help and exit."
}

# Function to create a new user account
function create_user {
        ./create_user.sh
}

# Function to delete an existing user account
function delete_user {
        ./delete_user.sh
}

# Function to reset the password for an existing user account
function reset_password {
        ./reset_password.sh
}

# Function to list all user accounts on the system
function list_users {
        ./list_users.sh
}

# Check if no arguments are provided or if the -h or --help option is given
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    display_usage
    exit 0
fi

# Command-line argument parsing
while [ $# -gt 0 ]; do
        case "$1" in
                -c | --create)
                        create_user
                        ;;
                -d | --delete)
                        delete_user
                        ;;
                -r | --reset)
                        reset_password
                        ;;
                -l | --list)
                        list_users
                        ;;
                *)
                        echo "Error : Invalid option '$1'. Use '--help' to see available options."
                        exit 1
                        ;;
        esac
        shift
done
