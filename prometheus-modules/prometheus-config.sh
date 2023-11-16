#!/bin/bash

# Download and unpack Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.47.2/prometheus-2.47.2.linux-amd64.tar.gz
tar xvfz prometheus-*.tar.gz

# Create the systemd service file for Prometheus
cat <<EOL > /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
After=network-online.target

[Service]
User=ubuntu
ExecStart=/home/ubuntu/prometheus-2.47.2.linux-amd64/prometheus --config.file=/home/ubuntu/prometheus-2.47.2.linux-amd64/prometheus.yml

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd, enable and start service
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus