# :fzf-tab:complete:(\\|*/|)minikube:*

# debug

local level=$(echo "$words" | tr -cd ' ' | wc -c)
# echo level: $level

if [[ $group == "file" ]]; then
  less $word
  return
fi

# Options
if [[ $words == *"-" ]]; then
  local pattern=$([[ $word == "--"* ]] && echo "$word" || echo "$word,")
  local global=$(minikube options | grep -E -- "$pattern" | bat -l help)

  if [[ -n "$global" ]]; then
    echo "$ minikube options"
    echo $global
  else
    local prefix=$(echo "$words" | sed -E 's/( -| --)//g')
    echo "$ $prefix --help"
    # eval "$prefix --help"
    eval "$prefix --help" | grep -A 1 -E -- "$pattern" | bat -l help
  fi

  return
fi

if [ $level = 1 ]; then
  if bash -c "minikube $word --help" >/dev/null 2>&1; then
    echo "$ minikube $word --help"
    minikube $word --help | bat -lhelp
  fi
fi

if [ $level = 2 ]; then
  local cmd=$(echo $words | awk '{print $2}')
  if bash -c "minikube $cmd $word --help" >/dev/null 2>&1; then
    echo "$ minikube $cmd $word --help"
    minikube $cmd $word --help | bat -lhelp
  fi
fi
