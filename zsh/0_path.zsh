# path, the 0 in the filename causes this to load first
path+=("$HOME/.local/bin")
path+=("$HOME/.dotfiles/bin")

# golang
if [ -d "$HOME/go/bin" ]; then
  path+=("$HOME/go/bin")
fi

# snap
if [ -d '/snap/bin' ]; then
  path+=('/snap/bin')
fi
