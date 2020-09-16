# bat (https://github.com/sharkdp/bat)
# The ubuntu packages for bat rename the executable to prevent a name collision
# with another package so we alias it.
if [ -x /usr/bin/batcat ]; then
  alias bat='batcat'
fi

alias batg='bat --language go'
alias batj='bat --language json'
alias batn='bat --language node'
alias baty='bat --language yaml'
