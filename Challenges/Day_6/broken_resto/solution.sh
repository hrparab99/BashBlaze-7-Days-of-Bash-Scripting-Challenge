#!/bin/bash

# Function to read and display the menu from menu.txt file
function display_menu() {
    local item_number=1

    echo "Welcome to the Restaurant!"
    echo -e "\nMenu:"
    echo -e "----------------------------------\nSr No  Item Name       Price\n----------------------------------"

    # TODO: Read the menu from menu.txt and display item numbers and prices
    while IFS= read -r line; do
        name="$(echo "$line" | cut -d',' -f1)"
        price="$(echo "$line" | cut -d',' -f2)"
        echo "$item_number.     $name $price.00 RS."
        ((item_number++))
    done < "menu.txt"

    echo -e "----------------------------------\n"
}

# Function to calculate the total bill
function calculate_total_bill() {
    local total=0
    local sr_no=1

    echo "--------------------------------------------------------"
    echo "Sr No Item Name       Amount  Qty     Total"
    echo "--------------------------------------------------------"
    # TODO: Calculate the total bill based on the customer's order
    # The order information will be stored in an array "order"
    # The array format: order[<item_number>] = <quantity>
    # Prices are available in the same format as the menu display
    # Example: If the customer ordered 2 Burgers and 1 Salad, the array will be:
    #          order[1]=2, order[3]=1
    # The total bill should be the sum of (price * quantity) for each item in the order.
    # Store the calculated total in the "total" variable.
    for item_number in "${!order[@]}"; do
            price=$(sed -n "${item_number}p" "menu.txt" | cut -d',' -f2)
            item_name=$(sed -n "${item_number}p" "menu.txt" | cut -d',' -f1)
            quantity="${order[$item_number]}"
            ((total += price * quantity))
            echo "$sr_no        $item_name$price        $quantity       $((price*quantity)).00 RS"
            ((sr_no++))
    done
    echo "--------------------------------------------------------"
    echo "                      Grand Total:    $total.00 RS"
    echo "--------------------------------------------------------"
}

# Function to handle invalid user input
function handle_invalid_input() {
    echo "Invalid input! Please enter a valid item number and quantity."
}

# Main script
display_menu

# Ask for the customer's name
echo -n "Please enter your name: "
read customer_name

# Ask for the order
echo -e "\nPlease enter the item number and quantity (e.g., 1 2 for two Burgers):"
read -a input_order

# Process the customer's order
declare -A order
for (( i=0; i<${#input_order[@]}; i+=2 )); do
    item_number="${input_order[i]}"
    quantity="${input_order[i+1]}"
    if [[ $item_number =~ ^[0-9]+$ && $quantity =~ ^[0-9]+$ ]]; then
        order["$item_number"]="$quantity"
    else
        handle_invalid_input
        exit 1
    fi
done

# Calculate the total bill
total_bill=$(calculate_total_bill)

# Display the total bill with a personalized thank-you message
echo -e "\nThank you, $customer_name! Please collect your bill \n$total_bill."
