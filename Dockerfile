FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install required tools
RUN apt-get update && apt-get install -y \
    bc \
    curl \
    && apt-get clean

# Set working directory and copy files
WORKDIR /app
COPY . /app

# Make scripts executable
RUN chmod +x monitor_system.sh send_report.sh

# Run the report script
CMD ["bash", "send_report.sh"]
