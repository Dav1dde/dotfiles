#!/bin/sh

set -e

BASE_PATH="$(dirname $(realpath $0))"

# Install all configurations
cd "$BASE_PATH"
stow -R \
    alacritty \
    bin \
    compton \
    fontconfig \
    i3 \
    kde \
    kitty \
    libinput-gestures \
    redshift \
    starship \
    systemd \
    vim \
    nvim \
    X \
    zsh

