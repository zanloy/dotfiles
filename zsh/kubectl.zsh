use-mk() {
  if [[ -x /snap/bin/microk8s.kubectl ]]; then
    source <(/snap/bin/microk8s.kubectl completion zsh)
    complete -F __start_kubectl k
    alias kns='mkubectl config set-context --current --namespace'
  else
    echo "ERROR: /snap/bin/microk8s.kubectl was not found."
  fi
}

if [[ -x "$(command -v kubectl)" ]]; then
  source <(kubectl completion zsh)
  alias k='kubectl'
  complete -F __start_kubectl k
  alias kns="kubectl config set-context --current --namespace"
  alias dev8='kubectl config use-context dev8'
  alias stage8='kubectl config use-context stage8'
  alias prod8='kubectl config use-context prod8'
  alias -- find-pod="kubectl get pods --all-namespaces | grep "
  alias -- find-pods-on-node='tmp_func(){ kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName="$1"; unset -f tmp_func; }; tmp_func'
fi
