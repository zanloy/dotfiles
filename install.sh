#!/bin/sh

if [ ! -d "$HOME/.dotfiles" ]; then
  echo "Installing .dotfiles..."
  git clone --depth=1 --recurse-submodules -j8 https://github.com/zanloy/dotfiles.git "$HOME/.dotfiles"
  # TODO: Figure out why the submodules aren't getting pulled in the above command.
  cd "$HOME/.dotfiles"
  git submodule update --init --recursive -j8
  rake install
else
  echo ".dotfiles is already installed"
fi
