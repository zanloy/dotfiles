# path, the 0 in the filename causes this to load first

function _addPath {
  if [[ $2 = true || $2 = false ]]; then
    prepend=$2
  else
    prepend=false
  fi

  # check if path exists and is a directory
  if [[ ! -d $1 ]]; then
    return
  fi

  # check if path already in $PATH
  case "$path" in
    *$1*) : ;; # already exists
    *)
      if [ $prepend = true ]; then
        # prepend
        path=("$1" $path)
      else
        # append
        path+=("$1")
      fi
      ;;
  esac
}

_addPath "${HOME}/.local/bin"
_addPath "${HOME}/.dotfiles/bin"

# goenv
_addPath "${HOME}/.goenv/bin"

# golang
_addPath "${HOME}/go/bin" true
_addPath "/usr/local/go/bin" true

# linuxbrew
_addPath "/home/linuxbrew/.linuxbrew/bin" true
_addPath "${HOME}/.linuxbrew/bin" true

# nodenv
_addPath "${HOME}/.nodenv/bin" true

# pyenv
_addPath "${HOME}/.pyenv/bin" true
_addPath "${HOME}/.pyenv/shims" true

# rbenv
_addPath "${HOME}/.rbenv/bin" true

# snap
_addPath "${HOME}/snap/bin"
