# Tested on Ubuntu 22.04

# Create a virtual environment called "oi"
echo "Creating virtual environment..."
python3 -m venv oi

# Activate the virtual environment
echo "Activating virtual environment..."
source oi/bin/activate

# Install Open-Interpreter using pip
pip install open-interpreter

# Run Open-Interpreter
interpreter
