#!/bin/bash

# Task 1: Comments
# This is task 1 to create comments starting with #
echo "Task 1: Comments"
echo "# This is task 1 to create comments starting with #"

# Task 2: Echo
echo -e "\nTask 2: Echo"
echo "Welcome to the Day 1 of BashBlaze 7 Days of Bash Scripting Challenge"

# Task 3: Variables
echo -e "\nTask 3: Variables"
echo "variable1='Addition of'"
echo "variable2='Two Numbers'"
variable1="Addition of"
variable2="Two Numbers"

# Task 4A: Using Variables
echo -e "\nTask 4A: Add two string in one variable Using Two Variables"
read -p "Enter string 1 : " variable1
read -p "Enter string 2 : " variable2
greeting="$variable1 $variable2!"
echo -e "$greeting"

# Task 4B: Using Variables
echo -e "\nTask 4B: Add two numbers Using Two Variables"
read -p "Enter Number 1 : " num1
read -p "Enter Number 2 : " num2
sum=$((num1 + num2))
echo -e "Sum of $num1 and $num2 is $sum";

# Task  5: Using Built-in Variables
echo -e "\nTask 5: Built-in Variables"
echo "My current bash path - $BASH"
echo "Bash version I am using - $BASH_VERSION"
echo "PID of bash I am running - $$"
echo "My home directory - $HOME"
echo "Where am I currently? - $PWD"
echo "My hostname - $HOSTNAME"
echo "Who am I - $USER"

# Task 6: Wildcards
echo -e "\nTask 6: Wildcards"
echo "Files with .sh extension in the current directory:"
ls *.sh

#Make sure to provide execution permission with the following command:
#chmod +x day1_script.sh
