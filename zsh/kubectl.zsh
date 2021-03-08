if [[ -x "$(command -v kubectl)" ]]; then
  source <(kubectl completion zsh)
  alias k='kubectl'
  complete -F __start_kubectl k
  # Allow you to switch context with: `kctx prod`
  alias kctx="kubectl config use-context"
  # Allow you to switch the current namespace with: `kns logging`
  alias kns="kubectl config set-context --current --namespace"
  # Kubectl aliases
  alias kdp="kubectl describe pod"
  alias kg="kubectl get"
  alias kgc="kubectl get configmap"
  alias kgds="kubectl get daemonset"
  alias kgd="kubectl get deployment"
  alias kge="kubectl get events --sort-by='.metadata.lastTimestamp'"
  alias kgi="kubectl get ingress"
  alias kgn="kubectl get node"
  alias kgns="kubectl get namespace"
  alias kgp="kubectl get pod"
  alias kgs="kubectl get service"
  alias kgss="kubectl get statefulset"
  alias kwp="kubectl get pods --watch"
  alias kwps="tmux split-window -dh 'watch -n 5 kubectl get pods'"

  alias dev='kubectl config use-context dev8'
  alias stage='kubectl config use-context stage8'
  alias prod='kubectl config use-context prod8'
  alias -- kfind-pod="kubectl get pods --all-namespaces | grep "
  alias -- kfind-pods-on-node='tmp_func(){ kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName="$1"; unset -f tmp_func; }; tmp_func'
fi

# Use microk8s by executing `use-mk`
use-mk8s() {
  if [[ -x /snap/bin/microk8s.kubectl ]]; then
    source <(/snap/bin/microk8s.kubectl completion zsh)
    complete -F __start_kubectl k
    alias kns='mkubectl config set-context --current --namespace'
  else
    echo "ERROR: /snap/bin/microk8s.kubectl was not found."
  fi
}

# Execute into a pod either interactively or running a cmd
ke() {
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
