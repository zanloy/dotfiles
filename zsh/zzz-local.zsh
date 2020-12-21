# This is supposed to load up any local configuration files.
for x in ~/.config/dotfiles/zsh/*.zsh; do
  source "$x"
done
