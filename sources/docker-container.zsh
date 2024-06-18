# :fzf-tab:complete:docker-container:*
echo ':fzf-tab:complete:docker-container:*'

if [[ $group == "docker container command" ]]; then

  if bash -c "tldr docker container $word" >>/dev/null 2>&1; then
    echo "$ tldr docker container $word"
    tldr --color=always docker container $word | tail -n +3
  fi

  echo \$ docker container $word --help
  docker container $word --help

elif [[ $group == "container" ]]; then
  fzf-tab-source-debug
elif [[ $group == "old name" ]]; then
  fzf-tab-source-debug
else
  fzf-tab-source-debug
fi
