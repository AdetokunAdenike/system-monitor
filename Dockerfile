# Dockerfile
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    bc \
    curl \
    cron \
    && apt-get clean

# Set working directory
WORKDIR /app

# Copy application files
COPY . /app

# Make the script executable
RUN chmod +x monitor_system.sh send_report.sh

# Copy crontab file and install it
COPY crontab.txt /etc/cron.d/app-cron
RUN chmod 0644 /etc/cron.d/app-cron \
    && crontab /etc/cron.d/app-cron

# Ensure cron runs in the foreground to keep container alive
CMD cron && tail -f /var/log/syslog
