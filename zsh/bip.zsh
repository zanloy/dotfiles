gwlogin ()
{
    if [ -z "$1" ]; then
        echo "No cluster supplied. e.g: ${0} dev"
        return 1
    fi
    cluster=$1
    cookiejar=$(mktemp)
    url="https://gangway.${cluster}.bip.va.gov"
    bwunlock
    user=$(bw get username idm.${cluster}.bip.va.gov)
    password=$(bw get password idm.${cluster}.bip.va.gov)
    req=$(curl -kLs "${url}/login" -c ${cookiejar} -o /dev/null -w "%{url_effective}")
    state=$(echo "$req" | grep -oP "(?<=state=)\w*")
    curl -kLs "${req}" --data-urlencode "login=${user}" --data-urlencode "password=${password}" -c ${cookiejar} -b ${cookiejar} -o /dev/null
    resp=$(curl -kL "${url}/kubeconf" -c ${cookiejar} -b ${cookiejar} -o "${HOME}/.kube/config-${cluster}" -w "%{response_code}")
    if [[ "${resp}" -eq "200" ]]; then
      export KUBECONFIG="${HOME}/.kube/config-${cluster}"
    else
      echo "ERROR: Curling kubeconf failed with status: ${?}"
    fi
    rm ${cookiejar}
}
