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

# Copy git config files from the temporary mount to the user's ~/.gitconfig
if [ -e /tmp/gitconfig ]; then
  cp -r /tmp/gitconfig ~/.gitconfig
  chmod 700 ~/.gitconfig
  echo ".gitconfig file has been set up."
else
  echo "No .gitconfig file found."
fi

if ! [ -e ~/.config/lazygit/config.yml ]; then
  mkdir -p ~/.config/lazygit
  touch ~/.config/lazygit/config.yml
  echo "Creating lazygit config.yml"
fi

# Copy aider config files from the temporary mount to the user's ~/.aider.conf.yml
if [ -e /tmp/aider.conf.yml ]; then
  cp -r /tmp/aider.conf.yml ~/.aider.conf.yml
  chmod 700 ~/.aider.conf.yml
  echo ".aider.conf.yml file has been set up."
else
  echo "No .aider.conf.yml file found."
fi

if ! [ -e ~/.config/lazygit/config.yml ]; then
  mkdir -p ~/.config/lazygit
  touch ~/.config/lazygit/config.yml
  echo "Creating lazygit config.yml"
fi

# Install dependencies
sudo apt update --fix-missing
sudo apt install --fix-missing -y \
  build-essential \
  curl \
  fzf \
  gettext \
  jq \
  locales \
  luarocks \
  ripgrep \
  unzip \
  wget

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
if ! command -v nvim &>/dev/null; then
  echo "Installing Neovim..."

  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${ARCH}.tar.gz
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf nvim-linux-${ARCH}.tar.gz
  rm nvim-linux-${ARCH}.tar.gz

  echo "export PATH=\$PATH:/opt/nvim-linux-$ARCH/bin" >>~/.bashrc
  echo "added neovim to path in ~/.bashrc"

  export PATH="$PATH:/opt/nvim-linux-$ARCH/bin"
else
  echo "Neovim is already installed, skipping installation."
fi

# Install lazygit only if not already installed
if ! command -v lazygit &>/dev/null; then
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

  echo "export PATH=\$PATH:/opt/lazygit" >>~/.bashrc
  echo "added lazygit to path in ~/.bashrc"

  export PATH="$PATH:/opt/lazygit"
else
  echo "lazygit is already installed, skipping installation."
fi

# Install npm only if not already installed
# This is required for Mason LSP packages
if ! command -v npm &>/dev/null; then
  # Download and install nvm:
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

  # in lieu of restarting the shell
  \. "$HOME/.nvm/nvm.sh"

  # Download and install Node.js:
  nvm install 22

  # Verify the Node.js version:
  node -v     # Should print "v22.15.0".
  nvm current # Should print "v22.15.0".

  # Verify npm version:
  npm -v # Should print "10.9.2".
fi

# Install aider
if ! command -v aider &>/dev/null; then
  echo "Installing aider..."
  curl -LsSf https://aider.chat/install.sh | sh
else
  echo "aider is already installed, skipping installation."
fi

# Install fd (fd-find)
if ! command -v fd &>/dev/null; then
  echo "Installing fd..."
  FD_VERSION=10.2.0

  if [[ "$ARCH" == "x86_64" ]]; then
    FD_ARCH="amd64"
  elif [[ "$ARCH" == "arm64" ]]; then
    FD_ARCH="arm64"
  else
    echo "Unsupported architecture: $ARCH"
    exit 1
  fi

  curl -LO https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/fd-musl_${FD_VERSION}_${FD_ARCH}.deb

  sudo rm -rf /opt/fd
  sudo mkdir -p /opt/fd

  sudo mv fd-musl_${FD_VERSION}_${FD_ARCH}.deb /opt/fd/fd-musl_${FD_VERSION}_${FD_ARCH}.deb

  sudo apt install /opt/fd/fd-musl_${FD_VERSION}_${FD_ARCH}.deb

else
  echo "fd is already installed, skipping installation."
fi

# Initialize Lazy
echo "Initializing Lazy"
nvim --headless "+Lazy! sync" +qa
