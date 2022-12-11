install:
  #!/bin/bash
  if [[ -f '/etc/arch-release]]; then
    sudo pacman -S --needed neovim

config:
  #!/bin/bash
  ln -s "$PWD" ~/.config/nvim
