#!/bin/bash
set -e

# --- VALIDATE INPUT ---
if [ -z "$1" ]; then
    echo "Usage: $0 <git-repo-url>"
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

# --- Set up devcontainer ---
echo "$REPO_PATH"
devcontainer up \
    --workspace-folder "$REPO_PATH" \
    --mount type=bind,source=$(realpath ~/.ssh),target=/tmp/ssh \
    --mount type=bind,source=$(realpath ./config),target=/tmp/config \
    --mount type=bind,source=$(realpath ./install.sh),target=/tmp/install.sh
    # --mount type=bind,source=$(realpath $REPO_PATH),target=/workspace/$REPO_NAME \

devcontainer exec \
    --workspace-folder "$REPO_PATH" \
    /bin/bash -c "sudo chmod 777 /tmp/install.sh && /tmp/install.sh"

devcontainer exec \
    --workspace-folder "$REPO_PATH" \
    /bin/bash
