# Executes a file copy and then changes to the destination.
cpcd() {
  # Get the destination
  dest=${*: -1:1}
  # Execute the copy
  cp $*
  # chdir to the destination
  if [ -d "$dest" ]; then
    cd "$dest"
  else
    cd "${dest:a:h}"
  fi
}

# Executes a file move and then changes to the destination.
mvcd() {
  # Get the destination
  dest=${*: -1:1}
  # Execute the move
  mv $*
  # chdir to the destination
  if [ -d "$dest" ]; then
    cd "$dest"
  else
    cd "${dest:a:h}"
  fi
}
