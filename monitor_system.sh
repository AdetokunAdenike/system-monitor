#!/bin/bash
export LC_NUMERIC=C

LOG_FILE="system_usage.log"
INTERVAL=5
RAM_THRESHOLD=80

# Check if the log file exists, if not create it with headers
if [ ! -f "$LOG_FILE" ]; then
    echo "Timestamp,RAM_Total_MB,RAM_Used_MB,RAM_Free_MB,RAM_Usage_%,CPU_Usage_%" > "$LOG_FILE"
fi

echo "📊 Monitoring RAM and CPU. Logging to $LOG_FILE..."

while true; do
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

    # Memory info
    read -r _ TOTAL USED FREE _ <<< "$(free -m | grep Mem)"

    # RAM usage in percentage
    RAM_PERCENT=$(echo "scale=2; ($USED/$TOTAL)*100" | bc)

    # CPU usage
    CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk -F',' '{for(i=1;i<=NF;i++) if($i ~ /id/) print $i}' | grep -o '[0-9.]*')
    CPU_USAGE=$(echo "scale=2; 100 - $CPU_IDLE" | bc)

    echo "$TIMESTAMP,$TOTAL,$USED,$FREE,$RAM_PERCENT,$CPU_USAGE" >> "$LOG_FILE"

    # Alert if RAM usage exceeds threshold
    RAM_USAGE_INT=${RAM_PERCENT%.*}
    if [ "$RAM_USAGE_INT" -ge "$RAM_THRESHOLD" ]; then
        echo "⚠️ WARNING: High RAM usage detected: ${RAM_PERCENT}% at $TIMESTAMP"
        command -v notify-send >/dev/null && notify-send "High RAM Usage Alert" "Usage: ${RAM_PERCENT}% at $TIMESTAMP"
    fi

    sleep "$INTERVAL"
done
