#!/bin/sh

good = true
if [[ ! -x $(which git) ]]; then
  good = false
  echo "git is not installed."
fi

if [[ ! -x $(which rake) ]]; then
  good = false
  echo "rake is not install."
fi

if [[ ! good ]]; then
  echo "Dependency check failed. Exiting..."
  exit(1)
fi

if [ ! -d "$HOME/.dotfiles" ]; then
  echo "Installing .dotfiles..."
  git clone --depth=1 --recurse-submodules -j8 https://github.com/zanloy/dotfiles.git "$HOME/.dotfiles"
  rake install
else
  echo "~/.dotfiles is already installed"
fi
