#!/bin/bash
set -e

# Copy SSH keys from the temporary mount to the devuser's .ssh directory
if [ -d /tmp/ssh ]; then
    mkdir -p /home/devuser/.ssh
    cp -r /tmp/ssh/* /home/devuser/.ssh/
    chmod 700 /home/devuser/.ssh
    chmod 600 /home/devuser/.ssh/*
    echo "SSH keys have been set up."
else
    echo "No SSH keys found to set up."
fi

# Change to the working directory if the WORKDIR environment variable is set
if [ -n "$WORKDIR" ]; then
  cd "$WORKDIR" || exit
fi

# Execute the provided command
exec "$@"