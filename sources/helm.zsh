# :fzf-tab:complete:(\\|*/|)helm:*

local level=$(echo "$words" | tr -cd ' ' | wc -c)

# Trim trailing whitespace
word=$(echo $word | xargs)

# Skip preview for the options
if [[ $word == "-"* ]]; then
  return
fi

# Sub-command, e.g. helm install
if [ $level = 1 ]; then
  if bash -c "tldr helm-$word" 1>/dev/null 2>&1; then
    echo "\$ tldr helm-$word" | bat -pl bash
    tldr --color=always --quiet helm-$word | tail -n +3
  fi

  if bash -c "helm $word --help" >/dev/null 2>&1; then
    echo "$ helm $word --help" | bat -pl bash
    helm $word --help | bat -l help
  fi
fi

if [ $level = 2 ]; then
  # # Remove trailing input
  # local prefix="${words% *}"
  local cmd=$(echo $words | awk '{print $2}')
  # echo "prefix: $prefix"
  echo "cmd: $cmd"

  # Sub-command with nested sub-command, e.g. helm search hub, helm search repo
  if [[ $words =~ " (completion|dependency|get|plugin|registry|repo|search|show|) " ]]; then
    if bash -c "helm $cmd $word --help" >/dev/null 2>&1; then
      echo "$ helm $cmd $word --help" | bat -pl bash
      helm $cmd $word --help | bat -l help
    fi
  fi

  if [[ $words =~ " (env) " ]]; then
    echo "$ helm $cmd $word" | bat -pl bash
    helm $cmd $word
  fi

  if [[ $words =~ " (help) " ]]; then
    if bash -c "helm $cmd $word" >/dev/null 2>&1; then
      echo "$ helm $cmd $word" | bat -pl bash
      helm $cmd $word | bat -l help
    fi
  fi
fi

if [ $level = 3 ]; then
  if [[ $words =~ " (show) " ]]; then
    local prefix=$(echo $words | awk '{print $1,$2,$3}')
    echo "$ $prefix $word" | bat -pl bash
    if [[ $words =~ " (readme) " ]]; then
      eval "$prefix $word" | mdless # Alternative: paper, mdcat
    else
      eval "$prefix $word" | bat -pl yaml
    fi
  fi
fi

debug
