# :fzf-tab:complete:((\\|*/|)docker):argument-1

# Skip the options
if [[ "$desc" =~ ^"-" ]]; then
  return
fi

if bash -c "tldr docker $word" >/dev/null 2>&1; then
  echo "$ tldr docker $word"
  tldr --color=always docker $word | tail -n +3
fi

if bash -c "docker help $word" >/dev/null 2>&1; then
  echo "$ docker help $word"
  docker help $word | bat -lhelp
fi

echo \$ man docker-$word
man docker-$word 2>/dev/null | bat -lman
