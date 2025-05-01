#!/bin/bash
set -e

# Copy SSH keys from the temporary mount to the devuser's .ssh directory
if [ -d /tmp/ssh ] && [ ! -d ~/.ssh ] || [ -z "$(ls -A ~/.ssh 2>/dev/null)" ]; then
    echo "Setting up SSH keys..."
    mkdir -p ~/.ssh
    cp -r /tmp/ssh/* ~/.ssh/
    chmod 700 ~/.ssh
    chmod 600 ~/.ssh/*
    echo "SSH keys have been set up."
else
    echo "Not setting up SSH keys"
fi

# Copy config files from the temporary mount to the user's .config directory
if [ -d /tmp/config ]; then
    mkdir -p ~/.config
    cp -r /tmp/config/* ~/.config/
    chmod 700 ~/.config/*
    echo "Config files have been set up."
else
    echo "No config files found to set up."
fi

# Install dependencies
sudo apt update --fix-missing 
sudo apt install --fix-missing -y \
  curl \
  gettext \
  jq \
  locales \
  luarocks \
  ripgrep \
  unzip \
  wget \
  xclip \
  xsel 

# Get machine architecture
ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
    ARCH="x86_64"
elif [[ "$ARCH" == "aarch64" ]]; then
    ARCH="arm64"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

# Install Neovim only if not already installed
if ! command -v nvim &> /dev/null; then
    echo "Installing Neovim..."
    
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${ARCH}.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux-${ARCH}.tar.gz
    rm nvim-linux-${ARCH}.tar.gz
    
    echo "export PATH=\$PATH:/opt/nvim-linux-$ARCH/bin" >> ~/.bashrc
    echo "added neovim to path in ~/.bashrc"
    
    export PATH="$PATH:/opt/nvim-linux-$ARCH/bin"
else
    echo "Neovim is already installed, skipping installation."
fi

# Install lazygit only if not already installed
if ! command -v lazygit &> /dev/null; then
    echo "Installing lazygit..."
    LAZY_VERSION=0.49.0
    if [[ "$ARCH" == "x86_64" ]]; then
        LAZY_ARCH="32-bit"
    elif [[ "$ARCH" == "arm64" ]]; then
        LAZY_ARCH="arm64"
    else
        echo "Unsupported architecture: $ARCH"
        exit 1
    fi
    echo https://github.com/jesseduffield/lazygit/releases/download/v${LAZY_VERSION}/lazygit_${LAZY_VERSION}_Linux_${LAZY_ARCH}.tar.gz

    curl -LO https://github.com/jesseduffield/lazygit/releases/download/v${LAZY_VERSION}/lazygit_${LAZY_VERSION}_Linux_${LAZY_ARCH}.tar.gz

    sudo rm -rf /opt/lazygit
    sudo mkdir -p /opt/lazygit
    sudo tar -C /opt/lazygit -xzf lazygit_${LAZY_VERSION}_Linux_${LAZY_ARCH}.tar.gz
    rm lazygit_${LAZY_VERSION}_Linux_${LAZY_ARCH}.tar.gz

    echo "export PATH=\$PATH:/opt/lazygit" >> ~/.bashrc
    echo "added lazygit to path in ~/.bashrc"
    
    export PATH="$PATH:/opt/lazygit"
else
    echo "lazygit is already installed, skipping installation."
fi