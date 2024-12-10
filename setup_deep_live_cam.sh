#!/bin/bash

# Set strict error handling
set -euo pipefail

# Step 1: Install necessary system dependencies
sudo apt update
sudo apt install -y git python3.10 python3.10-venv python3.10-dev build-essential libssl-dev libffi-dev python3-tk ffmpeg

# Step 2: Clone the repository if it doesn't already exist
if [ ! -d "Deep-Live-Cam" ]; then
    echo "Cloning the Deep-Live-Cam repository..."
    git clone https://github.com/hacksider/Deep-Live-Cam.git
fi

cd Deep-Live-Cam

# Step 3: Create and activate the virtual environment
if [ -d "venv" ]; then
    echo "Removing existing virtual environment..."
    rm -rf venv
fi

python3.10 -m venv venv
source venv/bin/activate

# Step 4: Upgrade pip
pip install --upgrade pip

# Step 5: Install project requirements
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
else
    echo "Error: 'requirements.txt' not found in the repository."
    exit 1
fi

# Step 6: Adjust permissions for necessary directories
if [ -d "modules/processors/frame/" ]; then
    find modules/processors/frame/ -type f -exec chmod 664 {} \;
    find modules/processors/frame/ -type d -exec chmod 775 {} \;
else
    echo "Warning: 'modules/processors/frame/' directory not found. Skipping permission adjustments."
fi

# Step 7: Increase swap memory if necessary
if [ "$(swapon --show | wc -l)" -lt 2 ]; then
    echo "Creating and enabling an 8G swap file..."
    sudo fallocate -l 8G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
fi

# Step 8: Check and use GPU for acceleration
if command -v nvidia-smi &> /dev/null; then
    echo "NVIDIA GPU detected, installing CUDA dependencies..."
    pip uninstall -y onnxruntime onnxruntime-gpu
    pip install onnxruntime-gpu==1.16.3
    python run.py --execution-provider cuda
else
    echo "No NVIDIA GPU detected, running on CPU..."
    python run.py
fi
