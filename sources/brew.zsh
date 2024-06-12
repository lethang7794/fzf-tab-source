# :fzf-tab:complete:(\\|*/|)brew:argument-1

if bash -c "tldr brew $word" 1>/dev/null 2>&1; then
  echo "\$ tldr brew $word"
  tldr --color=always brew $word
fi

echo "\$ brew $word --help"
brew $word --help
