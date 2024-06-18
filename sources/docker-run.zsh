# :fzf-tab:complete:docker-(run|images):argument-1
echo ':fzf-tab:complete:docker-(run|images):argument-1'

if [[ $group == "repositories" ]]; then
  echo \$ docker images $word
  if [ "$(command -v docker-color-output)" ]; then
    docker images $word | docker-color-output
  else
    docker images $word
  fi
elif [[ $group == "repositories with tags" ]]; then
  echo \$ docker image inspect $word
  docker image inspect $word | bat -pl json
elif [[ $group == "images" ]]; then
  echo \$ docker image inspect $word
  docker image inspect $word | bat -pl json
else
  fzf-tab-source-debug
fi
