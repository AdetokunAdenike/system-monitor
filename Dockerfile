FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    bc \
    curl \
    cron \
    && apt-get clean

# Set working directory and copy files
WORKDIR /app
COPY . /app

# Make scripts executable
RUN chmod +x monitor_system.sh send_report.sh

# Add cron job
COPY crontab.txt /etc/cron.d/system-report-cron
RUN chmod 0644 /etc/cron.d/system-report-cron && \
    crontab /etc/cron.d/system-report-cron

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Start cron and keep container running
CMD cron && tail -f /var/log/cron.log
