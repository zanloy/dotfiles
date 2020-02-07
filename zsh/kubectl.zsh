if [[ -x /usr/bin/kubectl ]]; then
  source <(kubectl completion zsh)
  alias k=kubectl
  complete -F __start_kubectl k
fi

if [[ -x /snap/bin/microk8s.kubectl ]]; then
  source <(/snap/bin/microk8s.kubectl completion zsh)
  alias kubectl=/snap/bin/microk8s.kubectl
  alias k=kubectl
fi
