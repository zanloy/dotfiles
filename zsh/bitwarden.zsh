# Import the bitwarden cli auto-completions
if [[ -x $(which bw) ]]; then
  source <(bw completion --shell zsh)
fi
