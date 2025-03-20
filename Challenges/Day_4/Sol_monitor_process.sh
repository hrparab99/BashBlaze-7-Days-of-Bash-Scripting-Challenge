#!/bin/bash

# Function to check if the specified process is running
is_process_running() {
        if pgrep -x "$1" >/dev/null; then
                return 0
        else
                return 1
        fi
}

# Function to restart the process using systemctl
restart_process() {
        local process_name="$1"
        echo "Process $process_name is not running. Attempting to restart..."

        # Check if the user has the privilege to restart the process
        if sudo systemctl restart $process_name; then
                echo "Process $process_name restarted successfully."
        else
                echo "Failed to restart $process_name. Please check the process manually."
        fi
}

# Function to send email alert
send_email_alert() {
        local subject="Alert: $process_name Restart Failed"
        local body="The process $process_name failed to restart after $max_attempts attempts on $(hostname). Please check manually."
        echo "$body" | mail -s "$subject" hrparab99@gmail.com
}

# Function to send Slack alert
send_slack_alert() {
        local process_name="$1"
        local SLACK_WEBHOOK_URL="https://hooks.slack.com/services/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"
        local message="Alert: Process $process_name failed to restart after multiple attempts on $(hostname). Manual intervention is required!"
        curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"$message\"}" "$SLACK_WEBHOOK_URL"
}

# Check if a process name is provided as an argument
if [ $# -eq 0 ]; then
        echo "Usage $0 <process_name"
        exit 1
fi

process_name="$1"
max_attempts=3
attempt=0

# Loop to check and restart the process
while [ $attempt -le $max_attempts ]; do
        if is_process_running $process_name; then
                echo "Process $process_name is running."
                exit 0
        else
                restart_process "$process_name"
                attempt=$((attempt + 1))
                sleep 5 # Wait for 5 seconds before the next check
        fi
done

# If max attempts are reached, send notifications
send_email_alert
send_slack_alert
