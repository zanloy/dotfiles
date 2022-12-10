install:
  #!/bin/bash
  if [[ -f "/etc/arch-release" ]]; then
    sudo pacman -S --needed git git-delta github-cli
  fi

config:
  #!/bin/bash
  ln -sf $(pwd)/gitconfig ~/.gitconfig
  ln -sf $(pwd)/gitignore ~/.gitignore
