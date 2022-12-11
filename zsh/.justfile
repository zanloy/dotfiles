install:
  #!/bin/bash
  source /etc/os-release
  if [[ $ID_LIKE == "arch" ]]; then
    sudo pacman -S --needed zsh
  fi

config:
  #!/bin/bash
  if [[ ! -d ${ZSH:-~/.oh-my-zsh} ]]; then
    RUNZSH="no" sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  fi
  if [[ ! -f ${ZSH_CUSTOM:-~/.oh-my-zsh/custom/dotfiles.zsh ]]; then
    cat > ~/.oh-my-zsh/custom/dotfiles.zsh <<EOF
  if [[ -d $(pwd) ]]; then
    for x in $(pwd)/*.zsh; do
      source \$x
    done
  fi
  EOF
  fi
