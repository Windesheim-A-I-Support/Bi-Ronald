#!/bin/bash

set -e

echo "🔍 Checking system requirements for open-source reporting stack..."

#-------------------------#
# 1. OS Verification
#-------------------------#
echo "✅ Verifying OS..."
OS_NAME=$(grep "^NAME=" /etc/os-release | cut -d= -f2 | tr -d '"')
OS_VERSION=$(grep "^VERSION_ID=" /etc/os-release | cut -d= -f2 | tr -d '"')

if [[ "$OS_NAME" != "Ubuntu" || "$OS_VERSION" != "24.04" ]]; then
    echo "⚠️  Warning: This script is optimized for Ubuntu 24.04. You are using $OS_NAME $OS_VERSION."
    read -p "Continue anyway? (y/N): " proceed
    [[ "$proceed" != "y" && "$proceed" != "Y" ]] && exit 1
fi

sudo apt update

#-------------------------#
# 2. Essential Packages
#-------------------------#
ESSENTIALS=(curl wget git unzip tar build-essential gnupg make openssl)

echo "📦 Installing essentials..."
sudo apt install -y "${ESSENTIALS[@]}"

#-------------------------#
# 3. Python & Jupyter
#-------------------------#
echo "🐍 Checking Python..."
if ! command -v python3 &>/dev/null; then
    sudo apt install -y python3 python3-pip python3-venv
fi

echo "📚 Installing Python packages..."
pip3 install --upgrade pip
pip3 install pandas matplotlib plotly jupyterlab

#-------------------------#
# 4. Docker & Compose
#-------------------------#
echo "🐳 Checking Docker..."
if ! command -v docker &>/dev/null; then
    echo "🔧 Installing Docker..."
    sudo apt install -y docker.io
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo usermod -aG docker "$USER"
fi

echo "🧩 Checking Docker Compose..."
if ! command -v docker-compose &>/dev/null; then
    echo "🔧 Installing Docker Compose..."
    sudo apt install -y docker-compose
fi

#-------------------------#
# 5. Quarto CLI
#-------------------------#
echo "📝 Checking Quarto..."
if ! command -v quarto &>/dev/null; then
    echo "📥 Installing Quarto..."
    wget https://quarto.org/download/latest/quarto-linux-amd64.deb -O /tmp/quarto.deb
    sudo dpkg -i /tmp/quarto.deb
    rm /tmp/quarto.deb
fi

#-------------------------#
# 6. PostgreSQL (optional local)
#-------------------------#
echo "🐘 Checking PostgreSQL..."
if ! command -v psql &>/dev/null; then
    echo "📥 Installing PostgreSQL..."
    sudo apt install -y postgresql postgresql-contrib
fi

#-------------------------#
# 7. GPG for encryption
#-------------------------#
if ! command -v gpg &>/dev/null; then
    echo "🔐 Installing GPG..."
    sudo apt install -y gnupg
fi

#-------------------------#
# 8. Wrap Up
#-------------------------#
echo "✅ All required tools are installed or updated!"
echo "🚀 You can now run your FOSS report automation stack."
echo "ℹ️ Log out and log back in to activate Docker permissions (if added to docker group)."
