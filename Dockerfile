FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install required tools
RUN apt-get update && apt-get install -y \
    msmtp \
    bc \
    mailutils \
    && apt-get clean

# Copy files and set working directory
WORKDIR /app
COPY . /app

# Make scripts executable
RUN chmod +x monitor_system.sh send_report.sh

# Run the report script
CMD ["bash", "send_report.sh"]
