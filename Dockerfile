FROM python:3.12-slim

# Prevent Python from creating .pyc files
ENV PYTHONDONTWRITEBYTECODE=1

# Send Python output directly to Docker logs
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install Linux utilities required by the monitor
RUN apt-get update && apt-get install -y \
    bash \
    procps \
    util-linux \
    iproute2 \
    iputils-ping \
    dnsutils \
    systemd \
    systemd-sysv \
    cron \
    && rm -rf /var/lib/apt/lists/*

# Copy project
COPY scripts/ /app/scripts/
COPY config/config.conf /app/config/config.conf

# Create runtime directories
RUN mkdir -p /app/logs /app/reports

# Make scripts executable
RUN chmod +x /app/scripts/*.sh

CMD ["/app/scripts/monitor.sh"]
