
---

# Soteria HiveOS Full Node

This repository provides an installation script for **HiveOS Linux** to run a **Soteria full node** with the wallet disabled. The node is configured to automatically restart at boot or reboot using a **systemd service**.

## Overview

This is a **one‑click installation and configuration script** designed specifically for HiveOS Linux.  

The goal is to help strengthen and support the Soteria network. Many of us already have mining rigs running 24/7 — these machines can also contribute by running a full node, improving network resilience and decentralization.

## Features
- Installs and configures a Soteria full node on HiveOS.  
- Runs with the wallet disabled for security and simplicity.  
- Automatically restarts on boot/reboot via systemd.  
- Minimal setup required — designed for quick deployment.  

---

#### 1. Prerequisites
- **HiveOS Linux rig** already running.  
- **Internet connection** (stable, 24/7).  
- **Sufficient disk space** for blockchain data.  At least 20GB
- **Soteria daemon binary**.  
- **Open your firewall/router port forward 8323.**

##### This is the P2P port for Soteria Network, not RPC. It must be open/forwarded so your node can connect with peers and strengthen the network.

Best practice:

    Run ufw status to check.

    If it says “command not found”, install with sudo apt install ufw.

    If installed but inactive, enable with sudo ufw enable.

    If UFW is enabled, all incoming ports are blocked by default, so you must explicitly allow 8323:
    sudo ufw allow 8323/tcp

#### 2. Installation
- Step 1: Download the install script (`Soteria_Node.sh`).
- Step 2: Make the script executable. (`chmod +x Soteria_Node.sh`).
- Step 3: Run the script (`./Soteria_Node.sh`)
- Step 4: Confirm that configuration files are created.  

#### 3. Systemd Service Setup

- **Step 1:** Copy the provided `soteriad.service` file into the systemd directory:  
  ```bash
  sudo cp soteriad.service /etc/systemd/system/
  ```  

- **Step 2:** Reload systemd to recognize the new service:  
  ```bash
  sudo systemctl daemon-reload
  ```  

- **Step 3:** Enable the service so it starts at boot:  
  ```bash
  sudo systemctl enable soteriad.service
  ```  

- **Step 4:** Start the service immediately:  
  ```bash
  sudo systemctl start soteriad.service
  ```  

- **Step 5:** Verify it’s running:  
  ```bash
  systemctl status soteriad.service
  ```
---  

#### 4. Checking Node Status
- Use `systemctl status soteriad` to verify it’s running.  
- Use `journalctl -u soteriad -f` to view logs in real time.  
- (Optional) Check sync progress via the node’s RPC or CLI command.  

#### 5. Updating
- Stop the service (`systemctl stop soteriad`).  
- Replace the binary with the new version.  
- Restart the service (`systemctl start soteriad`). 

---
