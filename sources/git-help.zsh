# :fzf-tab:complete:((\\|*/|)git|git-help):argument-1
if bash -c "tldr git $word" >>/dev/null 2>&1; then
  eval "tldr --color=always git $word"
else
  git help $word | bat -lhelp
fi
