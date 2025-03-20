#!/bin/bash

echo "=============== CREATE USER ==============="

# Try setting Username for 3 times
attempts=0
max_attempts=3

while [ "$attempts" -lt "$max_attempts" ]; do

        # Read Username Value and store in variable
        read -p "Enter the Username (press enter to exit the program): " username

        # Clears log file content
        > error.log

        # Check if the input is blank
        if [ -z "$username" ]; then
                # Exit the loop
                echo "Exiting program..."
                exit 0
        else
                # Attempt to create the user and capture any errors
                sudo useradd -m "$username" 2> error.log

                # Check if useradd encountered an error
                if [ $? -ne 0 ]; then
                        error_msg=$(cat error.log)
                        echo "$error_msg"
                        attempts=$((attempts + 1))
                        echo "Attempts $attempts/$max_attempts."
                else
                        break # Exit the loop if the username is successfully created
                fi
        fi
done

if [ "$attempts" -eq "$max_attempts" ]; then
        echo "Maximum username attempts reached. Exiting..."
        exit 1
fi

# Try setting the password up to 3 times
attempts=0

while [ "$attempts" -lt "$max_attempts" ]; do

        # Read Password Value and store in variable
        read -sp "Enter the Password (press enter to exit the program): " password

        if [ -z "$password" ]; then
                # Exit the loop
                echo "Exiting program..."
                attempts=3
        else
                # This is setting the password
                echo -e "$username:$password" | sudo chpasswd 2> error.log

                # Check if an error occurred
                if grep -q "BAD PASSWORD" error.log; then
                        error_msg=$(cat error.log)
                        attempts=$((attempts + 1))
                        echo -e "\n$error_msg"
                        echo "Attempt $attempts/$max_attempts. Please enter a stronger password."
                else
                        echo -e "\n=============== USER CREATED =============="
                        exit 0  # Exit script if password is successfully set
                fi
        fi
done

# If all 3 password attempts fail, delete the user
if [ "$attempts" -eq "$max_attempts" ]; then
        echo "Undoing changes, Deleting user '$username'."
        sudo userdel -r "$username"
        exit 1
fi
