#!/bin/bash
set -e

# -- PARSE ARGUMENTS ---
RESTART=false
SELF=false
while getopts "rs" opt; do
  case $opt in
    r) RESTART=true ;;
    s) SELF=true ;;
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
  esac
done
shift $((OPTIND-1))

# --- VALIDATE INPUT ---
if [ -z "$1" -a "$SELF" = false ]; then
    echo "Usage: $0 [-r] [-s] <git-repo-url>"
    echo "  -r    Restart: Stop any running container and rebuild it"
    echo "  -s    Self: Run the nvim environment on itself"
    exit 1
fi

# --- CHECK IF DEVCONTAINERS CLI IS INSTALLED ---
if ! command -v devcontainer &> /dev/null; then
    echo "devcontainers CLI not found. Installing @devcontainers/cli on host..."
    if ! command -v npm &> /dev/null; then
        # Download and install nvm:
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

        # in lieu of restarting the shell
        \. "$HOME/.nvm/nvm.sh"

        # Download and install Node.js:
        nvm install 22

        # Verify the Node.js version:
        node -v # Should print "v22.15.0".
        nvm current # Should print "v22.15.0".

        # Verify npm version:
        npm -v # Should print "10.9.2".
    fi
    npm install -g @devcontainers/cli
fi

if [ "$SELF" = false ]; then
    REPO_URL="$1"
    REPO_NAME=$(basename -s .git "$REPO_URL")
    WORKSPACE_DIR="./workspaces"
    REPO_PATH="$WORKSPACE_DIR/$REPO_NAME"

    # --- CLONE REPO IF NOT EXISTS ---
    mkdir -p "$WORKSPACE_DIR"
    if [ ! -d "$REPO_PATH" ]; then
        echo "Cloning repository..."
        git clone "$REPO_URL" "$REPO_PATH"
    else
        echo "Repository already exists at $REPO_PATH"
    fi
else
    REPO_PATH="."
fi

# --- Handle restart if requested ---
if [ "$RESTART" = true ]; then
    echo "Restart flag detected, stopping and removing any existing container..."
    docker stop "$CONTAINER_NAME" 2>/dev/null || true
    docker rm "$CONTAINER_NAME" 2>/dev/null || true
fi

# --- ENSURE DEVCONTAINER CONFIG EXISTS ---
if [ ! -f "$REPO_PATH/.devcontainer.json" ] && [ ! -f "$REPO_PATH/.devcontainer/devcontainer.json" ]; then
    echo "No devcontainer config found. Initializing default template..."
    devcontainer templates apply \
        --workspace-folder "$REPO_PATH" \
        --template-id ghcr.io/devcontainers/templates/ubuntu:1.3.2
fi

# --- Set up devcontainer ---
echo "Setting up devcontainer for $REPO_PATH"
DEVCONTAINER_OPTIONS=""

if [ "$RESTART" = true ]; then
    DEVCONTAINER_OPTIONS="$DEVCONTAINER_OPTIONS --remove-existing-container"
fi

devcontainer up \
    --workspace-folder "$REPO_PATH" \
    --mount type=bind,source=$(realpath ~/.ssh),target=/tmp/ssh \
    --mount type=bind,source=$(realpath ./config),target=/tmp/config \
    --mount type=bind,source=$(realpath ./install.sh),target=/tmp/install.sh \
    --mount type=bind,source=$(realpath ~/.gitconfig),target=/tmp/gitconfig \
    $DEVCONTAINER_OPTIONS

# --- Perform post-installation steps ---
echo "Running post-installation steps..."
devcontainer exec \
    --workspace-folder "$REPO_PATH" \
    /bin/bash -c "sudo chmod 777 /tmp/install.sh && /tmp/install.sh"

# --- Exec into the container ---
echo "Executing into the container..."
devcontainer exec \
    --workspace-folder "$REPO_PATH" \
    /bin/bash


echo "Could do post work?"
