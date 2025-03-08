#!/bin/bash

# Fucntion to check source is valid or not
check_source() {
        # Check if the user provided an argument
        if [ -z "$source_path" ]; then
                echo "Error: No path provided. Please provide a path as an argument."
                echo "Example: $0 path/of/directory_or_file"
                exit 1
        fi

        # Check if the path exists
        if [ ! -e "$source_path" ]; then
                echo "Error: Source path does not exist. Please provide valid path of the directory/file"
                exit 1
        fi
}

# Function to delete older backups, keeping only the latest 3
cleanup_backups() {
        backup_count=$(ls -1 $dest_path/backup_*.zip 2>/dev/null | wc -l)
        # If more than 3 backups exist, delete the oldest one
        if [ "$backup_count" -gt 3 ]; then
                local oldest_backup=$(ls -1t $dest_path/backup_*.zip | tail -n 1)
                rm -f "$oldest_backup"
                echo "Deleted oldest backup: $oldest_backup"
        fi
}

# Function to create backup
create_backup(){
        # Get current timestamp (YY_MM_DD_HH_MM_SS format)
        timestamp=$(date +"%Y_%m_%d_%H_%M_%S")

        # Filename for creating backup
        filename="backup_$timestamp"

        # If the source is a directory, use 'zip -r',  # If the source is a file, use 'zip'
        if [ -d "$source_path" ]; then
                zip -r "$dest_path/$filename" "$source_path"
                echo "Directory compressed successfully as $dest_path/$filename"
        elif [ -f "$source_path" ]; then
                zip "$dest_path/$filename" "$source_path"
                echo "File compressed successfully as $dest_path/$filename"
        else
                echo "Error while creating backup. Exiting..."
                exit 1
        fi

        cleanup_backups
        echo "========================================================="
        ls -lh $dest_path | tail -n +2 | awk '{print "- " $9 " ("$5") "}'
        echo "==================BACKUP COMPLETED======================="
}

# Get the source path from the first argument
source_path="$1"

# Destination Path
dest_path="/home/harry/Backup"

# Calling Function
check_source
create_backup
