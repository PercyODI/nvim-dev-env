#!/bin/bash
set -e

# --- VALIDATE INPUT ---
if [ -z "$1" ]; then
    echo "Usage: $0 <git-repo-url>"
    exit 1
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

# --- FIND .devcontainer.json FILE ---
if [ -f "$REPO_PATH/.devcontainer/devcontainer.json" ]; then
    DEVCONTAINER_JSON="$REPO_PATH/.devcontainer/devcontainer.json"
elif [ -f "$REPO_PATH/.devcontainer.json" ]; then
    DEVCONTAINER_JSON="$REPO_PATH/.devcontainer.json"
else
    echo "No devcontainer.json found. Proceeding without forwarded ports."
    DEVCONTAINER_JSON=""
fi

# --- PARSE PORTS FROM devcontainer.json ---
FORWARDED_PORTS=""
if [ -n "$DEVCONTAINER_JSON" ]; then
    # Extract ports from forwardedPorts field using jq
    FORWARDED_PORTS=$(jq -r '.forwardPorts[]?' "$DEVCONTAINER_JSON")

    if [ -z "$FORWARDED_PORTS" ]; then
        echo "No forwardedPorts defined in devcontainer.json"
    else
        echo "Forwarded ports: $FORWARDED_PORTS"
    fi
fi

# --- BUILD DOCKER IMAGE ---
echo "Building Docker image..."
docker build -t neovim-docker-testing .

# --- PREPARE PORT MAPPINGS ---
PORT_FLAGS=""
if [ -n "$FORWARDED_PORTS" ]; then
    for PORT in $FORWARDED_PORTS; do
        PORT_FLAGS+=" -p ${PORT}:${PORT}"
    done
fi

# --- RUN DOCKER CONTAINER ---
echo "Running Docker container..."
docker run -it --rm \
    --user 1010:1010 \
    --name nvim-dev-env-$REPO_NAME \
    $PORT_FLAGS \
    -e WORKDIR=/home/devuser/workspace/$REPO_NAME \
    -v ./config:/home/devuser/.config \
    -v $REPO_PATH:/home/devuser/workspace/$REPO_NAME \
    -v ~/.ssh:/tmp/ssh:ro \
    neovim-docker-testing
