if [[ -x /usr/bin/kubectl ]]; then
  source <(kubectl completion zsh)
  alias k='kubectl'
  complete -F __start_kubectl k

  alias sc="kubectl config set-context --current --namespace"
  alias dev8='kubectl config use-context dev8'
  alias prod8='kubectl config use-context prod8'
  alias -- find-pod="kubectl get pods --all-namespaces | grep "
  alias -- find-pods-on-node='f(){ kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName="$1"; unset -f f; }; f'
fi

if [[ -x /snap/bin/microk8s.kubectl ]]; then
  source <(/snap/bin/microk8s.kubectl completion zsh)
  alias kubectl='/snap/bin/microk8s.kubectl'
  alias k='kubectl'
fi
