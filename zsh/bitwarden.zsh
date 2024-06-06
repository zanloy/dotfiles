# Import the bitwarden cli auto-completions
if [[ -x $(which bw) ]]; then
  source <(bw completion --shell zsh)
fi

bwunlock() {
  bw unlock --check > /dev/null
  if [[ $? != 0 ]]; then
    export BW_SESSION=$(bw unlock --raw)
  fi
}
