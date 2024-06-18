# :fzf-tab:complete:(\\|*/|)podman:*

# Skip the options
if [[ "$desc" =~ ^"-" ]]; then
  return
fi

if [[ $words == "podman " ]]; then
  if bash -c "tldr podman $word" >/dev/null 2>&1; then
    echo "$ tldr podman $word"
    tldr --color=always podman $word | tail -n +3
  fi

  if bash -c "podman help $word" >/dev/null 2>&1; then
    echo "$ podman help $word"
    podman help $word | bat -lhelp
  fi

  echo \$ man podman-$word
  man podman-$word 2>/dev/null | bat -lman

elif [[ $words == "podman container " ]]; then
  if bash -c "tldr podman container $word" >/dev/null 2>&1; then
    echo "$ tldr podman container $word"
    tldr --color=always podman container $word | tail -n +3
  fi

  if bash -c "podman container $word --help" >/dev/null 2>&1; then
    echo "$ podman container $word --help"
    podman container $word --help | bat -lhelp
  fi

  echo \$ man podman-container-$word
  man podman-container-$word 2>/dev/null | bat -lman

elif [[ $words =~ "podman container" ]]; then
  if [[ $words =~ "attach|checkpoint|cleanup|clone|commit|cp|create|exec|export|init|inspect|kill|list|mount|pause|prune|ps|rename|restart|restore|rm|runlabel|start|stats|stop|unmount|unpause|update|wait" ]]; then
    echo "$ podman container inspect $word"
    podman container inspect $word | jq --color-output
  elif [[ $words =~ "diff|exists|logs|port" ]]; then
    echo "$ $words$word"
    $words$word | jq --color-output
  elif [[ $words =~ "run" ]]; then
    echo "$ podman image inspect $word"
    podman image inspect $word | jq --color-output
  elif [[ $words =~ "top" ]]; then
    echo "$ $words$word"
    $words$word
  else
    debug
  fi

else
  debug
fi
