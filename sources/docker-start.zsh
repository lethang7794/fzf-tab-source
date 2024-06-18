# :fzf-tab:complete:docker-start:argument-rest

if [[ "$group" == "containers" ]]; then
  echo \$ docker container inspect $word
  docker container inspect $word | bat -pl json
else
  fzf-tab-source-debug
fi
