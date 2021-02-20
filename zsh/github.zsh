# Import the github cli auto-completions
if [[ -x $(which gh) ]]; then
  source <(gh completion --shell zsh)
fi
