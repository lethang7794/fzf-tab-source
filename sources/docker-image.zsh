# :fzf-tab:complete:docker-image:*
echo ':fzf-tab:complete:docker-image:*'

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
  docker image inspect $word | bat -pl json
else
  fzf-tab-source-debug
fi
