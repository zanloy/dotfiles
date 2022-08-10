alias ecrlogin='aws ecr get-login-password --region us-gov-west-1 | docker login --username AWS --password-stdin $(aws sts get-caller-identity --query Account --output text).dkr.ecr.us-gov-west-1.amazonaws.com'
alias ecrpush='_ecrpush(){ docker push "$(aws sts get-caller-identity --query Account --output text)".dkr.ecr.us-gov-west-1.amazonaws.com/"$1"}; _ecrpush'
alias ecrpull='_ecrpull(){ docker pull "$(aws sts get-caller-identity --query Account --output text)".dkr.ecr.us-gov-west-1.amazonaws.com/"$1"}; _ecrpull'

# AWS ECR
function ecrpush(){
  docker push "$(aws sts get-caller-identity --query Account --output text)".dkr.ecr.us-gov-west-1.amazonaws.com/"$1"
}

function ecrpull(){
  docker pull "$(aws sts get-caller-identity --query Account --output text)".dkr.ecr.us-gov-west-1.amazonaws.com/"$1"
}
