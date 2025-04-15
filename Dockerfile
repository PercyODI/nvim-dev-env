FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install base tools
# Install dependencies for building Neovim
RUN apt update && apt install -y \
  autoconf \
  automake \
  build-essential \
  cmake \
  curl \
  gettext \
  git \
  libtool \
  libtool-bin \
  locales \
  luarocks \
  ninja-build \
  pkg-config \
  python3 \
  python3-pip \
  ripgrep \
  sudo \
  unzip \
  wget \
  xclip \
  xsel \
  zip \
  && apt clean

# Set UTF-8 Locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

### Switch to dev user

# Create user, give sudo rights, and set up home
RUN groupadd -g 1010 devuser && \
    useradd -u 1010 -g 1010 -ms /bin/bash devuser && \
    echo "devuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER devuser

# Create mounted directories
RUN mkdir -p /home/devuser/.config && \
    mkdir -p /home/devuser/projects

# Build Neovim from source
RUN git clone --depth 1 --branch v0.11.0 https://github.com/neovim/neovim.git /tmp/neovim && \
    cd /tmp/neovim && \
    make CMAKE_BUILD_TYPE=RelWithDebInfo && \
    sudo make install && \
    rm -rf /tmp/neovim

# Install NVM and Node.js 22 as devuser
ENV NVM_DIR=/home/devuser/.nvm
ENV NODE_VERSION=22

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash && \
    . "$NVM_DIR/nvm.sh" && \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    nvm use default && \
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc && \
    echo 'nvm use default &>/dev/null' >> ~/.bashrc

ENV PATH="$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH"


# Install SDKMAN
RUN curl -s "https://get.sdkman.io" | bash && \
    bash -c "source /home/devuser/.sdkman/bin/sdkman-init.sh && \
             sdk install java 17.0.10-tem && \
             sdk install java 21-tem && \
             sdk install maven"

# Set up ENV vars so it's available for user
ENV SDKMAN_DIR=/home/devuser/.sdkman
ENV JAVA_HOME=${SDKMAN_DIR}/candidates/java/current
ENV PATH="${JAVA_HOME}/bin:${PATH}"
RUN echo 'source "$SDKMAN_DIR/bin/sdkman-init.sh"' >> /home/devuser/.bashrc

WORKDIR /home/devuser

CMD [ "bash" ]
