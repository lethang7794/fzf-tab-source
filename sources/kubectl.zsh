# :fzf-tab:complete:(\\|*/|)kube(color|ctl):*

debug

local level=$(echo "$words" | tr -cd ' ' | wc -c)
echo level: $level

# Function to parse kubectl explain output
parse_kubectl_explain() {
  local resource_type=$1

  # Capture the output of 'kubectl explain <resource_type>'
  local output=$(kubectl explain "$resource_type")

  # Use awk to extract the required fields
  echo "$output" | awk '
  BEGIN {
    foundKind = 0;
    foundVersion = 0;
    foundDescription = 0;
  }
  {
    if ($1 == "KIND:" && foundKind == 0) {
      print $0;
      foundKind = 1;
    }
    if ($1 == "VERSION:" && foundVersion == 0) {
      print $0;
      foundVersion = 1;
    }
    if ($1 == "DESCRIPTION:" && foundDescription == 0) {
      print $0;
      foundDescription = 1;
      inDescription = 1;
    } else if (inDescription && $0 !~ /^FIELDS:/) {
      print $0;
    } else if ($0 ~ /^FIELDS:/) {
      inDescription = 0;
    }
  }'
}

if [[ $level -eq 1 ]] && [[ $group = "completions" ]] || [[ $words =~ "kubecolor help " ]]; then

  if bash -c "kubectl $word --help" >/dev/null 2>&1; then
    echo "$ kubectl $word --help"
    kubectl $word --help | bat -lhelp
  fi

  printf "\n\$ man kubectl-%q\n" $word
  man kubectl-$word | bat -lman

  return
fi

if [[ $level -eq 2 ]] && [[ $group = "completions" ]]; then

  if [[ $words =~ "annotate|delete|edit|get|describe|expose|label|patch" ]]; then

    echo "$ kubectl get $word " | bat -l bash
    kubectl get $word | bat -l bash

    echo
    echo "$ kubectl explain $word " | bat -l bash
    parse_kubectl_explain $word | bat -l yaml

  fi

  if [[ $words =~ "cordon|uncordon" ]]; then

    echo "$ kubectl get nodes/$word " | bat -l bash
    kubectl get nodes/$word | bat -l bash

    echo
    echo "$ kubectl describe nodes/$word "
    kubectl describe nodes/$word | bat -l yaml

    echo
    echo "$ kubectl explain node "
    kubectl explain node | bat -l help

  fi

  if [[ $words =~ "logs" ]]; then
    local type=${word::-1}

    echo "$ kubectl get $type "
    kubectl get $type | bat -l bash

    echo
    echo "$ kubectl explain $type "
    parse_kubectl_explain $type | bat -l help
  fi

  if [[ $words =~ "attach|port-forward" ]]; then
    local type=${word}
    if [[ $word =~ "/" ]]; then
      local type=${word::-1}
      echo "$ kubectl get $type " | bat -l bash
      kubectl get $type | yq --colors

      echo
      echo "$ kubectl explain $type " | bat -l bash
      kubectl explain $type | bat -l help
      kubectl describe pod $type | bat -l yaml
    fi

  fi

  if [[ $words =~ "certificate" ]]; then

    if bash -c "kubectl certificate $word --help" >/dev/null 2>&1; then
      echo "$ kubectl certificate $word --help" | bat -l bash
      kubectl certificate $word --help | bat -lhelp
    fi

    printf "\n\$ man kubectl-certificate-%q\n" $word
    man kubectl-certificate-$word | bat -lman

  fi

  if [[ $words =~ "rollout" ]]; then

    if bash -c "kubectl rollout $word --help" >/dev/null 2>&1; then
      echo "$ kubectl rollout $word --help" | bat -l bash
      kubectl rollout $word --help | bat -lhelp
    fi

    printf "\n\$ man kubectl-rollout-%q\n" $word | bat -l bash
    man kubectl-rollout-$word | bat -lman

  fi

  if [[ $words =~ "auth" ]]; then

    if bash -c "kubectl auth $word --help" >/dev/null 2>&1; then
      echo "$ kubectl auth $word --help"
      kubectl auth $word --help | bat -lhelp
    fi

    printf "\n\$ man kubectl-auth-%q\n" $word | bat -l bash
    man kubectl-auth-$word | bat -lman

  fi

  if [[ $words =~ "config" ]]; then

    if [[ $word =~ "current|get" ]]; then
      echo "$ kubectl config $word" | bat -l bash
      kubectl config $word | bat -l bash
      echo
    fi

    if bash -c "kubectl config $word --help" >/dev/null 2>&1; then
      echo "$ kubectl config $word --help" | bat -l bash
      kubectl config $word --help | bat -lhelp
    fi

    printf "\n\$ man kubectl-config-%q\n" $word | bat -l bash
    man kubectl-config-$word | bat -lman

    return
  fi

  if [[ $words =~ "create" ]]; then

    if bash -c "kubectl create $word --help" >/dev/null 2>&1; then
      echo "$ kubectl create $word --help" | bat -l bash
      kubectl create $word --help | bat -lhelp
    fi

    printf "\n\$ man kubectl-create-%q\n" $word | bat -l bash
    man kubectl-create-$word | bat -lman

  fi

  if [[ $words =~ "set" ]]; then

    if bash -c "kubectl set $word --help" >/dev/null 2>&1; then
      echo "\$ kubectl set $word --help" | bat -l bash
      kubectl set $word --help | bat -lhelp
    fi

    printf "\n\$ man kubectl-set-%q\n" $word | bat -l bash
    man kubectl-set-$word | bat -lman

  fi

  if [[ $words =~ "cp" ]]; then
    item=$(echo $word | sed -Ee 's/:|\///g')
    [[ $word =~ ":" ]] && isPod=true
    [[ $word =~ "/" ]] && isNamespace=true

    if [ $isPod ] && [ $isNamespace ]; then
      // TODO: parse "namespace/pod:" and show the pod information
      return
    fi
    if [ $isPod ]; then
      echo \$ kubectl get pods $item | bat -l bash
      kubectl get pods $item | bat -l bash
      echo
      echo \$ kubectl describe pods $item | bat -l bash
      kubectl describe pods $item | bat -l yaml
    fi
    if [ $isNamespace ]; then
      echo \$ kubectl get pods --namespace=$item | bat -l bash
      kubectl get pods --namespace=$item | bat -l bat
    fi

  fi

