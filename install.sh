# Copy SSH keys from the temporary mount to the devuser's .ssh directory
if [ -d /tmp/ssh ]; then
    mkdir -p ~/.ssh
    cp -r /tmp/ssh/* ~/.ssh/
    chmod 700 ~/.ssh
    chmod 600 ~/.ssh/*
    echo "SSH keys have been set up."
else
    echo "No SSH keys found to set up."
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
sudo apt update && sudo apt install -y \
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

# Install Neovim only if not already installed
if ! command -v nvim &> /dev/null; then
    echo "Installing Neovim..."

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

    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${ARCH}.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux-${ARCH}.tar.gz
    rm nvim-linux-${ARCH}.tar.gz
    
    echo "export PATH='$PATH:/opt/nvim-linux-$ARCH/bin'" >> ~/.bashrc
    echo "added neovim to path in ~/.bashrc"
    
    export path="$path:/opt/nvim-linux-$ARCH/bin"
else
    echo "Neovim is already installed, skipping installation."
fi