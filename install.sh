#!/bin/sh

set -e

BASE_PATH="$(dirname $(realpath $0))"

# Get i3-react ready and symlink binary into bin
I3_REACT_BIN="$BASE_PATH/_tools/i3-react/target/release/i3-react"
if [ ! -f "$I3_REACT_BIN" ]; then
    cd "$BASE_PATH/_tools/i3-react/"
    cargo build --release

    ln -s "$I3_REACT_BIN" "$BASE_PATH/bin/.local/bin/i3-react"
fi


# Install all configurations
cd "$BASE_PATH"
stow -R \
    alacritty \
    bin \
    compton \
    fontconfig \
    i3 \
    kde \
    redshift \
    systemd \
    vim \
    X \
    zsh