fi

if [[ $level -eq 3 ]] && [[ $group = "completions" ]]; then
  if [[ $words =~ " config " ]]; then
    if [[ $words =~ "context" ]]; then
      echo \$ kubectl config get-contexts $word | bat -l bash
      kubectl config get-contexts $word | bat -l bash
    elif [[ $words =~ "cluster" ]]; then
      echo \$ kubectl config get-clusters $word | bat -l bash
      kubectl config get-clusters $word | bat -l bash
    elif [[ $words =~ "user" ]]; then
      echo \$ kubectl config get-users $word | bat -l bash
      kubectl config get-users $word | bat -l bash
    fi
  fi

  if [[ $words =~ " describe " ]]; then
    # Remove trailing input
    local prefix="${words% *}"
    local prefixGet=$(echo $prefix | sed 's/describe/get/g')

    echo "\$ $prefixGet $word -o wide" | bat -l bash
    eval "$prefixGet $word -o wide" | bat -l bash
    echo
    echo "\$ $prefix $word" | bat -l bash
    eval "$prefix $word" | bat -l yaml
  fi

  if [[ $words =~ " get " ]]; then
    # Remove trailing input
    local prefix="${words% *}"
    local prefixDescribe=$(echo $prefix | sed 's/get/describe/g')
    local prefixExplain=$(echo $prefix | sed 's/get/explain/g')

    echo "\$ $prefix $word -o wide" | bat -l bash
    eval "$prefix $word -o wide" | bat -l bash
    echo
    echo "\$ $prefixExplain" | bat -l bash
    eval "$prefixExplain" | bat -l yaml
    echo "\$ $prefix $word -o yaml" | bat -l bash
    eval "$prefix $word -o yaml" | bat -l yaml
    echo
    echo "\$ $prefixDescribe $word" | bat -l bash
    eval "$prefixDescribe $word" | bat -l yaml
  fi

  if [[ $words =~ " taint node " ]]; then
    echo "$ kubectl get nodes/$word " | bat -l bash
    kubectl get nodes/$word | bat -l bash

    echo
    echo "$ kubectl describe nodes/$word " | bat -l bash
    kubectl describe nodes/$word | bat -l yaml

    echo
    echo "$ kubectl explain node " | bat -l bash
    kubectl explain node | bat -l help
  fi

fi
