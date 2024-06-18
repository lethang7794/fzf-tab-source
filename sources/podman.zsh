# :fzf-tab:complete:(\\|*/|)podman:*

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
else
  debug
fi
