#!/bin/bash

# Reset the password for an existing user account
echo "=============== RESET PASSWORD ==============="
read -p "Enter the username to reset password: " username

# Try setting the password up to 3 times
attempts=0
max_attempts=3

# Check if the username exists
if id "$username" &>/dev/null; then
        while [ "$attempts" -lt "$max_attempts" ]; do

                # Read Password Value and store in variable
                read -sp "Enter the Password (press enter to exit the program): " password

                # Check if the input is blank
                if [ -z "$password" ]; then
                        # Exit the loop
                        echo "Exiting program..."
                        break
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
                                echo -e "\n======== PASSWORD RESET SUCCESSFULLY ========="
                                exit 0  # Exit script if password is successfully set
                        fi
                fi
        done
else
        echo "Error: The username '$username' does not exist. Please enter a valid username."
fi
