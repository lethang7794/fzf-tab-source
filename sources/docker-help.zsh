# :fzf-tab:complete:((\\|*/|)docker|docker-help):argument-1
echo ':fzf-tab:complete:((\\|*/|)docker|docker-help):argument-1'

if bash -c "tldr docker $word" >>/dev/null 2>&1; then
  echo "$ tldr docker $word"
  tldr --color=always docker $word | tail -n +3
fi

if bash -c "docker help $word" >>/dev/null 2>&1; then
  echo "$ docker help $word"
  docker help $word | bat -lhelp
fi