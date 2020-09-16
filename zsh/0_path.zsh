# path, the 0 in the filename causes this to load first
path+=("$HOME/bin")
path+=("$HOME/.dotfiles/bin")

if [ -d '/snap/bin' ]; then
  path+=('/snap/bin')
fi
