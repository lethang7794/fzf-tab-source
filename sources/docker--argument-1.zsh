# :fzf-tab:complete:docker-*:argument-1
echo ':fzf-tab:complete:docker-*:argument-1'

if [[ $group == "docker command" ]]; then

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

elif [[ $group == "docker image command" ]]; then
  echo \$ docker image $word --help
  docker image $word --help

elif [[ $group == "repositories" ]]; then
  echo \$ docker images $word
  if [ "$(command -v docker-color-output)" ]; then
    docker images $word | docker-color-output
  else
    docker images $word
  fi

elif [[ $group == "images" ]]; then
  echo \$ docker image inspect $word
  docker image inspect $word | jq --color-output

elif [[ $group == "containers" ]]; then
  echo \$ docker container inspect $word
  docker container inspect $word | jq --color-output

elif [[ $group == "context" ]]; then
  echo \$ docker context inspect $word
  docker context inspect $word | jq --color-output

else
  debug
fi
