#!/bin/bash
sudo useradd nexus
echo "test"|sudo passwd nexus
ulimit -n 65536
sudo apt update -y
sudo apt-get install openjdk-8-jdk -y
sudo mkdir /app && cd /app
sudo wget -O nexus.tar.gz https://download.sonatype.com/nexus/3/latest-unix.tar.gz
sudo tar -xvf nexus.tar.gz
sudo mv nexus-3* nexus
sudo chown -R nexus:nexus /app/nexus
sudo chown -R nexus:nexus /app/sonatype-work
sudo sed-i 's/"\#run_as_user=\"nexus\"/"run_as_user=\"nexus\"/g'/app/nexus/bin/nexus.rc
sudo tee -a /etc/systemd/system/nexus.service <<EOF
[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/app/nexus/bin/nexus start
ExecStop=/app/nexus/bin/nexus stop
User=nexus
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl start nexus.service
sudo systemctl enable nexus.service
