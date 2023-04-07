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
alias eksdev='aws eks update-kubeconfig --name bip-dev-eabcf9b3'
alias ekssbx='aws eks update-kubeconfig --name bip-sbx-841804c5'
alias eksprd='aws eks update-kubeconfig --name bip-prod-b7dab922'
