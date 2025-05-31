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

# Check if log file exists
if [ -f "$LOG_FILE" ]; then
    BODY=$(cat "$LOG_FILE")
else
    echo "⚠️ Dummy log file created for testing: $LOG_FILE"
    echo "No actual usage data collected yet." > "$LOG_FILE"
    BODY=$(cat "$LOG_FILE")
fi

# Send email via SendGrid
RESPONSE=$(curl --silent --write-out "%{http_code}" --output /dev/null \
  --request POST \
  --url https://api.sendgrid.com/v3/mail/send \
  --header "Authorization: Bearer $SENDGRID_API_KEY" \
  --header 'Content-Type: application/json' \
  --data '{
    "personalizations": [{
      "to": [{"email": "'"$TO"'"}],
      "subject": "'"$SUBJECT"'"
    }],
    "from": {"email": "'"$FROM_EMAIL"'"},
    "content": [{
      "type": "text/plain",
      "value": "'"$BODY"'"
    }]
  }')

if [ "$RESPONSE" -eq 202 ]; then
    echo "📧 Email sent successfully to $TO"
    exit 0
else
    echo "❌ Failed to send email. SendGrid API response code: $RESPONSE"
    exit 1
fi
