#!/bin/bash

#### COLOR SCRIPT - echo "YELLOW" OUTPUT COLOR TEXT
cecho(){
    RED="\033[0;31m"
    GREEN="\033[0;32m"
    YELLOW="\033[1;33m"
    CYAN="\033[1;36m"
    PURPLE="\033[0;35m"
    WHITE="\033[0;37m"
    NC="\033[0m" # No Color

    printf "${!1}${2}${NC}\n"
}

cecho "CYAN" "Starting..."
sleep 2
cecho "YELLOW" "Expanding the disk...please wait..."
# NOTE: 'disk-expand' is not a standard command. Verify HiveOS provides it.
disk-expand || cecho "RED" "disk-expand command not found, skipping..."
sleep 2

cecho "YELLOW" "Checking your available disk space now..."
sleep 2

# Disk space check (in KB). Require ~20 GB.
reqSpace=20000000
availSpace=$(df /root | awk 'NR==2 { print $4 }')

if (( availSpace < reqSpace )); then
  cecho "RED" "You do not have enough disk space, exiting..." >&2
  exit 1
fi

cecho "CYAN" "Available disk space looks good, continuing with install..."
sleep 2

# User and directories
cecho "YELLOW" "Creating a soteria user and group..."
sleep 1
id -u soteria &>/dev/null || sudo adduser --system --group soteria
sudo mkdir -p /usr/bin/soteria.d
cd /tmp

# Download daemon
cecho "YELLOW" "Downloading the daemon..."
sleep 1
wget -q https://github.com/Soteria-Network/Soteria/releases/download/v1.1.0/soteria-daemon-oldlinux64.zip
cecho "YELLOW" "Unzipping and installing..."
sleep 1
unzip -q soteria-daemon-oldlinux64.zip
cd soteriad
sudo cp -r . /usr/bin/soteria.d
sudo ln -sf /usr/bin/soteria.d/bin/soteria-cli /usr/bin/soteria-cli
sudo ln -sf /usr/bin/soteria.d/bin/soteriad /usr/bin/soteriad

# Config file
echo -n 'rpcpassword=' > soteria.conf
openssl rand -base64 41 >> soteria.conf
echo 'maxconnections=50' >> soteria.conf

cecho "YELLOW" "Creating the directories and Soteria configuration file..."
sleep 2
sudo mkdir -p /root/.soteria /home/user/.soteria /etc/soteria /var/lib/soteriad
sudo cp soteria.conf /root/.soteria
sudo cp soteria.conf /home/user/.soteria
sudo cp soteria.conf /etc/soteria/soteria.conf
sudo chown soteria:soteria /etc/soteria/soteria.conf
sudo touch /var/lib/soteriad/soteriad.pid
sudo chown -R soteria:soteria /var/lib/soteriad

# Systemd service
cecho "YELLOW" "Creating the systemd service for automatic start-up at boot"
sleep 2
cd /etc/systemd/system
sudo wget -q -O /etc/systemd/system/soteriad.service https://raw.githubusercontent.com/Soteria-Network/Soteria-HiveOS-Full-Node/main/soteriad.service

cecho "YELLOW" "Enabling and starting the service"
sleep 2
sudo systemctl daemon-reload
sudo systemctl enable soteriad.service
sudo systemctl start soteriad.service

# Final messages
cecho "YELLOW" "Installation is complete!"
sleep 1
cecho "YELLOW" "Please review logs above for any errors!"
sleep 1
cecho "YELLOW" "Don't forget to open up your firewall / port forward 8323 !"
sleep 1
cecho "YELLOW" "Printing your IP address for port forwarding step..."
ip -4 addr show | grep -E 'inet ' | awk '{print $2}'

cecho "CYAN" "Copy your IP address (the one after 'inet')"
cecho "CYAN" "Use it in the next step for Port Forwarding"
cecho "CYAN" "Full directions at:"
cecho "GREEN" "*********************************"
cecho "CYAN" "     All finished! Exiting..."
cecho "GREEN" "*********************************"
