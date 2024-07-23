# :fzf-tab:complete:docker-diff:*
# echo ':fzf-tab:complete:docker-diff:*'

if [[ "${group}" == "containers" ]]; then
  echo \$ docker diff $word
  diff=$(docker diff $word)
  if [[ -z "${diff}" ]]; then
    echo "No changes to files or directories on the container's filesystem"
  else
    echo $diff
  fi
else
  debug
fi
