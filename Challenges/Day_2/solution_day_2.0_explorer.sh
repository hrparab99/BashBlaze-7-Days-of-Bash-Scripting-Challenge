#!/bin/bash

# ls -lh → Lists files and directories with human-readable sizes.
# tail -n +2 → Skips the first line (total ...).
# awk '{print "- " $9 " (" $5 ")"}' → Formats output as - filename (size).
# | → used to pass the output of one command as input to another command.

echo -e "\nFiles and Directories in the Current Path:"
ls -lh | tail -n +2 | awk '{print "- " $9 " ("$5") "}'
