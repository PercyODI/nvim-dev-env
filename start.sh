#!/bin/bash
set -e

docker build -t neovim-docker-testing .
docker run -it --rm \
    --user 1010:1010 \
    --name nvim-dev-test \
    -p 3000:3000 -p 4000:4000 -p 8000:8000 -p 80:80 -p 8080:8080 -p 443:443 \
    -v ./mnt/.config/nvim:/home/devuser/.config/nvim \
    -v ./mnt/projects:/home/devuser/projects \
    neovim-docker-testing