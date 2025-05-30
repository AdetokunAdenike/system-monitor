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

# ✅ Create a dummy log file if it doesn't exist (for testing)
if [ ! -f "$LOG_FILE" ]; then
    echo "Timestamp,RAM_Total_MB,RAM_Used_MB,RAM_Free_MB,RAM_Usage_%,CPU_Usage_%" > "$LOG_FILE"
    echo "$(date '+%Y-%m-%d %H:%M:%S'),8000,4000,4000,50.00,12.0" >> "$LOG_FILE"
    echo "⚠️ Dummy log file created for testing: $LOG_FILE"
fi

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
