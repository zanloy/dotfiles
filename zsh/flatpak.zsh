# Enable golang
export FLATPAK_ENABLE_SDK_EXT=golang

# Aliases
alias fr="flatpak run"

# Add icons to Application menu
for x in /var/lib/flatpak/exports/share $HOME/.local/share/flatpak/exports/share; do
  if [[ -d "$x" ]]; then
    # check if already in $XDG_DATA_DIRS
    case "$XDG_DATA_DIRS" in
      *$x*) : ;;
      *)
        if [[ -z "$XDG_DATA_DIRS" ]]; then
          XDG_DATA_DIRS="$x"
        else
          XDG_DATA_DIRS="${XDG_DATA_DIRS}:$x"
        fi
        ;;
    esac
  fi
done
