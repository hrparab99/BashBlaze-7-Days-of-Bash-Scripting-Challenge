#!/bin/bash

# List all user accounts on the system

echo -e "########## User accounts on the system ##########\n"
cat /etc/passwd | awk -F: '{ print "- " $1 " (UID: " $3 ")" }'
