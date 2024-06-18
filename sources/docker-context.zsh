# :fzf-tab:complete:docker-context:*
echo ':fzf-tab:complete:docker-context:*'

if bash -c "tldr docker context $word" >>/dev/null 2>&1; then
  echo "$ tldr docker context $word"
  tldr --color=always docker context $word | tail -n +3
fi

if bash -c "docker context $word --help" >>/dev/null 2>&1; then
  echo "$ docker context $word --help"
  docker context $word --help | bat -lhelp
fi

fzf-tab-source-debug
