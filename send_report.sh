#!/bin/bash

# Load environment variables
if [ -f ".env" ]; then
    source .env
else
    echo "❌ .env file not found."
    exit 1
fi

SUBJECT="Daily System Usage Report - $(date '+%Y-%m-%d')"
TO="$EMAIL"
LOG_FILE="system_usage.log"

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
        echo "System Monitor Script"
    } | msmtp "$TO"

    echo "📧 Email sent to $TO with report."
else
    echo "❌ Log file not found: $LOG_FILE"
    exit 1
fi
