#!/bin/bash
export LC_NUMERIC=C

LOG_FILE="system_usage.log"
INTERVAL=5
RAM_THRESHOLD=80

if [ ! -f "$LOG_FILE" ]; then
    echo "Timestamp,RAM_Total_MB,RAM_Used_MB,RAM_Free_MB,RAM_Usage_%,CPU_Usage_%" > "$LOG_FILE"
fi

echo "Monitoring system RAM and CPU. Logging to $LOG_FILE"

while true; do
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
    MEM=$(free -m | grep Mem)
    TOTAL=$(echo $MEM | awk '{print $2}')
    USED=$(echo $MEM | awk '{print $3}')
    FREE=$(echo $MEM | awk '{print $4}')
    RAM_PERCENT=$(echo "scale=2; ($USED/$TOTAL)*100" | bc)

    CPU_IDLE_RAW=$(top -bn1 | grep "Cpu(s)" | awk -F'id,' '{split($1, vs, ","); v=vs[length(vs)]; gsub(/[^0-9.]/,"",v); print v}')
    CPU_IDLE=$(echo "$CPU_IDLE_RAW" | sed 's/,/./g')

    if [[ "$CPU_IDLE" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
        CPU_USAGE=$(echo "100 - $CPU_IDLE" | bc)
    else
        CPU_USAGE=0
    fi

    echo "$TIMESTAMP,$TOTAL,$USED,$FREE,$RAM_PERCENT,$CPU_USAGE" >> "$LOG_FILE"

    RAM_USAGE_INT=${RAM_PERCENT%.*}
    if [ "$RAM_USAGE_INT" -ge "$RAM_THRESHOLD" ]; then
        echo "⚠️ WARNING: High RAM usage detected: ${RAM_PERCENT}% at $TIMESTAMP"
        notify-send "High RAM Usage Alert" "Usage: ${RAM_PERCENT}% at $TIMESTAMP"
    fi

    sleep "$INTERVAL"
done
