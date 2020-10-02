# Aliases in this file are bash and zsh compatible

dotfiles=$HOME/.dotfiles

# Get operating system
platform='unknown'
unamestr=$(uname)
if [[ $unamestr == 'Linux' ]]; then
  platform='linux'
elif [[ $unamestr == 'Darwin' ]]; then
  platform='darwin'
fi

# Global aliases
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g C='| wc -l'
alias -g H='| head'
alias -g L="| less"
alias -g N="| /dev/null"
alias -g S='| sort'
alias -g G='| grep' # now you can do: ls foo G something
alias -g Y='-o yaml | bat --language=yaml' # eg: kubectl get pod pod-name Y

# dpkg/apt support
if [[ -x apt ]]; then
  alias apt='sudo apt'
fi
if [[ -x dpkg ]]; then
  alias dpkg='sudo dpkg'
  alias dgs='dpkg --get-selections | grep'
fi

# PS
alias psa="ps aux"
alias psg="ps aux | grep "

# Show human friendly numbers and colors
alias df='df -h'
alias du='du -h'

if [[ $platform == 'linux' ]]; then
  alias ll='ls -lh --color=auto'
  alias lla='ls -alh --color=auto'
  alias ls='ls --color=auto'
  alias lsa='ls --color=auto'
elif [[ $platform == 'darwin' ]]; then
  alias ll='ls -lGh'
  alias lla='ls -alGh'
  alias ls='ls -Gh'
  alias lsa='ls -aG'
fi

# show me files matching "ls grep"
alias lsg='ll | grep'

# mimic vim functions
alias :q='exit'

# Common shell functions
alias less='less -r'
alias tf='tail -f'
alias l='less'
alias lh='ls -alt | head' # see the last modified files

# Ruby
alias be='bundle exec'

# Zippin
alias gz='tar -zcvf'

# Finder
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

# Homebrew
alias brewu='brew update && brew upgrade && brew cleanup && brew prune && brew doctor'

# View CSV from command line
function pretty-csv {
  column -t -s, -n "$@" | less -F -S -X -K
}
