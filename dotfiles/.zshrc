
# pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Google Cloud SDK
export CLOUDSDK_PYTHON_SITEPACKAGES=1

# Aliases
alias ls='eza'