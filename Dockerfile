FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    msmtp \
    bc \
    mailutils \
    && apt-get clean

WORKDIR /app
COPY . /app

RUN chmod +x monitor_system.sh send_report.sh

CMD ["bash", "send_report.sh"]
