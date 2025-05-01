#!/bin/bash
set -e

# --- PARSE ARGUMENTS ---
RESTART=false
while getopts "r" opt; do
  case $opt in
    r) RESTART=true ;;
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
  esac
done
shift $((OPTIND-1))

# --- VALIDATE INPUT ---
if [ -z "$1" ]; then
    echo "Usage: $0 [-r] <git-repo-url>"
    echo "  -r    Restart: Stop any running container and rebuild it"
    exit 1
fi

# --- CHECK IF DEVCONTAINERS CLI IS INSTALLED ---
if ! command -v devcontainer &> /dev/null; then
    echo "devcontainers CLI not found. Installing @devcontainers/cli..."
    npm install -g @devcontainers/cli
fi

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

# --- Handle restart if requested ---
if [ "$RESTART" = true ]; then
    echo "Restart flag detected, stopping and removing any existing container..."
    docker stop "$CONTAINER_NAME" 2>/dev/null || true
    docker rm "$CONTAINER_NAME" 2>/dev/null || true
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