#!/bin/bash

echo "=============== DELETE USER ==============="

# Read Username Value and store in variable
read -p "Enter the Username: " username

# Clears log file content
> error.log

# Attempt to delete the user and capture any errors
sudo userdel -r "$username" 2> error.log

# Check if useradd encountered an error
if [ $? -ne 0 ]; then
        error_msg=$(cat error.log)
        echo "$error_msg, Exiting..."
else
        echo "=============== USER DELETED =============="
fi
