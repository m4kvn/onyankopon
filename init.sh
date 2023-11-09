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
    rustup component add rustfmt
    rustup component add clippy
    rustup component add rust-src
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

# VSCode
VSCODE_EXTENSION_INSTALLS=$(code --list-extensions)
while IFS= read -r line
do
    if [[ $VSCODE_EXTENSION_INSTALLS == *"$line"* ]]; then
        echo "$TAG VSCODE_EXTENSION_INSTALLS contains \"${line}\"."
    else
        echo "$TAG VSCODE_EXTENSION_INSTALLS does not contain \"${line}\". Installing..."
        code --install-extension ${i}
    fi
done < "VSCodeExtensionfile"

# Node (nvm)
if [ ! -d "$HOME/.nvm" ]; then
    echo "$TAG nvm not found. Installing..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    echo "$TAG Installing node..."
    nvm install node
fi