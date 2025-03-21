#!/bin/bash

# Function to display system metrics (CPU, memory, disk space)
view_system_metrics(){
        clear
        echo "==================== System Metrics ===================="

        # Fetch CPU usage using `top` command and extract the value using awk
        cpu_usage=$(top -bn 1 | grep '%Cpu' | awk '{print $2}')

        # Fetch memory usage using `free` command and extract the value using awk
        mem_usage=$(free | grep Mem | awk '{printf("%.1f", $3/$2 * 100)}')

        # Fetch disk space usage using `df` command and extract the value using awk
        disk_usage=$(df -h / | tail -1 | awk '{print $5}')

        # Display the fetched metrics
        echo -e "CPU Usage: $cpu_usage% \nMEM Usage: $mem_usage% \nDSK Usage: $disk_usage"

        # Wait for user input before exiting
        read -p "================== Press Enter to exit =================" key
        if $key; then
                return 1
        fi
}

# Function to monitor a specific service
monitor_service(){
        clear
        echo "==================== Service Metrics ===================="

        # Prompt user to enter the service name to monitor
        read -p "Enter the name of the service to monitor (press enter to go main menu): " service_name
        if [ -z "$service_name" ]; then
                echo "Exiting program..."
                return 0
        fi

        # Continuous monitoring loop
        while true; do
                if systemctl is-active --quiet $service_name; then
                        echo "STATUS : $service_name is active."
                else
                        echo "STATUS : $service_name is inactive."
                fi

                # Display service control options
                echo "############### What you want to do with service - $service_name ###############"
                echo "1 : Start"
                echo "2 : Status"
                echo "3 : PID"
                echo "4 : Reload"
                echo "5 : Restart"
                echo "6 : Enable"
                echo "7 : Disable"
                echo "8 : Stop"
                echo "9 : Kill"
                echo "0 : Main Menu"
                echo "# : Exit"
                echo -e "#####################################################################\n"

                # Read user choice
                read -p "Enter your choice : " choice

                # Perform corresponding action based on user input
                case $choice in
                        1) sudo systemctl start $service_name; echo "Executing Command, please check status";;
                        2) sudo systemctl status $service_name;;
                        3) pgrep $service_name;;
                        4) sudo systemctl reload $service_name; echo "Executing Command, please check status";;
                        5) sudo systemctl restart $service_name; echo "Executing Command, please check status";;
                        6) sudo systemctl enable $service_name; echo "Executing Command, please check status";;
                        7) sudo systemctl disable $service_name; echo "Executing Command, please check status";;
                        8) sudo systemctl stop $service_name; echo "Executing Command, please check status";;
                        9) sudo systemctl kill $service_name; echo "Executing Command, please check status";;
                        0) return 0;;
                        # Exit option
                        # '#' is used as a symbol for exit
                        '#') exit 0;;
                        # Handle invalid input
                        *) echo "Error: Invalid Choice, Restarting... Wait for 5 Sec";;
                esac

                # Wait for 5 seconds before clearing the screen
                sleep 5
                clear
        done
}

# Main loop for continuous monitoring
while true; do
        clear
        echo "==================== Monitoring Metrics for System & Services ===================="
        echo "1. View System Metrics"
        echo "2. Monitor a Specific Service"
        echo -e "3. Exit\n"

        # Read user choice for main menu
        read -p "Enter your choice (1, 2 or 3): " choice

        # Perform action based on user choice
        case $choice in
                1) view_system_metrics;;
                2) monitor_service;;
                3) echo -e "\nExiting the script. Goodbye!"; exit 0;;
                *) echo -e "\nError: Invalid otpion. Restarting... Wait for 5 Sec"; sleep 5; clear;;
        esac
done
