# This is supposed to load up any local configuration files.

if [[ -d ~/.config/dotfiles/zsh ]]; then
  files=$(find ~/.config/dotfiles/zsh/ -name '*.zsh')
  for x in ~/.config/dotfiles/zsh/*.zsh; do
    source "$x"
  done
fi
