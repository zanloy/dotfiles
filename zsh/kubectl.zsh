if [[ -x "$(command -v kubectl)" ]]; then
  source <(kubectl completion zsh)
  alias k='kubectl'
  complete -F __start_kubectl k
  # Allow you to switch context with: `kctx prod`
  alias kctx="kubectl config use-context"
  # Allow you to switch the current namespace with: `kns logging`
  alias kns="kubectl config set-context --current --namespace"
  # Kubectl aliases
  alias kg="kubectl get"
  alias kgp="kubectl get pods"
  alias kgd="kubectl get daemonsets"
  alias kgc="kubectl get configmaps"
  alias kgi="kubectl get ingress"
  alias kgs="kubectl get services"
  alias kgd="kubectl get deployments"

  alias dev8='kubectl config use-context dev8'
  alias stage8='kubectl config use-context stage8'
  alias prod8='kubectl config use-context prod8'
  alias -- find-pod="kubectl get pods --all-namespaces | grep "
  alias -- find-pods-on-node='tmp_func(){ kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName="$1"; unset -f tmp_func; }; tmp_func'
fi

# Use microk8s by executing `use-mk`
use-mk() {
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

# Find a pod based on regex. Could this be an alias? Sure.
kfind-pod() { kubectl get pods --all-namespaces | grep $1 }

# List the pods that should be targets for a service. I say should because this doesn't check readiness.
kpods-for-service() {
  k get pods --selector $(k get service $1 -o json | jq -r '.spec.selector | to_entries | "\(.[0].key)=\(.[0].value)"')
}
