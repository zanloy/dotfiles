# Aliases for AWS service

# ECR
alias ecrlogin='aws ecr get-login-password --region us-gov-west-1 | docker login --username AWS --password-stdin $(aws sts get-caller-identity --query Account --output text).dkr.ecr.us-gov-west-1.amazonaws.com'
alias ecrpush='_ecrpush(){ docker push "$(aws sts get-caller-identity --query Account --output text)".dkr.ecr.us-gov-west-1.amazonaws.com/"$1"}; _ecrpush'
alias ecrpull='_ecrpull(){ docker pull "$(aws sts get-caller-identity --query Account --output text)".dkr.ecr.us-gov-west-1.amazonaws.com/"$1"}; _ecrpull'

function ecrpush(){
  docker push "$(aws sts get-caller-identity --query Account --output text)".dkr.ecr.us-gov-west-1.amazonaws.com/"$1"
}

function ecrpull(){
  docker pull "$(aws sts get-caller-identity --query Account --output text)".dkr.ecr.us-gov-west-1.amazonaws.com/"$1"
}

# EKS
alias eks='aws eks update-kubeconfig --name'
alias eksdev='aws eks update-kubeconfig --name bip-dev-eabcf9b3'
alias ekssbx='aws eks update-kubeconfig --name bip-sbx-b2348ebe'
alias eksstage='aws eks update-kubeconfig --name bip-stage-cac7e6ba'
alias eksprd='aws eks update-kubeconfig --name bip-prod-b7dab922'
alias ekspreprd='aws eks update-kubeconfig --name bip-preprod-345352c3'

function myeks {
  default=zanloy
  target=${1:-$default}
  for cluster in $(aws eks list-clusters | jq -r '.clusters[]'); do
    state_key=$(aws eks describe-cluster --name $cluster | jq -r '.cluster.tags.state_key')
    if [[ $(echo ${state_key} | egrep $target -) ]]; then
      echo "Switching to ${cluster}: ${state_key}"
      aws eks update-kubeconfig --name ${cluster}
      return
    fi
  done
}
