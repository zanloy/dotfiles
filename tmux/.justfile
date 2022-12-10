install:
  #!/bin/bash
  if [[ -f /etc/arch-release ]]; then
    sudo pacman -S tmux
  fi

config:
  #!/bin/bash
  ln -s $(pwd)/tmux.conf
