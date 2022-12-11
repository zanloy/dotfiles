install:
  #!/bin/bash
  if [[ -f '/etc/arch-release']]; then
    sudo pacman -S --needed alacritty

config:
  #!/bin/bash
  mkdir -p ~/.config/alacritty
  ln -s $(pwd)/alacritty.yml ~/.config/alacritty/alacritty.yml
