install:
  #!/bin/bash
  if [[ -f '/etc/arch-release' ]]; then
    sudo pacman -S --needed tmux
  fi

config:
  #!/bin/bash
  if [[ -d ~/.oh-my-tmux ]]; then
    git clone https://github.com/gpakosz/.tmux.git ~/.oh-my-tmux
  fi
  ln -sf $(pwd)/tmux.conf ~/.tmux.conf
