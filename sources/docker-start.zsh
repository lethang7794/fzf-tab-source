# :fzf-tab:complete:docker-start:argument-rest

if [[ "$group" == "containers" ]]; then
  echo \$ docker container inspect $word
  docker container inspect $word | jq --color-output
else
  debug
fi
