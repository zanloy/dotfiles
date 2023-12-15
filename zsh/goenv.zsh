if [[ -d "${HOME}/.goenv" ]]; then
  export GOENV_ROOT="${HOME}/.goenv"
fi

if [[ -x "$(which goenv)" ]]; then
  eval "$(goenv init -)"
fi
