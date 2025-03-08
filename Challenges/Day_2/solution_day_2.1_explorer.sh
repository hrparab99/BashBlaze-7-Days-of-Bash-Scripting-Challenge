#!/bin/bash

# Clears the terminal screen
clear

# Display program information
echo -e "This Program will give count of character in line\n__________________________________________________\n"

# Infinite loop to take user input repeatedly
while true; do
        # Prompt user for input
        read -p "Enter your input (press enter to exit the program): " input

        # Check if the input is blank
        if [ -z "$input" ]; then
                # Exit the loop
                echo "Exiting program..."
                break
        else
                # Display the number of characters in the input
                echo "Number of characters: ${#input}"
        fi
done
