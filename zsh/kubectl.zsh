if [[ -x "$(command -v kubectl)" ]]; then
  source <(kubectl completion zsh)
  alias k='kubectl'
  complete -F __start_kubectl k
  # Allow you to switch context with: `kctx prod`
  #alias kctx="kubectl config use-context" # this is replaced with a kubectl plugin
  # Allow you to switch the current namespace with: `kns logging`
  #alias kns="kubectl config set-context --current --namespace" # this is replaced with a kubectl plugin

  ### Kubectl aliases ###
  declare -a verbs
  verbs=(d:describe del:delete e:edit g:get w:watch)
  kinds=(cj:cronjob cm:configmap d:deployment ds:daemonset i:ingress j:job n:node ns:namespace p:pod s:service sec:secret ss:statefulset)

  for verb in $verbs; do
    aVerb=("${(s/:/)verb}")
    eval "alias k${aVerb[1]}='kubectl ${aVerb[2]}'"
    for kind in $kinds; do
      aKind=("${(s/:/)kind}")
      eval "alias k${aVerb[1]}${aKind[1]}='kubectl ${aVerb[2]} ${aKind[2]}'"
    done
  done

  alias kge="kubectl get events --sort-by='.metadata.lastTimestamp'"
  alias kexec="kubectl exec -it"
  alias kwp="kubectl get pods --watch"
  alias kwps="tmux split-window -dh 'watch -n 5 kubectl get pods'"
  # Plugins
  if [[ -x $(which kubectl-custom_cols) ]]; then
    alias kcc="kubectl custom-cols -o"
    alias kcci="kubectl custom-cols -o images"
    alias kccl="kubectl custom-cols -o limits"
  fi
  if [[ -x $(which kubectl-ipick) ]]; then
    alias kp="kubectl ipick"
    for verb in $verbs; do
      aVerb=("${(s/:/)verb}")
      eval "alias kp${aVerb[1]}='kubectl ipick ${aVerb[2]}'"
      for kind in $kinds; do
        aKind=("${(s/:/)kind}")
        eval "alias kp${aVerb[1]}${aKind[1]}='kubectl ipick ${aVerb[2]} ${aKind[2]} --'"
      done
    done
    alias kpl="kubectl ipick logs"
  fi
  if [[ -x $(which kubectl-modify_secret) ]]; then
    alias kmsec="kubectl modify-secret"
  fi
  if [[ -x $(which kubectl-view_secret) ]]; then
    alias kvsec="kubectl view-secret"
  fi
  if [[ -x $(which kubectl-node_shell) ]]; then
    alias kns="kubectl node-shell"
  fi

  alias dev='kubectl config use-context dev8'
  alias stage='kubectl config use-context stage8'
  alias prod='kubectl config use-context prod8'
  alias pve='kubectl config use-context pve'
  # Spin up temporary pod with debuging image
  alias kdebug='k run tmp-netshoot --image zanloy/netshoot-va -it --rm --restart=Never -- /bin/bash'
  alias kbb='k run tmp-bb --image=busybox -it --rm --restart=Never --'
  alias -- kfind-pod="kubectl get pods --all-namespaces | grep "
  alias -- kfind-pods-on-node='tmp_func(){ kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName="$1"; unset -f tmp_func; }; tmp_func'
fi

# Add krew to path if available
if [[ -d "${KREW_ROOT:-$HOME/.krew}/bin" ]]; then
  path+=("${KREW_ROOT:-$HOME/.krew}/bin")
fi

# Execute into a pod either interactively or running a cmd
kexe() {
  if [ $# -gt 2 ]; then
    # Assume we aren't running interactively
    kubectl exec "$1" -- ${@:2}
  else
    if [[ ! -v 2 ]]; then # If no shell was specified, we test is bash exists first.
      kubectl exec "$1" -- [ -x /bin/bash ] &> /dev/null
      if [ $? -eq 0 ]; then
        2='/bin/bash'
      else
        2='/bin/sh'
      fi
    fi
    kubectl exec -it "$1" -- ${2:-/bin/sh}
  fi
}

# List the pods that should be targets for a service. I say should because this doesn't check readiness.
kpods-for-service() {
  k get pods --selector $(k get service $1 -o json | jq -r '.spec.selector | to_entries | "\(.[0].key)=\(.[0].value)"')
}
