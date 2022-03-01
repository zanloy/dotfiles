if [[ -x $(which exa) ]]; then
  alias e='exa --git --icons'
  alias el='e --long'
  alias er='e --recurse --level=2'
  alias erl='er --long'
  alias es='el --sort=modified'
  alias est='es'
  alias estr='es --reverse'
  alias et='el --tree --level=2'
fi
