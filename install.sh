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

if [ -d /tmp/config ]; then
    mkdir -p ~/.config
    cp -r /tmp/config/* ~/.config/
    chmod 700 ~/.config/*
    echo "Config files have been set up."
else
    echo "No config files found to set up."
fi

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