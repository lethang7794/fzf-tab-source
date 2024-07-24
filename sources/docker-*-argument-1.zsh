# :fzf-tab:complete:docker-*:*
# echo ':fzf-tab:complete:docker-*:argument-1'

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
  local inspect_output=$(docker container inspect $word)
  local container_status=$(echo $inspect_output | jq '.[0].State.Status')
  echo

  if [[ $container_status == "\"running\"" ]]; then
    echo \$ docker container top $word
    docker container top $word | bat -pl bash
  fi

  echo \$ docker container inspect $word
  echo $inspect_output | jq --color-output

elif [[ $group == "context" ]]; then
  echo \$ docker context inspect $word
  docker context inspect $word | jq --color-output

else
  # debug
fi

debug
