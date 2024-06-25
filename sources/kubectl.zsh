# :fzf-tab:complete:(\\|*/|)kube(color|ctl):*

local level=$(echo "$words" | tr -cd ' ' | wc -c)

# Function to parse kubectl explain output
kubectl_explain() {
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

bat_bash() {
  echo $@ | bat -pl bash
}
bat_help() {
  echo $@ | bat -pl help
}

if [[ $level -eq 1 ]] && [[ $group = "completions" ]] || [[ $words =~ "kube(ctl|color) help " ]]; then
  if bash -c "tldr kubectl-$word" 1>/dev/null 2>&1; then
    bat_bash "$ tldr kubectl-$word"
    tldr --color=always --quiet kubectl-$word | tail -n +3
  fi

  if bash -c "kubectl $word --help" >/dev/null 2>&1; then
    bat_help "$ kubectl $word --help"
    kubectl $word --help | bat -lhelp
  fi

  if bash -c "kubectl $word --help" >/dev/null 2>&1; then
    bat_help "$ kubectl $word --help"
    kubectl $word --help | bat -lhelp
  fi

  printf "\n$ man kubectl-%q\n" $word
  man kubectl-$word | bat -lman

  return
fi

if [[ $level -eq 2 ]] && [[ $group = "completions" ]]; then

  if [[ $words =~ "annotate|delete|edit|get|describe|expose|label|patch" ]]; then

    [[ $word =~ "/" ]] && local isResource=true || local isResourceType=true

    if [ $isResourceType ]; then
      bat_bash "$ kubectl get $word"
      kubectl get $word | bat -l bash
      echo

      # Show the fields for describe
      if [[ $words =~ "describe" ]]; then
        bat_bash "$ kubectl explain $word"
        kubectl explain $word | bat -l yaml
      else
        bat_bash "$ kubectl explain $word "
        kubectl_explain $word | bat -l yaml
      fi
    fi

    if [ $isResource ]; then
      local type="${word%/*}"

      bat_bash "$ kubectl get $word -o wide"
      kubectl get $word -o wide | bat -l bash
      echo
      bat_bash "$ kubectl explain $type"
      kubectl_explain $type | bat -l yaml

      bat_bash "$ kubectl get $word -o yaml"
      kubectl get $word -o yaml | bat -l yaml
      echo
      bat_bash "$ kubectl describe $word"
      kubectl describe $word | bat -l yaml
    fi

  fi

  if [[ $words =~ "cordon|uncordon" ]]; then

    bat_bash "$ kubectl get nodes/$word "
    kubectl get nodes/$word | bat -l bash

    echo
    bat_bash "$ kubectl describe nodes/$word"
    kubectl describe nodes/$word | bat -l yaml

    echo
    bat_bash "$ kubectl explain node"
    kubectl explain node | bat -l help

  fi

  if [[ $words =~ "attach|port-forward|logs" ]]; then
    # An item with a trailing slash / is a resource type, e.g. pods, deamonsets, deployments
    # An item without a trailing slash is a pod name, e.g. etcd-minikube, storage-provisioner, coredns-7db6d8ff4d-ng729, kube-proxy-7c4vr

    local item=$(echo $word | sed -Ee 's/:|\///g')
    if [[ ! $words =~ "/" ]] && [[ ! $word =~ "/" ]]; then
      local isPod=true
    elif [[ ! $words =~ "/" ]] && [[ $word =~ "/" ]]; then
      local isResourceType=true
    elif [[ $words =~ "/" ]] && [[ $word =~ "/" ]]; then
      local isResource=true
    fi

    if [ $isPod ]; then
      bat_bash "$ kubectl get pods $item -o wide"
      kubectl get pods $item -o wide | bat -l bash

      echo
      bat_bash "$ kubectl explain pods"
      kubectl_explain pods | bat -l help

      bat_bash "$ kubectl describe pods $item"
      kubectl describe pods $item | bat -l bash
    fi

    if [ $isResourceType ]; then
      bat_bash "$ kubectl get $item"
      kubectl get $item | bat -l bash

      echo
      bat_bash "$ kubectl explain $item"
      kubectl_explain $item | bat -l help
    fi

    if [ $isResource ]; then
      # Remove trailing input
      local prefix="${words% *}"
      local resourceType="${word%%/*}"

      bat_bash "$ kubectl get $word -o wide"
      kubectl get $word -o wide | bat -l bash

      echo
      bat_bash "$ kubectl explain $resourceType"
      kubectl_explain $resourceType | bat -l help

      bat_bash "$ kubectl describe $word"
      kubectl describe $word | bat -l bash
    fi
  fi

  if [[ $words =~ "certificate" ]]; then

    if bash -c "kubectl certificate $word --help" >/dev/null 2>&1; then
      bat_bash "$ kubectl certificate $word --help"
      kubectl certificate $word --help | bat -lhelp
    fi

    printf "\n\$ man kubectl-certificate-%q\n" $word
    man kubectl-certificate-$word | bat -lman

  fi

  if [[ $words =~ "apply" ]]; then

    if bash -c "kubectl apply $word --help" >/dev/null 2>&1; then
      bat_bash "$ kubectl apply $word --help"
      kubectl apply $word --help | bat -lhelp
    fi

    printf "\n\$ man kubectl-apply-%q\n" $word
    man kubectl-apply-$word | bat -lman

  fi

  if [[ $words =~ "rollout" ]]; then

    if bash -c "kubectl rollout $word --help" >/dev/null 2>&1; then
      bat_bash "$ kubectl rollout $word --help"
      kubectl rollout $word --help | bat -lhelp
    fi

    printf "\n\$ man kubectl-rollout-%q\n" $word | bat -l bash
    man kubectl-rollout-$word | bat -lman

  fi

  if [[ $words =~ "auth" ]]; then

    if bash -c "kubectl auth $word --help" >/dev/null 2>&1; then
      bat_bash "$ kubectl auth $word --help"
      kubectl auth $word --help | bat -lhelp
    fi

    printf "\n\$ man kubectl-auth-%q\n" $word | bat -l bash
    man kubectl-auth-$word | bat -lman

  fi

  if [[ $words =~ "config" ]]; then

    if [[ $word =~ "current|get" ]]; then
      bat_bash "$ kubectl config $word"
      kubectl config $word | bat -l bash
      echo
    fi

    if bash -c "kubectl config $word --help" >/dev/null 2>&1; then
      bat_bash "$ kubectl config $word --help"
      kubectl config $word --help | bat -lhelp
    fi

    printf "\n\$ man kubectl-config-%q\n" $word
    man kubectl-config-$word | bat -lman

    return
  fi

  if [[ $words =~ "create" ]]; then

    if bash -c "kubectl create $word --help" >/dev/null 2>&1; then
      bat_bash "$ kubectl create $word --help"
      kubectl create $word --help | bat -lhelp
    fi

    printf "\n\$ man kubectl-create-%q\n" $word
    man kubectl-create-$word | bat -lman

  fi

  if [[ $words =~ " set " ]]; then

    if bash -c "kubectl set $word --help" >/dev/null 2>&1; then
      bat_bash "$ kubectl set $word --help"
      kubectl set $word --help | bat -lhelp
    fi

    printf "\n\$ man kubectl-set-%q\n" $word
    man kubectl-set-$word | bat -lman

  fi

  if [[ $words =~ "cp" ]]; then
    local item=$(echo $word | sed -Ee 's/:|\///g')
    [[ $word =~ ":" ]] && local isPod=true
    [[ $word =~ "/" ]] && local isNamespace=true

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

  if [[ $words =~ " (annotate|delete|edit|get|describe|expose|label|patch) " ]]; then
    local resourceType=$(echo $words | awk '{print $3}')
    # echo resourceType: $resourceType

    bat_bash "$ kubectl get $resourceType $word -o wide"
    kubectl get $resourceType $word -o wide | bat -l bash

    echo
    bat_bash "$ kubectl explain $resourceType" | bat -l bash
    kubectl_explain $resourceType | bat -l yaml

    bat_bash "$ kubectl get $resourceType $word -o yaml"
    kubectl get $resourceType $word -o yaml | bat -l yaml

    echo
    bat_bash "$ kubectl describe $resourceType $word"
    kubectl describe $resourceType $word | bat -l yaml
  fi

  if [[ $words =~ " apply " ]]; then

    local isResource isResourceType resourceType resource
    if [[ $word =~ "/" ]]; then
      isResource="true"
      resourceType=$(echo $word | awk -F'/' '{print $1}')
      resource=$(echo $word | awk -F'/' '{print $2}')
    else
      isResourceType=true
      resourceType=$word
    fi

    if [ $isResourceType ]; then
      bat_bash "$ kubectl get $resourceType"
      kubectl get $resourceType | bat -l bash
      echo
      bat_bash "$ kubectl explain $resourceType"
      kubectl_explain $resourceType | bat -l yaml
    else
      bat_bash "$ kubectl get $resourceType $resource -o wide"
      kubectl get $resourceType $resource -o wide | bat -l bash

      echo
      bat_bash "$ kubectl apply view-last-applied $resourceType $resource"
      kubectl apply view-last-applied $resourceType $resource | bat -l yaml

      echo
      bat_bash "$ kubectl explain $resourceType"
      kubectl explain $resourceType | bat -l yaml

      bat_bash "$ kubectl get $resourceType $resource -o yaml"
      kubectl get $resourceType $resource -o yaml | bat -l yaml
    fi

  fi

  if [[ $words =~ " taint node " ]]; then
    bat_bash "$ kubectl get nodes/$word "
    kubectl get nodes/$word | bat -l bash

    echo
    bat_bash "$ kubectl describe nodes/$word "
    kubectl describe nodes/$word | bat -l yaml

    echo
    bat_bash "$ kubectl explain node "
    kubectl explain node | bat -l help
  fi

fi

if [[ $level -eq 4 ]] && [[ $group = "completions" ]]; then
  if [[ "$words" =~ " apply " ]]; then
    local resourceType=$(echo $words | awk '{print $4}')

    bat_bash "$ kubectl get $resourceType $word -o wide"
    kubectl get $resourceType $word -o wide | bat -l bash

    echo
    bat_bash "$ kubectl apply view-last-applied $resourceType $word"
    kubectl apply view-last-applied $resourceType $word | bat -l yaml

    echo
    bat_bash "$ kubectl get $resourceType $word -o yaml"
    kubectl get $resourceType $word -o yaml | bat -l yaml
  fi
fi
