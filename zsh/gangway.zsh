cle ()
{
    if [ -z "$1" ]; then
        echo 'No cluster supplied. e.g: cluster_login dev'
        return 1
    fi
    cluster=$1
    urlgang="https://gangway.${cluster}.bip.va.gov"
    urldex="https://platform.${cluster}.bip.va.gov/oidc/${cluster}"
    bipuser='aloy'
    bippass='g$7WWShmDGjMm9R2&vkjB'
    req=$(curl -k -s "$urlgang/login" -L -c temp.cj | sed -n "s:^.*form.*action=\"/oidc/${cluster}/auth/ldap/login?back=\&amp;state=\([^\"]*\)\".*$:\1:p")
    curl -k "$urldex/auth/ldap/login?back=\&amp;state=$req" -F "login=$bipuser" -F "password=$bippass" -s > /dev/null
    token=$(curl -k -s "$urldex/approval?req=$req" -c temp.cj -b temp.cj -L -s | sed -n "s/.*--auth-provider-arg='id-token=\([^']*\)'$/\1/p")
    curl -k "$urlgang/kubeconf" -b temp.cj --output ~/.kube/config-${cluster} -s
    rm temp.cj
    export KUBECONFIG=~/.kube/config-${cluster}
}
