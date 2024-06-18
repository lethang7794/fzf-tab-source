# :fzf-tab:complete:(\\|*/|)pip(|3*):argument-1

if bash -c "tldr pip $word" >>/dev/null 2>&1; then
  echo "$ tldr pip $word"
  tldr --color=always pip $word | tail -n +3
fi

echo \$ pip help $word
pip help $word | bat -pl help
