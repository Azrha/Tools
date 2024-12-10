#!/bin/bash

# Set strict error handling
set -euo pipefail

# Step 1: Install necessary system dependencies
sudo apt update
sudo apt install -y python3.10 python3.10-venv python3.10-dev build-essential libssl-dev libffi-dev python3-tk

# Step 2: Create and activate the virtual environment
if [ -d "venv" ]; then
    echo "Removing existing virtual environment..."
    rm -rf venv
fi

python3.10 -m venv venv
source venv/bin/activate

# Step 3: Upgrade pip
pip install --upgrade pip

# Step 4: Install project requirements
pip install -r requirements.txt

# Step 5: Adjust permissions for necessary directories
find ~/Deep-Live-Cam/modules/processors/frame/ -type f -exec chmod 664 {} \;
find ~/Deep-Live-Cam/modules/processors/frame/ -type d -exec chmod 775 {} \;

# Step 6: Increase swap memory if necessary
if [ "$(swapon --show | wc -l)" -lt 2 ]; then
    echo "Creating and enabling an 8G swap file..."
    sudo fallocate -l 8G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
fi

# Step 7: Run the application
python run.py
