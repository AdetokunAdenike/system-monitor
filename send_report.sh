#!/bin/bash

# Load environment variables
source /mnt/c/Users/PC/DEVELOPMENT/Altschool_Africa/system-monitor/.env

SUBJECT="Daily System Usage Report - $(date '+%Y-%m-%d')"
TO="$EMAIL"
LOG_FILE="/mnt/c/Users/PC/DEVELOPMENT/Altschool_Africa/system-monitor/system_usage.log"

if [ -f "$LOG_FILE" ]; then
    {
        echo "Subject: $SUBJECT"
        echo "To: $TO"
        echo
        echo "Hello,"
        echo
        echo "Here is the system usage report:"
        echo
        cat "$LOG_FILE"
        echo
        echo "Best regards,"
        echo "Memory Monitor Script"
    } | msmtp "$TO"
    
    echo "📧 Email sent to $EMAIL with report."
else
    echo "❌ Log file not found: $LOG_FILE"
fi
