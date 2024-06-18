# :fzf-tab:complete:docker-*:argument-1
echo ':fzf-tab:complete:docker-*:argument-1'

if [[ "${group}" == "context" ]]; then
  echo \$ docker context inspect $word
  docker context inspect $word | bat -pl json
else
  fzf-tab-source-debug
fi
