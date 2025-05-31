FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install tools
RUN apt-get update && apt-get install -y \
    curl \
    cron \
    bc \
    && apt-get clean

# Set work directory
WORKDIR /app
COPY . /app

# Make scripts executable
RUN chmod +x send_report.sh monitor_system.sh

# Copy and install crontab
COPY crontab.txt /etc/cron.d/mycron
RUN chmod 0644 /etc/cron.d/mycron && crontab /etc/cron.d/mycron

# Create log file
RUN touch /var/log/cron.log

# Start cron and keep container alive
CMD ["sh", "-c", "cron && tail -f /var/log/cron.log"]
