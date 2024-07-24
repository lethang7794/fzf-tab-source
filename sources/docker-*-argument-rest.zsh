# :fzf-tab:complete:docker-*:argument-rest

if [[ $group == "docker image command" ]]; then
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

elif [[ "$group" == "containers" ]]; then
  local inspect_output=$(docker container inspect $word)
  local container_status=$(echo $inspect_output | jq '.[0].State.Status')

  if [[ $container_status == "\"running\"" ]]; then
    echo \$ docker container top $word
    docker container top $word | bat -pl bash
    echo
  fi

  echo \$ docker container inspect $word
  echo $inspect_output | jq --color-output

elif [[ $words == "docker container inspect " ]]; then
  echo \$ docker container inspect $word
  docker container inspect $word | jq --color-output

elif [[ $words == "docker container logs " ]]; then
  echo \$ docker container logs $word
  docker container logs $word | bat -pl log

else
  # debug
fi

debug
