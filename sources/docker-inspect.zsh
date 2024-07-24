# :fzf-tab:complete:docker-inspect:
# echo ':fzf-tab:complete:docker-inspect:'

echo "$ docker inspect $word"
docker inspect $word | jq --color-output
