#!/bin/bash
TAG="[onyankopon]"

# Onyankopon
ONYANKOPON_ROOT=${ONYANKOPON_ROOT:-$HOME/.onyankopon}
if [ ! -d "$ONYANKOPON_ROOT" ]; then
    echo "$TAG onyankopon is not exists. Downloading..."
    git clone https://github.com/m4kvn/onyankopon $ONYANKOPON_ROOT
else
    echo "$TAG onyankopon is already exists."
fi

# Homebrew
if [ ! -n "$(brew --version 2>/dev/null)" ]; then
    echo "$TAG Homebrew is not installed. Installing..."
    /usr/bin/ruby -e "$(curl -fsSL 'https://raw.githubusercontent.com/Homebrew/install/master/install')"
    exec $SHELL -l
else
    echo "$TAG Homebrew is already installed."
fi
echo "$TAG Run \"brew bundle --file Brewfile...\""
brew bundle --file Brewfile

# rustup
if [ ! -d "$HOME/.rustup" ]; then
    echo "$TAG restup is not initialized."
    rustup-init
    rustup update
else
    echo "$TAG restup is already initialized."
fi

# cargo
CARGO_INSTALLS=$( \
    cat $HOME/.cargo/.crates2.json \
        | jq 'to_entries | .[] | select(.value | type == "object") | .value | keys[]' -r \
        | awk '{print $1}' \
)
while IFS= read -r line
do
    if [[ $CARGO_INSTALLS == *"$line"* ]]; then
        echo "$TAG CARGO_INSTALLS contains \"${line}\"."
    else
        echo "$TAG CARGO_INSTALLS does not contain \"${line}\". Installing..."
        cargo install ${i}
    fi
done < "Cargofile"